-- Drop Views
DROP VIEW IF EXISTS Cooking_Competition.CookScoresByCuisine;
DROP VIEW IF EXISTS Cooking_Competition.YoungCooksInEpisodes;
DROP VIEW IF EXISTS Cooking_Competition.CooksNeverJudged;
DROP VIEW IF EXISTS Cooking_Competition.JudgesSameNumberOfEpisodes;
DROP VIEW IF EXISTS Cooking_Competition.CooksWithFewerParticipations;
DROP VIEW IF EXISTS Cooking_Competition.AverageCarbohydratesPerSeason;
DROP VIEW IF EXISTS Cooking_Competition.ConsecutiveYearCuisines;
DROP VIEW IF EXISTS Cooking_Competition.Top5JudgesTotalScoreView;
DROP VIEW IF EXISTS Cooking_Competition.EpisodeStatusSum;
DROP VIEW IF EXISTS Cooking_Competition.Episode_Sum_Status;
DROP VIEW IF EXISTS Cooking_Competition.MostCommonConceptAllEpisodes;
DROP VIEW IF EXISTS Cooking_Competition.UnusedFoodGroupsView;

-- Drop Procedures
DROP PROCEDURE IF EXISTS Cooking_Competition.AVG_SCORE_CUISine_COOK;
DROP PROCEDURE IF EXISTS Cooking_Competition.CheckCuisineAndCooks;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetCooksBySeason;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetYoungCooksFromView;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetCooksNeverJudged;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetJudgesWithSameNumberOfEpisodes;
DROP PROCEDURE IF EXISTS Cooking_Competition.CallCooksWithFewerParticipations;
DROP PROCEDURE IF EXISTS Cooking_Competition.CalculateAverageCarbohydratesPerSeason;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetConsecutiveYearCuisines;
DROP PROCEDURE IF EXISTS Cooking_Competition.CallTop5JudgesTotalScore;
DROP PROCEDURE IF EXISTS Cooking_Competition.FindLowestSumStatusEpisode;
DROP PROCEDURE IF EXISTS Cooking_Competition.LowestSumStatusEpisode;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetMostCommonConcept;
DROP PROCEDURE IF EXISTS Cooking_Competition.GenerateSeasonEpisodes;
DROP PROCEDURE IF EXISTS Cooking_Competition.GenerateMultipleSeasonsforsetseed;
DROP PROCEDURE IF EXISTS Cooking_Competition.GenerateMultipleSeasons;
DROP PROCEDURE IF EXISTS Cooking_Competition.GetTop3LabelPairs;

-- Drop Tables
DROP TABLE IF EXISTS Cooking_Competition.Image;
DROP TABLE IF EXISTS Cooking_Competition.Cuisine;
DROP TABLE IF EXISTS Cooking_Competition.Type_Meal;
DROP TABLE IF EXISTS Cooking_Competition.Food_Group;
DROP TABLE IF EXISTS Cooking_Competition.Recipe;
DROP TABLE IF EXISTS Cooking_Competition.Tips;
DROP TABLE IF EXISTS Cooking_Competition.Steps;
DROP TABLE IF EXISTS Cooking_Competition.Concept;
DROP TABLE IF EXISTS Cooking_Competition.Recipe_has_Concept;
DROP TABLE IF EXISTS Cooking_Competition.Cook;
DROP TABLE IF EXISTS Cooking_Competition.Recipe_has_Cook;
DROP TABLE IF EXISTS Cooking_Competition.Label;
DROP TABLE IF EXISTS Cooking_Competition.Recipe_has_Label;
DROP TABLE IF EXISTS Cooking_Competition.Equipment;
DROP TABLE IF EXISTS Cooking_Competition.Recipe_has_Equipment;
DROP TABLE IF EXISTS Cooking_Competition.Ingredients;
DROP TABLE IF EXISTS Cooking_Competition.Recipe_has_Ingredients;
DROP TABLE IF EXISTS Cooking_Competition.Judge;
DROP TABLE IF EXISTS Cooking_Competition.Cook_has_Cuisine;
DROP TABLE IF EXISTS Cooking_Competition.Episode;
DROP TABLE IF EXISTS Cooking_Competition.Episode_has_Participants;
DROP TABLE IF EXISTS Cooking_Competition.Episode_has_Judges;
DROP TABLE IF EXISTS Cooking_Competition.Judge_Participant_Scores;
