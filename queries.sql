-- ----------------------------------------------------------------------------------------------------------------------

-- 3.1. Average Rating (score) per cook and national cuisine (check)
CREATE OR REPLACE VIEW AverageScorePerCook AS
SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    AVG(jps.Score) AS avg_score
FROM 
    Judge_Participant_Scores jps
INNER JOIN 
    Episode_has_Participants ehp ON jps.Participant_id = ehp.Participant_id
INNER JOIN 
    Cook c ON ehp.Cook_idCook = c.idCook
GROUP BY 
    c.idCook
ORDER BY 
    idCook ASC;
    
-- and national cuisine (check)
CREATE OR REPLACE VIEW AverageScorePerCuisine AS
SELECT 
    cu.idCuisine,
    cu.Cuisine,
    AVG(jps.Score) AS avg_score
FROM 
    Judge_Participant_Scores jps
INNER JOIN 
    Episode_has_Participants ehp ON jps.Participant_id = ehp.Participant_id
INNER JOIN 
    Cuisine cu ON ehp.Cuisine_idCuisine = cu.idCuisine
GROUP BY 
    cu.idCuisine
ORDER BY 
    idCuisine ASC;


DELIMITER //

CREATE PROCEDURE AVG_SCORE_CUISINE_COOK()
BEGIN
	SELECT * FROM AverageScorePerCook;
    SELECT * FROM AverageScorePerCuisine;
END //

DELIMITER ;

-- 3.2.a For a given National Cuisine the cooks belonging to it (check)
DELIMITER //

CREATE PROCEDURE CheckCuisineAndCooks(IN cuisine_name VARCHAR(255))
BEGIN
    DECLARE cuisine_count INT;

	IF (SELECT COUNT(*)
		FROM Cook c
		JOIN Cook_has_Cuisine chc ON c.idCook = chc.Cook_idCook
		JOIN Cuisine cu ON chc.Cuisine_idCuisine = cu.idCuisine
		WHERE cu.Cuisine = cuisine_name) = 0 THEN
		SELECT 'There are no cooks for the given cuisine' AS message;
	ELSE
		-- Retrieve the cooks belonging to the given cuisine
		SELECT 
			c.idCook,
			c.first_name,
			c.last_name
		FROM 
			Cook c
		JOIN 
			Cook_has_Cuisine chc ON c.idCook = chc.Cook_idCook
		JOIN 
			Cuisine cu ON chc.Cuisine_idCuisine = cu.idCuisine
		WHERE 
			cu.Cuisine = cuisine_name;
	END IF;
END //

DELIMITER ;



-- 3.2.b For a given season, the cooks participated in episodes (check)
DELIMITER //

CREATE PROCEDURE GetCooksBySeason(IN season_number INT)
BEGIN

        -- Retrieve cooks involved in the given season
        SELECT DISTINCT
            c.idCook,
            c.first_name,
            c.last_name,
            cu.Cuisine AS National_Cuisine,
            COUNT(DISTINCT ehp.Episode_idEpisode) AS episodes_involved
        FROM 
            Cook c
        LEFT JOIN 
            Episode_has_Participants ehp ON c.idCook = ehp.Cook_idCook
        LEFT JOIN 
            Episode ep ON ehp.Episode_idEpisode = ep.idEpisode
        LEFT JOIN 
            Cuisine cu ON ehp.Cuisine_idCuisine = cu.idCuisine
        WHERE 
            ep.Season_number = season_number
        GROUP BY 
            c.idCook, cu.Cuisine
        HAVING 
            episodes_involved > 0;
END //

DELIMITER ;




-- 3.3 The young cooks (age < 30 years) who have the most recipes (check)
CREATE VIEW CookRecipeCount AS
SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    c.age,
    COUNT(r.idRecipe) AS recipe_count
FROM 
    Cook c
JOIN 
    Episode_has_Participants ehp ON c.idCook = ehp.Cook_idCook
