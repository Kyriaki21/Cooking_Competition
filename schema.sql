DROP SCHEMA IF EXISTS Cooking_Competition;
CREATE SCHEMA Cooking_Competition;
USE Cooking_Competition;

CREATE TABLE `Cooking_Competition`.`Image` (
  `idImage` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Description` TEXT NOT NULL,
  `URL` VARCHAR(255) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idImage`))
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Cuisine` (
  `idCuisine` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cuisine` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Cuisine_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Cuisine_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idCuisine`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	
CREATE TABLE `Cooking_Competition`.`Type_Meal` (
  `idType_Meal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type_Meal` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Type_Meal_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Type_Meal_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idType_Meal`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Food_Group` (
  `idFood_Group` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_food_group` VARCHAR(45) NOT NULL,
  `description_food_group` TEXT NOT NULL,
  `Recipe_Category` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Food_Group_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Food_Group_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idFood_Group`),
  UNIQUE INDEX `name_food_group_UNIQUE` (`name_food_group` ASC))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Cooking_Competition.Recipe (
  idRecipe INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  `description` TEXT NOT NULL,
  difficulty TINYINT NOT NULL,
  prep_time TINYINT NOT NULL,
  cook_time TINYINT NOT NULL,
  portions TINYINT NOT NULL,
  total_calories DECIMAL(10,2) NULL,
  total_fat DECIMAL(10,2) NULL,
  total_protein DECIMAL(10,2) NULL,
  total_carbohydrate DECIMAL(10,2) NULL,
  Cuisine_id INT UNSIGNED NOT NULL,
  Type_Meal INT UNSIGNED NOT NULL,
  syntagi ENUM('cooking', 'pastry') NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  Image INT UNSIGNED NOT NULL,
  PRIMARY KEY (idRecipe),
  INDEX fk_Recipe_Image_idx (Image ASC),
  CONSTRAINT fk_Recipe_Image
    FOREIGN KEY (Image)
    REFERENCES Cooking_Competition.Image (idImage)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  INDEX fk_Recipe_Cuisine1_idx (Cuisine_id ASC),
  INDEX fk_Recipe_Type_Meal1_idx (Type_Meal ASC),
  CONSTRAINT fk_Recipe_Cuisine1
    FOREIGN KEY (Cuisine_id)
    REFERENCES Cooking_Competition.Cuisine (idCuisine)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_Recipe_Type_Meal1
    FOREIGN KEY (Type_Meal)
    REFERENCES Cooking_Competition.Type_Meal (idType_Meal)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT range_dif CHECK (difficulty BETWEEN 1 AND 5),
  CONSTRAINT prep_time_check CHECK (prep_time >= 0),
  CONSTRAINT portions_check CHECK (portions > 0),
  CONSTRAINT cook_time_check CHECK (cook_time >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Tips` (
  `idTips` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Tip_description` TEXT NOT NULL,
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idTips`),
  INDEX `fk_Tips_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT `fk_Tips_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Steps` (
  `idSteps` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Step_number` TINYINT NOT NULL,
  `Step_description` TEXT NOT NULL,
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idSteps`),
  INDEX `fk_Steps_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT `fk_Steps_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Concept` (
  `idConcept` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Concept_name` VARCHAR(255) NOT NULL,
  `Concept_description` TEXT DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Concept_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Concept_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idConcept`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Recipe_has_Concept` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Concept_idConcept` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Concept_idConcept`),
  INDEX `fk_Recipe_has_Concept_Concept1_idx` (`Concept_idConcept` ASC)  ,
  INDEX `fk_Recipe_has_Concept_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT unique_rec_concept UNIQUE (Recipe_idRecipe,Concept_idConcept),
  CONSTRAINT `fk_Recipe_has_Concept_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Concept_Concept1`
    FOREIGN KEY (`Concept_idConcept`)
    REFERENCES `Cooking_Competition`.`Concept` (`idConcept`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Cook` (
  `idCook` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_number` VARCHAR(15) NOT NULL,
  `birth_date` DATE NOT NULL,
  `age` INT NOT NULL,
  `Years_experience` INT NOT NULL,
  `Status` ENUM('C cook', 'B cook', 'A cook', 'assistant head Chef', 'Chef') NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Cook_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Cook_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idCook`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Cook` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Cook_idCook`),
  INDEX `fk_Recipe_has_Cook_Cook1_idx` (`Cook_idCook` ASC),
  INDEX `fk_Recipe_has_Cook_Recipe1_idx` (`Recipe_idRecipe` ASC),
  CONSTRAINT `fk_Recipe_has_Cook_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Cook_Cook1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Label` (
  `idLabel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Label_name` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idLabel`),
  UNIQUE INDEX `Label_name_UNIQUE` (`Label_name` ASC),
  INDEX `fk_Label_Image_idx` (`Image` ASC),
  CONSTRAINT `fk_Label_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Label` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Label_idLabel` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Label_idLabel`),
  INDEX `fk_Recipe_has_Label_Label1_idx` (`Label_idLabel` ASC),
  INDEX `fk_Recipe_has_Label_Recipe1_idx` (`Recipe_idRecipe` ASC),
  CONSTRAINT `fk_Recipe_has_Label_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Label_Label1`
    FOREIGN KEY (`Label_idLabel`)
    REFERENCES `Cooking_Competition`.`Label` (`idLabel`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Equipment` (
  `idEquipment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `equip_name` VARCHAR(45) NOT NULL,
  `equip_use` TEXT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Equipment_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Equipment_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idEquipment`),
  UNIQUE INDEX `equip_name_UNIQUE` (`equip_name` ASC)  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Equipment` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Equipment_idEquipment` INT UNSIGNED NOT NULL,
  `Quantity` TINYINT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Equipment_idEquipment`),
  INDEX `fk_Recipe_has_Equipment_Equipment1_idx` (`Equipment_idEquipment` ASC)  ,
  INDEX `fk_Recipe_has_Equipment_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT unique_rec_label UNIQUE (Recipe_idRecipe,Equipment_idEquipment),
  CONSTRAINT `fk_Recipe_has_Equipment_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Equipment_Equipment1`
    FOREIGN KEY (`Equipment_idEquipment`)
    REFERENCES `Cooking_Competition`.`Equipment` (`idEquipment`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Ingredients` (
  `idIngredients` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Ingredient_name` VARCHAR(45) NOT NULL,
  `fat` INT NULL,
  `protein` INT NULL,
  `carbohydrate` INT NULL,
  `calories` INT NULL,
  `Food_Group_idFood_Group` INT UNSIGNED NOT NULL,
  `Measurement_Type` VARCHAR(45) NOT NULL,
  `Default_scale` TINYINT NOT NULL DEFAULT 100,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Ingedient_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Ingedient_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idIngredients`),
  INDEX `fk_Ingredients_Food_Group_idx` (`Food_Group_idFood_Group` ASC)  ,
  CONSTRAINT `fk_Ingredients_Food_Group`
    FOREIGN KEY (`Food_Group_idFood_Group`)
    REFERENCES `Cooking_Competition`.`Food_Group` (`idFood_Group`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT fat_pos_constraint CHECK (COALESCE(fat, 0) >= 0),
    CONSTRAINT protein_pos_constraint CHECK (COALESCE(protein, 0) >= 0),
    CONSTRAINT carbohydrate_pos_constraint CHECK (COALESCE(carbohydrate, 0) >= 0),
    CONSTRAINT calories_pos_constraint CHECK (COALESCE(calories, 0) >= 0),
    UNIQUE INDEX  `Ingredient_name_UNIQUE` (`Ingredient_name` ASC)  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Ingredients` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Ingredients_idIngredients` INT UNSIGNED NOT NULL,
  `Quantity` DECIMAL(10,2) NOT NULL,
  `is_basic` TINYINT NOT NULL DEFAULT 0,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Ingredients_idIngredients`),
  INDEX `fk_Recipe_has_Ingredients_Ingredients1_idx` (`Ingredients_idIngredients` ASC)  ,
  INDEX `fk_Recipe_has_Ingredients_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT unique_rec_label UNIQUE (Recipe_idRecipe,Ingredients_idIngredients),
  CONSTRAINT chk_basic CHECK (is_basic IN (0, 1)),
  CONSTRAINT quantity_pos CHECK (Quantity > 0),
  CONSTRAINT `fk_Recipe_has_Ingredients_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Ingredients_Ingredients1`
    FOREIGN KEY (`Ingredients_idIngredients`)
    REFERENCES `Cooking_Competition`.`Ingredients` (`idIngredients`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Cook_has_Cuisine` (
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `Cuisine_idCuisine` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Cook_idCook`, `Cuisine_idCuisine`),
  INDEX `fk_Cook_Cuisine_Cuisine1_idx` (`Cuisine_idCuisine` ASC),
  INDEX `fk_Cook_Cuisine_Cook1_idx` (`Cook_idCook` ASC),
  CONSTRAINT `unique_rec_concept` UNIQUE (`Cook_idCook`, `Cuisine_idCuisine`),
  CONSTRAINT `fk_Cook_Cuisine_Cook1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Cook_Cuisine_Cuisine1`
    FOREIGN KEY (`Cuisine_idCuisine`)
    REFERENCES `Cooking_Competition`.`Cuisine` (`idCuisine`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode` (
  `idEpisode` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Episode_number` INT NOT NULL,
  `Season_number` INT UNSIGNED NOT NULL,
  `winner_id` INT UNSIGNED NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEpisode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode_has_Participants` (
  `Participant_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Cuisine_idCuisine` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Participant_id`),
  INDEX `fk_Episode_Participant_Episode1_idx` (`Episode_idEpisode` ASC),
  INDEX `fk_Episode_Participant_Cook1_idx` (`Cook_idCook` ASC),
  INDEX `fk_Episode_Participant_Recipe1_idx` (`Recipe_idRecipe` ASC),
  INDEX `fk_Episode_Participant_Cuisine1_idx` (`Cuisine_idCuisine` ASC),
  UNIQUE INDEX `unique_Episode_Cook` (`Episode_idEpisode`, `Cook_idCook`),
  UNIQUE INDEX `unique_Episode_Cuisine` (`Episode_idEpisode`, `Cuisine_idCuisine`),
  UNIQUE INDEX `unique_Episode_Recipe` (`Episode_idEpisode`, `Recipe_idRecipe`),
  CONSTRAINT `fk_Episode_Participant_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Participant_Cook1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Participant_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Participant_Cuisine1`
    FOREIGN KEY (`Cuisine_idCuisine`)
    REFERENCES `Cooking_Competition`.`Cuisine` (`idCuisine`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode_has_Judges` (
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Judge_idJudge` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Judge_idJudge`),
  INDEX `fk_Episode_Judge_Episode1_idx` (`Episode_idEpisode` ASC),
  INDEX `fk_Episode_Judge_Cook1_idx` (`Cook_idCook` ASC),
  CONSTRAINT `fk_Episode_Judge_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Judge_Cook1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Judge_Participant_Scores` (
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Participant_id` INT UNSIGNED NOT NULL,
  `Judge_idJudge` INT UNSIGNED NOT NULL,
  `Score` TINYINT NULL CHECK (Score BETWEEN 1 AND 5),
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Episode_idEpisode`, `Judge_idJudge`, `Participant_id`),
  INDEX `fk_Judge_Participant_Scores_Episode1_idx` (`Episode_idEpisode` ASC),
  INDEX `fk_Judge_Participant_Scores_Judge1_idx` (`Judge_idJudge` ASC),
  INDEX `fk_Judge_Participant_Scores_Participant1_idx` (`Participant_id` ASC),
  CONSTRAINT `fk_Judge_Participant_Scores_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Judge_Participant_Scores_Judge1`
    FOREIGN KEY (`Judge_idJudge`)
    REFERENCES `Cooking_Competition`.`Episode_has_Judges` (`Judge_idJudge`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Judge_Participant_Scores_Participant1`
    FOREIGN KEY (`Participant_id`)
    REFERENCES `Cooking_Competition`.`Episode_has_Participants` (`Participant_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Procedure to update the recipe's nutritional values
--

DELIMITER //

CREATE PROCEDURE CalculateRecipeNutrition()
BEGIN
    DECLARE recipe_id INT;
    DECLARE ing_calories DECIMAL(10,2);
    DECLARE ing_fat DECIMAL(10,2);
    DECLARE ing_protein DECIMAL(10,2);
    DECLARE ing_carbohydrate DECIMAL(10,2);
    DECLARE total_calories DECIMAL(10,2);
    DECLARE total_fat DECIMAL(10,2);
    DECLARE total_protein DECIMAL(10,2);
    DECLARE total_carbohydrate DECIMAL(10,2);

    -- Declare cursor variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE recipe_cursor CURSOR FOR 
        SELECT idRecipe FROM Cooking_Competition.Recipe;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN recipe_cursor;

    -- Main loop to iterate through each recipe
    main_loop: LOOP
        -- Fetch recipe id
        FETCH recipe_cursor INTO recipe_id;

        -- Exit loop if no more recipes
        IF done THEN
            LEAVE main_loop;
        END IF;

        -- Reset total nutrition values
        SET total_calories = 0;
        SET total_fat = 0;
        SET total_protein = 0;
        SET total_carbohydrate = 0;

        -- Retrieve ingredients and aggregate nutrition for the current recipe
        SELECT 
            SUM(i.calories * ri.Quantity / 100) AS total_calories,
            SUM(i.fat * ri.Quantity / 100) AS total_fat,
            SUM(i.protein * ri.Quantity / 100) AS total_protein,
            SUM(i.carbohydrate * ri.Quantity / 100) AS total_carbohydrate
        INTO 
            ing_calories, ing_fat, ing_protein, ing_carbohydrate
        FROM 
            Cooking_Competition.Recipe_has_Ingredients ri
        INNER JOIN 
            Cooking_Competition.Ingredients i ON ri.Ingredients_idIngredients = i.idIngredients
        WHERE 
            ri.Recipe_idRecipe = recipe_id;

        -- Set total nutrition values
        SET total_calories = IFNULL(ing_calories, 0);
        SET total_fat = IFNULL(ing_fat, 0);
        SET total_protein = IFNULL(ing_protein, 0);
        SET total_carbohydrate = IFNULL(ing_carbohydrate, 0);

        -- Update Recipe table with total nutrition values
        UPDATE Cooking_Competition.Recipe 
        SET 
            total_calories = total_calories, 
            total_fat = total_fat, 
            total_protein = total_protein, 
            total_carbohydrate = total_carbohydrate 
        WHERE 
            idRecipe = recipe_id;
    END LOOP;

    -- Close recipe cursor
    CLOSE recipe_cursor;
END//

DELIMITER ;

-- Trigger for after inserting an ingredient
DELIMITER //

CREATE TRIGGER AfterInsertRecipeIngredient
AFTER INSERT ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL CalculateRecipeNutrition();
END //

DELIMITER ;

-- Trigger for after deleting an ingredient
DELIMITER //

CREATE TRIGGER AfterDeleteRecipeIngredient
AFTER DELETE ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL CalculateRecipeNutrition();
END //

DELIMITER ;

-- Trigger for updating ingredient values
DELIMITER //

CREATE TRIGGER BeforeUpdateIngredients
BEFORE UPDATE ON Ingredients
FOR EACH ROW
BEGIN
	IF NEW.fat != OLD.fat OR
       NEW.protein != OLD.protein OR
       NEW.carbohydrate != OLD.carbohydrate OR
       NEW.calories != OLD.calories THEN
		CALL CalculateRecipeNutrition();
	END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateRecipe_has_Ingredients
BEFORE UPDATE ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
	-- Check if any of the nutritional values are being updated
    IF NEW.Ingredients_idIngredients != OLD.Ingredients_idIngredients OR
       NEW.Quantity != OLD.Quantity OR
       NEW.Recipe_idRecipe != OLD.Recipe_idRecipe THEN
		CALL CalculateRecipeNutrition();
	END IF;
END //

DELIMITER ;

-- Trigger to limit the number of tips per recipe checked

DELIMITER //

CREATE TRIGGER CheckTipsCount
BEFORE INSERT ON Tips
FOR EACH ROW
BEGIN
    DECLARE tips_count INT;
    
    -- Count the number of tips for the given recipe
    SELECT COUNT(*) INTO tips_count
    FROM Tips
    WHERE Recipe_idRecipe = NEW.Recipe_idRecipe;
    
    -- If the count exceeds 3, raise an error
    IF tips_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A recipe cannot have more than 3 tips';
    END IF;
END//

DELIMITER ;

--
-- Procedure to calculate the episode winner
--

DELIMITER //

CREATE PROCEDURE CalculateEpisodeWinner(IN episode_id INT)
BEGIN
    DECLARE max_score INT;
    DECLARE winner_id INT;
    DECLARE max_qualification INT;
    DECLARE tie_winner_id INT;
    
    -- Calculate the maximum score given by the judges
    SELECT MAX(Score) INTO max_score
    FROM Episode_has_Participants
    WHERE Episode_idEpisode = episode_id;
    
    -- Find the participant(s) with the maximum score
    SELECT Cook_idCook INTO winner_id
    FROM Episode_has_Participants
    WHERE Episode_idEpisode = episode_id AND Score = max_score
    LIMIT 1; -- If there's a tie, select only the first participant
    
    -- Check if there's a tie
    IF (SELECT COUNT(*) FROM Episode_has_Participants WHERE Episode_idEpisode = episode_id AND Score = max_score) > 1 THEN
        -- Find the participant(s) with the highest professional qualification
        SELECT MAX(Years_experience) INTO max_qualification
        FROM Cook
        WHERE idCook IN (SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = episode_id AND Score = max_score);
        
        -- Find the participant(s) with the highest qualification
        SELECT Cook_idCook INTO tie_winner_id
        FROM Cook
        WHERE idCook IN (SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = episode_id AND Score = max_score)
        AND Years_experience = max_qualification
        LIMIT 1; -- If there's still a tie, select only the first participant
        
        -- If there's still a tie, select the winner randomly
        IF (SELECT COUNT(*) FROM Cook WHERE idCook IN (SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = episode_id AND Score = max_score AND Years_experience = max_qualification)) > 1 THEN
            SET tie_winner_id = (SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = episode_id AND Score = max_score AND Years_experience = max_qualification LIMIT 1);
        END IF;
        
        SET winner_id = tie_winner_id;
    END IF;
    
    -- Update the episode table with the winner
    UPDATE Episode
    SET winner_id = winner_id
    WHERE idEpisode = episode_id;
END //

DELIMITER ;

--
-- Trigger to ensure steps are inserted in order
--

DELIMITER //

CREATE TRIGGER BeforeInsertStep
BEFORE INSERT ON Steps
FOR EACH ROW
BEGIN
    DECLARE prevStep TINYINT;

    -- Find the step number of the previous step for the given recipe
    SELECT Step_number 
    INTO prevStep 
    FROM Steps 
    WHERE Recipe_idRecipe = NEW.Recipe_idRecipe 
    ORDER BY Step_number DESC 
    LIMIT 1;

    -- If the previous step exists and the new step number is not consecutive, raise an error
    IF prevStep IS NOT NULL AND NEW.Step_number != prevStep + 1 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Previous step does not exist or step numbers are not consecutive for this recipe. Please insert the steps for this recipe in the correct order.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_insert_recipe_has_cook
BEFORE INSERT ON Recipe_has_Cook
FOR EACH ROW
BEGIN
    DECLARE cuisine_exists INT;
    
    -- Check if the cook has the cuisine associated with the recipe
    SELECT COUNT(*) INTO cuisine_exists
    FROM Cook_has_Cuisine
    WHERE Cook_idCook = NEW.Cook_idCook AND Cuisine_idCuisine = (
        SELECT Cuisine_id
        FROM Recipe
        WHERE idRecipe = NEW.Recipe_idRecipe
    );
    
    -- If the cook doesn't have the required cuisine, raise an error
    IF cuisine_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cook does not have the required cuisine for this recipe';
    END IF;
END;

DELIMITER ;

DELIMITER //

CREATE PROCEDURE CreateSeasonsEpisodes(IN num_seasons INT)
BEGIN
    DECLARE season_no INT DEFAULT 1;
    DECLARE episode_no INT DEFAULT 1;

    WHILE season_no <= num_seasons DO
        SET episode_no = 1;
        WHILE episode_no <= 10 DO
            -- Insert Episode
            INSERT INTO Episode (Episode_number, Season_number) VALUES (episode_no, season_no);
            SET episode_no = episode_no + 1;
        END WHILE;
        SET season_no = season_no + 1;
    END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AssignParticipantsToEpisodes()
BEGIN
    DECLARE episode_id INT;
    DECLARE cuisine_id INT;
    DECLARE cook_id INT;
    DECLARE recipe_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE cur_episodes CURSOR FOR SELECT idEpisode FROM Episode;
    DECLARE cur_cuisines CURSOR FOR SELECT idCuisine FROM TempCuisines;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Temporary table for debugging
    DROP TEMPORARY TABLE IF EXISTS DebugTemp;
    CREATE TEMPORARY TABLE DebugTemp (
        stage VARCHAR(50),
        episode_id INT,
        cuisine_id INT,
        cook_id INT,
        recipe_id INT,
        status VARCHAR(50)
    );

    DROP TEMPORARY TABLE IF EXISTS TempCuisines;

    -- Ensure we have cuisines to select from
    CREATE TEMPORARY TABLE TempCuisines AS SELECT idCuisine FROM Cuisine ORDER BY RAND() LIMIT 10;

    OPEN cur_episodes;
    episode_loop: LOOP
        FETCH cur_episodes INTO episode_id;
        IF done THEN
            SET done = 0;
            LEAVE episode_loop;
        END IF;

        OPEN cur_cuisines;
        cuisine_loop: LOOP
            FETCH cur_cuisines INTO cuisine_id;
            IF done THEN
                SET done = 0;
                LEAVE cuisine_loop;
            END IF;

            -- Select a cook for the current cuisine
            SELECT Cook_idCook INTO cook_id FROM Cook_has_Cuisine
            WHERE Cuisine_idCuisine = cuisine_id
            AND Cook_idCook NOT IN (
                SELECT Cook_idCook 
                FROM Episode_has_Participants 
                WHERE Episode_idEpisode = episode_id
            )
            ORDER BY RAND() LIMIT 1;

            -- Ensure the cook has a recipe
            SELECT idRecipe INTO recipe_id FROM Recipe
            WHERE Cuisine_id = cuisine_id
            AND idRecipe IN (
                SELECT Recipe_idRecipe 
                FROM Recipe_has_Cook 
                WHERE Cook_idCook = cook_id
            )
            AND idRecipe NOT IN (
                SELECT Recipe_idRecipe 
                FROM Episode_has_Participants 
                WHERE Episode_idEpisode = episode_id
            )
            ORDER BY RAND() LIMIT 1;

            -- Insert participant into Episode_has_Participants
            IF cook_id IS NOT NULL AND recipe_id IS NOT NULL THEN
                INSERT INTO Episode_has_Participants (Episode_idEpisode, Cook_idCook, Recipe_idRecipe, Cuisine_idCuisine)
                VALUES (episode_id, cook_id, recipe_id, cuisine_id);
                
                INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                VALUES ('Inserted', episode_id, cuisine_id, cook_id, recipe_id, 'Success');
            ELSE
                INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                VALUES ('Skipped', episode_id, cuisine_id, cook_id, recipe_id, 'Skipped');
            END IF;
        END LOOP;
        CLOSE cur_cuisines;
    END LOOP;
    CLOSE cur_episodes;

    -- Select debug information at the end
    SELECT * FROM DebugTemp;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AssignJudgesToEpisodes()
BEGIN
    DECLARE episode_id INT;
    DECLARE judge_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE cur_episodes CURSOR FOR SELECT idEpisode FROM Episode;
    DECLARE cur_judges CURSOR FOR SELECT idCook FROM TempJudges;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Temporary table for debugging
    DROP TEMPORARY TABLE IF EXISTS DebugTempJudges;
    CREATE TEMPORARY TABLE DebugTempJudges (
        stage VARCHAR(50),
        episode_id INT,
        judge_id INT,
        status VARCHAR(50)
    );

    DROP TEMPORARY TABLE IF EXISTS TempJudges;

    OPEN cur_episodes;
    episode_loop: LOOP
        FETCH cur_episodes INTO episode_id;
        IF done THEN
            SET done = 0;
            LEAVE episode_loop;
        END IF;

        DROP TEMPORARY TABLE IF EXISTS TempJudges;
        CREATE TEMPORARY TABLE TempJudges AS 
        SELECT idCook FROM Cook 
        WHERE idCook NOT IN (
            SELECT Cook_idCook 
            FROM Episode_has_Participants 
            WHERE Episode_idEpisode = episode_id
        )
        ORDER BY RAND() LIMIT 3;

        OPEN cur_judges;
        judge_loop: LOOP
            FETCH cur_judges INTO judge_id;
            IF done THEN
                SET done = 0;
                LEAVE judge_loop;
            END IF;

            -- Insert judge into Episode_has_Judges
            IF judge_id IS NOT NULL THEN
                INSERT INTO Episode_has_Judges (Episode_idEpisode, Cook_idCook)
                VALUES (episode_id, judge_id);
                
                INSERT INTO DebugTempJudges (stage, episode_id, judge_id, status)
                VALUES ('Inserted', episode_id, judge_id, 'Success');
            ELSE
                INSERT INTO DebugTempJudges (stage, episode_id, judge_id, status)
                VALUES ('Skipped', episode_id, judge_id, 'Skipped');
            END IF;
        END LOOP;
        CLOSE cur_judges;
    END LOOP;
    CLOSE cur_episodes;

    -- Select debug information at the end
    SELECT * FROM DebugTempJudges;
END //

DELIMITER ;
-- ----------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE FillScoresWithRandomNumbers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE episode_id INT;
    DECLARE judge_id INT;
    DECLARE participant_id INT;
    DECLARE cur CURSOR FOR SELECT Episode_idEpisode, Judge_idJudge, Participant_id FROM Judge_Participant_Scores;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO episode_id, judge_id, participant_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE Judge_Participant_Scores 
        SET Score = FLOOR(1 + RAND() * 5) 
        WHERE Episode_idEpisode = episode_id 
        AND Judge_idJudge = judge_id 
        AND Participant_id = participant_id;
    END LOOP;
    CLOSE cur;
END//

DELIMITER ;