JOIN 
    Recipe r ON ehp.Recipe_idRecipe = r.idRecipe
WHERE 
    c.age < 30
GROUP BY 
    c.idCook
ORDER BY 
    recipe_count DESC;


DELIMITER //

CREATE PROCEDURE GetYoungCooksWithMostRecipes()
BEGIN
    DECLARE max_recipe_count INT;

    -- Find the maximum recipe count
    SELECT MAX(recipe_count) INTO max_recipe_count FROM CookRecipeCount;

    -- Retrieve the cooks with the maximum recipe count
    SELECT * FROM CookRecipeCount WHERE recipe_count = max_recipe_count;
END //

DELIMITER ;


-- 3.4 Cooks who have never judged an episode (check)
CREATE VIEW CooksNeverJudged AS
	SELECT 
		c.idCook,
		c.first_name,
		c.last_name,
		c.age
	FROM 
		Cook c
	LEFT JOIN 
		Episode_has_Judges ehj ON c.idCook = ehj.Cook_idCook
	WHERE 
		ehj.Cook_idCook IS NULL;


DELIMITER //

CREATE PROCEDURE GetCooksNeverJudged()
BEGIN
    SELECT * FROM CooksNeverJudged;
END //

DELIMITER ;

-- 3.5 Judges who have participated in the same number of episodes over a period of one year with (check)
CREATE VIEW JudgesSameNumberOfEpisodes AS
    SELECT 
        ej.Cook_idCook AS idJudge,
        c.first_name,
        c.last_name,
        COUNT(ej.Episode_idEpisode) AS num_episodes
    FROM 
        Episode_has_Judges ej
    INNER JOIN 
        Episode e ON ej.Episode_idEpisode = e.idEpisode
    INNER JOIN 
        Cook c ON ej.Cook_idCook = c.idCook
    WHERE 
        e.last_update >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
    GROUP BY 
        ej.Cook_idCook, c.first_name, c.last_name
    HAVING 
        num_episodes >= 3;





DELIMITER //

CREATE PROCEDURE JudgesWithSameNumberOfEpisodes()
BEGIN
    SELECT *
    FROM JudgesSameNumberOfEpisodes
    ORDER BY num_episodes DESC;
END //

DELIMITER ;



-- 3.7 All cooks who have participated at least 5 fewer times than the cook with the most episodes(check)
CREATE VIEW CooksWithFewerParticipations AS
SELECT c.idCook, c.first_name, c.last_name
FROM Cook c
JOIN (
    SELECT Cook_idCook, COUNT(*) AS max_participations
    FROM Episode_has_Participants
    GROUP BY Cook_idCook
    ORDER BY max_participations DESC
    LIMIT 1
) AS max_episodes ON c.idCook <> max_episodes.Cook_idCook
JOIN (
    SELECT Cook_idCook, COUNT(*) AS num_participations
    FROM Episode_has_Participants
    GROUP BY Cook_idCook
) AS cook_participations ON c.idCook = cook_participations.Cook_idCook
WHERE max_episodes.max_participations - cook_participations.num_participations >= 5;

	

DELIMITER //

CREATE PROCEDURE CallCooksWithFewerParticipations()
BEGIN
    -- Selecting data from the view
    SELECT *
    FROM CooksWithFewerParticipations;
END //

DELIMITER ;

    
-- 3.9 List of average number of grams of carbohydrates in the competition per sezon(check)
CREATE VIEW AverageCarbohydratesPerSeason AS
SELECT
    e.Season_number,
    AVG(i.carbohydrate) AS average_carbohydrates
FROM
    Episode e
JOIN
    Episode_has_Participants ep ON e.idEpisode = ep.Episode_idEpisode
JOIN
    Recipe r ON ep.Recipe_idRecipe = r.idRecipe
JOIN
    Recipe_has_Ingredients ri ON r.idRecipe = ri.Recipe_idRecipe
JOIN
    Ingredients i ON ri.Ingredients_idIngredients = i.idIngredients
GROUP BY
    e.Season_number;



DELIMITER //

CREATE PROCEDURE CalculateAverageCarbohydratesPerSeason()
BEGIN
    SELECT * FROM AverageCarbohydratesPerSeason;
END //

DELIMITER ;



-- 3.10 Cuisines have the same number of entries in competitions over two consecutive years, with at least 3 entries per year(check)
DELIMITER //

CREATE PROCEDURE FindCuisinesWithConsistentAppearance()
BEGIN
    -- Create a temporary table to store the counts of cuisine appearances in each season
    CREATE TEMPORARY TABLE CuisineAppearanceCounts (
        Cuisine_id INT UNSIGNED,
        Season_number INT UNSIGNED,
        Appearances INT,
        PRIMARY KEY (Cuisine_id, Season_number)
    );

    -- Insert the counts of cuisine appearances in each season into the temporary table
    INSERT INTO CuisineAppearanceCounts
    SELECT ehp.Cuisine_idCuisine, e.Season_number, COUNT(*) AS Appearances
    FROM Episode_has_Participants ehp
    JOIN Episode e ON ehp.Episode_idEpisode = e.idEpisode
    GROUP BY ehp.Cuisine_idCuisine, e.Season_number;

    -- Select cuisines that appear the same number of times in all seasons with at least three appearances in each season
    SELECT Cuisine_id
    FROM CuisineAppearanceCounts
    GROUP BY Cuisine_id
    HAVING COUNT(DISTINCT Season_number) = (SELECT COUNT(DISTINCT Season_number) FROM Episode)
    AND MIN(Appearances) >= 3;

    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS CuisineAppearanceCounts;
END //

DELIMITER ;



-- 3.11 Top 5 reviewers who have given the highest overall rating to a cook(check)

CREATE VIEW Top5JudgesByTotalScore AS
SELECT 
    js.Judge_idJudge,
    epj.Cook_idCook,
    c.first_name AS cook_first_name,
    c.last_name AS cook_last_name,
    SUM(js.Score) AS total_score
FROM 
    Judge_Participant_Scores js
INNER JOIN 
    Episode_has_Judges epj ON js.Judge_idJudge = epj.Judge_idJudge
INNER JOIN 
    Cook c ON epj.Cook_idCook = c.idCook
GROUP BY 
    js.Judge_idJudge, epj.Cook_idCook
ORDER BY 
    total_score DESC
LIMIT 5;

    

DELIMITER //

CREATE PROCEDURE CallTop5JudgesByTotalScore()
BEGIN
    -- Select from the view to get the cuisines with the same number of entries over two consecutive years
    SELECT * FROM Top5JudgesByTotalScore ;
END //

DELIMITER ;

-- 3.12 (check)
CREATE VIEW MostDifficultEpisodePerSeason AS
SELECT
    ep.Season_number,
    ep.idEpisode,
    SUM(r.difficulty) AS total_difficulty
FROM
    Episode ep
    INNER JOIN Episode_has_Participants ehp ON ep.idEpisode = ehp.Episode_idEpisode
    INNER JOIN Recipe r ON ehp.Recipe_idRecipe = r.idRecipe
GROUP BY
    ep.Season_number, ep.idEpisode;

DELIMITER //

CREATE PROCEDURE GetMostDifficultEpisodes()
BEGIN
    DECLARE max_difficulty INT;

    -- Find the maximum total difficulty
    SELECT MAX(total_difficulty) INTO max_difficulty
    FROM MostDifficultEpisodePerSeason;

    -- Select all episodes with the maximum total difficulty
    SELECT *
    FROM MostDifficultEpisodePerSeason
    WHERE total_difficulty = max_difficulty;
END //

DELIMITER ;



-- 3.13 (check)

CREATE OR REPLACE VIEW Episode_Sum_Status AS
SELECT
    ep.idEpisode,
    SUM(CASE
            WHEN c.Status = 'C cook' THEN 1
            WHEN c.Status = 'B cook' THEN 2
            WHEN c.Status = 'A cook' THEN 3
            WHEN c.Status = 'assistant head Chef' THEN 4
            WHEN c.Status = 'Chef' THEN 5
            ELSE 0
        END) AS cook_status_sum,
    SUM(CASE
            WHEN ehj.Judge_idJudge IS NOT NULL THEN
                CASE
                    WHEN cj.Status = 'C cook' THEN 1
                    WHEN cj.Status = 'B cook' THEN 2
                    WHEN cj.Status = 'A cook' THEN 3
                    WHEN cj.Status = 'assistant head Chef' THEN 4
                    WHEN cj.Status = 'Chef' THEN 5
                    ELSE 0
                END
            ELSE 0
        END) AS judge_status_sum
FROM
    Episode ep
    LEFT JOIN Episode_has_Participants ehp ON ep.idEpisode = ehp.Episode_idEpisode
    LEFT JOIN Cook c ON ehp.Cook_idCook = c.idCook
    LEFT JOIN Episode_has_Judges ehj ON ep.idEpisode = ehj.Episode_idEpisode
    LEFT JOIN Cook cj ON ehj.Judge_idJudge = cj.idCook
GROUP BY
    ep.idEpisode;




DELIMITER //

CREATE PROCEDURE LowestSumStatusEpisode()
BEGIN
    DECLARE min_sum INT;

    -- Find the minimum sum of status scores
    SELECT MIN(cook_status_sum + judge_status_sum)
    INTO min_sum
    FROM Episode_Sum_Status;

    -- Select the episode with the lowest sum of status scores
    SELECT idEpisode
    FROM Episode_Sum_Status
    WHERE (cook_status_sum + judge_status_sum) = min_sum;
END //

DELIMITER ;


-- 3.14  Theme has appeared most often in the competition(check)
CREATE VIEW MostCommonConceptAllEpisodes AS
SELECT Concept_name AS Most_Common_Concept
FROM (
    SELECT Concept_idConcept, COUNT(*) AS concept_count
    FROM Recipe_has_Concept
    JOIN Recipe ON Recipe_has_Concept.Recipe_idRecipe = Recipe.idRecipe
    JOIN Episode_has_Participants ON Recipe.idRecipe = Episode_has_Participants.Recipe_idRecipe
    JOIN Episode ON Episode_has_Participants.Episode_idEpisode = Episode.idEpisode
    GROUP BY Concept_idConcept
    ORDER BY concept_count DESC
    LIMIT 1
) AS most_common
JOIN Concept ON most_common.Concept_idConcept = Concept.idConcept;

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetMostCommonConcept()
BEGIN
	SELECT * FROM MostCommonConceptAllEpisodes;
END //

DELIMITER ;

-- 3.15 (check)
CREATE VIEW UnusedFoodGroupsView AS
    SELECT fg.*
    FROM Food_Group fg
    LEFT JOIN (
        SELECT DISTINCT ig.Food_Group_idFood_Group
        FROM Recipe_has_Ingredients rhi
        JOIN Ingredients ig ON rhi.Ingredients_idIngredients = ig.idIngredients
        JOIN Episode_has_Participants ehp ON rhi.Recipe_idRecipe = ehp.Recipe_idRecipe
    ) rhi ON fg.idFood_Group = rhi.Food_Group_idFood_Group
    WHERE rhi.Food_Group_idFood_Group IS NULL;
    
DELIMITER //

CREATE PROCEDURE GetUnusedFoodGroups()
BEGIN
	SELECT * FROM UnusedFoodGroupsView;
END //

DELIMITER ;

-- 3.6
DELIMITER //

CREATE PROCEDURE FindTopLabelPairs()
BEGIN
    SELECT 
        lh1.Label_idLabel AS label1_id,
        lh2.Label_idLabel AS label2_id,
        COUNT(*) AS pair_count
    FROM 
        Recipe_has_Label lh1
    INNER JOIN 
        Recipe_has_Label lh2 ON lh1.Recipe_idRecipe = lh2.Recipe_idRecipe
                              AND lh1.Label_idLabel < lh2.Label_idLabel
    GROUP BY 
        lh1.Label_idLabel, lh2.Label_idLabel
    ORDER BY 
        pair_count DESC
    LIMIT 3;
END //

DELIMITER ;

EXPLAIN
SELECT 
    lh1.Label_idLabel AS label1_id,
    lh2.Label_idLabel AS label2_id,
    COUNT(*) AS pair_count
FROM 
    Recipe_has_Label lh1
INNER JOIN 
    Recipe_has_Label lh2 ON lh1.Recipe_idRecipe = lh2.Recipe_idRecipe
                          AND lh1.Label_idLabel < lh2.Label_idLabel
GROUP BY 
    lh1.Label_idLabel, lh2.Label_idLabel
ORDER BY 
    pair_count DESC
LIMIT 3;


-- 3.8

DELIMITER //

CREATE PROCEDURE FindEpisodeWithMostEquipmentUsed()
BEGIN
    DECLARE max_equipment_used INT;

    -- Find the maximum total equipment used
    SELECT 
        MAX(equipment_count) INTO max_equipment_used
    FROM (
        SELECT 
            COUNT(rhe.Equipment_idEquipment) AS equipment_count
        FROM 
            Episode e
        INNER JOIN 
            Episode_has_Participants ehp ON e.idEpisode = ehp.Episode_idEpisode
        INNER JOIN 
            Recipe_has_Equipment rhe ON ehp.Recipe_idRecipe = rhe.Recipe_idRecipe
        GROUP BY 
            e.idEpisode
    ) AS EquipmentCounts;

    -- Select all episodes with the maximum total equipment used
    SELECT 
        e.idEpisode,
        e.Episode_number,
        e.Season_number,
        COUNT(rhe.Equipment_idEquipment) AS total_equipment_used
    FROM 
        Episode e
    INNER JOIN 
        Episode_has_Participants ehp ON e.idEpisode = ehp.Episode_idEpisode
    INNER JOIN 
        Recipe_has_Equipment rhe ON ehp.Recipe_idRecipe = rhe.Recipe_idRecipe
    GROUP BY 
        e.idEpisode
    HAVING 
        total_equipment_used = max_equipment_used;
END //

DELIMITER ;

EXPLAIN
SELECT 
    MAX(equipment_count) INTO max_equipment_used
FROM (
    SELECT 
        COUNT(rhe.Equipment_idEquipment) AS equipment_count
    FROM 
        Episode e FORCE INDEX (PRIMARY)
    INNER JOIN 
        Episode_has_Participants ehp FORCE INDEX (idx_Episode_idEpisode) ON e.idEpisode = ehp.Episode_idEpisode
    INNER JOIN 
        Recipe_has_Equipment rhe FORCE INDEX (idx_Recipe_idRecipe) ON ehp.Recipe_idRecipe = rhe.Recipe_idRecipe
    GROUP BY 
        e.idEpisode
) AS EquipmentCounts;

EXPLAIN
SELECT 
    e.idEpisode,
    e.Episode_number,
    e.Season_number,
    COUNT(rhe.Equipment_idEquipment) AS total_equipment_used
FROM 
    Episode e FORCE INDEX (PRIMARY)
INNER JOIN 
    Episode_has_Participants ehp FORCE INDEX (idx_Episode_idEpisode) ON e.idEpisode = ehp.Episode_idEpisode
INNER JOIN 
    Recipe_has_Equipment rhe FORCE INDEX (idx_Recipe_idRecipe) ON ehp.Recipe_idRecipe = rhe.Recipe_idRecipe
GROUP BY 
    e.idEpisode
HAVING 
    total_equipment_used = max_equipment_used;
