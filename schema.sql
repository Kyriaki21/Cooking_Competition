DROP SCHEMA IF EXISTS Cooking_Competition;
CREATE SCHEMA Cooking_Competition;
USE Cooking_Competition;

CREATE TABLE `Cooking_Competition`.`Image` (
  `idImage` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Description` TEXT NOT NULL,
  `URL` VARCHAR(255) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idImage`)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Cuisine` (
  `idCuisine` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cuisine` VARCHAR(45) NULL UNIQUE,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Cuisine_Image_idx` (`Image` ASC)  ,
   INDEX `Search_Cuisine_idx` (`Cuisine` ASC)  ,
  CONSTRAINT `fk_Cuisine_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idCuisine`)
  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	
CREATE TABLE `Cooking_Competition`.`Type_Meal` (
  `idType_Meal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type_Meal` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Type_Meal_Image_idx` (`Image` ASC)  ,
   INDEX `Search_Type_Meal_idx` (`Type_Meal` ASC)  ,
  CONSTRAINT `fk_Type_Meal_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idType_Meal`)
  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Food_Group` (
  `idFood_Group` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_food_group` VARCHAR(45) NOT NULL,
  `description_food_group` TEXT NOT NULL,
  `Recipe_Category` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Food_Group_Image_idx` (`Image` ASC)  ,
   INDEX `Search_name_food_group_idx` (`name_food_group` ASC),
   INDEX `Search_Recipe_Category_idx` (`Recipe_Category` ASC),
  CONSTRAINT `fk_Food_Group_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idFood_Group`),
  UNIQUE INDEX `name_food_group_UNIQUE` (`name_food_group` ASC))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe` (
  `idRecipe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NOT NULL,
  `difficulty` TINYINT NOT NULL,
  `prep_time` TINYINT NOT NULL,
  `cook_time` TINYINT NOT NULL,
  `portions` TINYINT NOT NULL,
  `total_calories` DECIMAL(10,2) NULL,
  `total_fat` DECIMAL(10,2) NULL,
  `total_protein` DECIMAL(10,2) NULL,
  `total_carbohydrate` DECIMAL(10,2) NULL,
  `Cuisine_id` INT UNSIGNED NOT NULL,
  `Type_Meal` INT UNSIGNED NOT NULL,
  `syntagi` ENUM('cooking', 'pastry') NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idRecipe`),
  INDEX `fk_Recipe_Image_idx` (`Image` ASC),
  INDEX `Search_title_idx` (`title` ASC),
  INDEX `Search_difficulty_idx` (`difficulty` ASC),
  CONSTRAINT `fk_Recipe_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  INDEX `fk_Recipe_Cuisine1_idx` (`Cuisine_id` ASC),
  INDEX `fk_Recipe_Type_Meal1_idx` (`Type_Meal` ASC),
  CONSTRAINT `fk_Recipe_Cuisine1`
    FOREIGN KEY (`Cuisine_id`)
    REFERENCES `Cooking_Competition`.`Cuisine` (`idCuisine`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_Type_Meal1`
    FOREIGN KEY (`Type_Meal`)
    REFERENCES `Cooking_Competition`.`Type_Meal` (`idType_Meal`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `range_dif` CHECK (difficulty BETWEEN 1 AND 5),
  CONSTRAINT `prep_time_check` CHECK (prep_time >= 0),
  CONSTRAINT `portions_check` CHECK (portions > 0),
  CONSTRAINT `cook_time_check` CHECK (cook_time >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
   INDEX `Search_Ingredient_name_idx` (`Ingredient_name` ASC)  ,
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

CREATE TABLE `Cooking_Competition`.`Steps` (
  `idSteps` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Step_number` TINYINT NOT NULL,
  `Step_description` TEXT NOT NULL,
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idSteps`),
  INDEX `fk_Steps_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  INDEX `Seacrh_Step_number_idx` (`Step_number` ASC)  ,
  CONSTRAINT `fk_Steps_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE  `Cooking_Competition`.`Equipment` (
  `idEquipment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `equip_name` VARCHAR(45) NOT NULL,
  `equip_use` TEXT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Equipment_Image_idx` (`Image` ASC)  ,
   INDEX `Search_equip_name_idx` (`equip_name` ASC)  ,
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
  INDEX `fk_Recipe_has_Equipment_Equipment1_idx` (`Equipment_idEquipment` ASC),
  INDEX `fk_Recipe_has_Equipment_Recipe1_idx` (`Recipe_idRecipe` ASC),
  CONSTRAINT `unique_rec_equip` UNIQUE (`Recipe_idRecipe`, `Equipment_idEquipment`),
  CONSTRAINT `fk_Recipe_has_Equipment_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Equipment_Equipment1`
    FOREIGN KEY (`Equipment_idEquipment`)
    REFERENCES `Cooking_Competition`.`Equipment` (`idEquipment`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Concept` (
  `idConcept` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Concept_name` VARCHAR(255) NOT NULL,
  `Concept_description` TEXT DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Concept_Image_idx` (`Image` ASC)  ,
   INDEX `Seacrh_Concept_name_idx` (`Concept_name` ASC)  ,
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
   INDEX `Search_First_name_idx` (`first_name` ASC),
   INDEX `Search_Last_name_idx` (`last_name` ASC),
   INDEX `Search_Years_experience_idx` (`Years_experience` ASC),
   INDEX `Search_Status_idx` (`Status` ASC),
   INDEX `fk_Cook_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Cook_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idCook`))
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
  PRIMARY KEY (`idEpisode`),
  INDEX `Search_Episode_number_idx` (`Episode_number` ASC),
  INDEX `Search_Season_number_idx` (`Season_number` ASC),
  INDEX `Search_Cook_Winner_idx` (`winner_id` ASC)
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

DELIMITER ;

--
-- Procedure to calculate the episode winner
--

DELIMITER //

CREATE PROCEDURE CalculateEpisodeWinner(IN inputEpisodeID INT UNSIGNED)
BEGIN
    DECLARE winner_cook_id INT UNSIGNED;
    
    -- Create a temporary table to hold the possible winners
    CREATE TEMPORARY TABLE TempWinners AS
    SELECT 
        ep.Cook_idCook,
        SUM(jps.Score) AS TotalScore,
        c.Status
    FROM 
        Judge_Participant_Scores jps
    INNER JOIN 
        Episode_has_Participants ep ON jps.Participant_id = ep.Participant_id
    INNER JOIN 
        Cook c ON ep.Cook_idCook = c.idCook
    WHERE 
        jps.Episode_idEpisode = inputEpisodeID
    GROUP BY 
        ep.Cook_idCook;

    -- Determine the highest total score
    SET @max_score = (SELECT MAX(TotalScore) FROM TempWinners);
    
    -- Create another temporary table to hold cooks with the highest score
    CREATE TEMPORARY TABLE TopScorers AS
    SELECT * 
    FROM TempWinners
    WHERE TotalScore = @max_score;

    -- Determine the highest status among top scorers
    SET @max_status = (SELECT MIN(FIELD(Status, 'Chef', 'assistant head Chef', 'A cook', 'B cook', 'C cook')) FROM TopScorers);

    -- Create another temporary table to hold cooks with the highest status
    CREATE TEMPORARY TABLE FinalWinners AS
    SELECT * 
    FROM TopScorers
    WHERE FIELD(Status, 'Chef', 'assistant head Chef', 'A cook', 'B cook', 'C cook') = @max_status;

    -- Select a random winner from the final winners
    SELECT Cook_idCook 
    INTO winner_cook_id
    FROM FinalWinners
    ORDER BY RAND()
    LIMIT 1;

    -- Update the Episode table with the cook_id of the winner for the specified episode
    UPDATE Episode
    SET winner_id = winner_cook_id
    WHERE idEpisode = inputEpisodeID;

    -- Clean up temporary tables
    DROP TEMPORARY TABLE IF EXISTS TempWinners;
    DROP TEMPORARY TABLE IF EXISTS TopScorers;
    DROP TEMPORARY TABLE IF EXISTS FinalWinners;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER AfterInsertJudgeParticipantScores
AFTER INSERT ON Judge_Participant_Scores
FOR EACH ROW
BEGIN
    -- Call the procedure to calculate the winner for the episode
    CALL CalculateEpisodeWinner(NEW.Episode_idEpisode);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER AfterUpdateJudgeParticipantScores
AFTER UPDATE ON Judge_Participant_Scores
FOR EACH ROW
BEGIN
    -- Call the procedure to calculate the winner for the episode
    CALL CalculateEpisodeWinner(NEW.Episode_idEpisode);
END //

DELIMITER ;

CREATE TABLE `Cooking_Competition`.`Admin` (
  `idAdmin` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(55) NOT NULL,
  `password` VARCHAR(12) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (idAdmin))
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  
  CREATE TABLE Cooking_Competition.`User` (
  `idUser` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(55) NOT NULL,
  `password` VARCHAR(12) NOT NULL,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idUser`),
  INDEX `k_Cook_User_Cook1_idx` (`Cook_idCook` ASC),
  CONSTRAINT `k_Cook_User_Cuisine1`
      FOREIGN KEY (`Cook_idCook`)
      REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
      ON DELETE RESTRICT
      ON UPDATE CASCADE)
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------------------------------------
-- View to show only recipes assigned to a cook	
CREATE VIEW CookAssignedRecipes AS
SELECT 
    r.idRecipe,
    r.title,
    r.description,
    r.difficulty,
    r.prep_time,
    r.cook_time,
    r.portions,
    r.total_calories,
    r.total_fat,
    r.total_protein,
    r.total_carbohydrate,
    r.Cuisine_id,
    r.Type_Meal,
    r.syntagi,
    r.last_update,
    r.Image,
    ep.Cook_idCook
FROM 
    Recipe r
JOIN 
    Episode_has_Participants ep ON r.idRecipe = ep.Recipe_idRecipe;

-- View to show personal details of a cook
CREATE VIEW CookPersonalDetails AS
SELECT 
    idCook,
    first_name,
    last_name,
    phone_number,
    birth_date,
    age,
    Years_experience,
    Status,
    last_update,
    Image
FROM 
    Cook;
-- Procedure to update recipes assigned to a cook
DELIMITER //

CREATE PROCEDURE UpdateAssignedRecipe(
    IN username VARCHAR(45),
    IN recipe_id INT,
    IN new_title VARCHAR(200),
    IN new_description TEXT,
    IN new_difficulty TINYINT,
    IN new_prep_time TINYINT,
    IN new_cook_time TINYINT,
    IN new_portions TINYINT,
    IN new_total_calories DECIMAL(10,2),
    IN new_total_fat DECIMAL(10,2),
    IN new_total_protein DECIMAL(10,2),
    IN new_total_carbohydrate DECIMAL(10,2),
    IN new_Cuisine_id INT,
    IN new_Type_Meal INT,
    IN new_syntagi ENUM('cooking', 'pastry'),
    IN new_Image INT
)
BEGIN
    DECLARE cook_id INT;
    DECLARE is_assigned INT;

    -- Get the cook_id from the Users and Cook tables
    SELECT c.idCook
    INTO cook_id
    FROM Users u
    INNER JOIN Cook c ON u.idUser = c.User_idUser
    WHERE u.username = username;

    -- Check if the cook is assigned to the recipe
    SELECT COUNT(*)
    INTO is_assigned
    FROM Episode_has_Participants
    WHERE Cook_idCook = cook_id AND Recipe_idRecipe = recipe_id;

    IF is_assigned = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cook not assigned to this recipe';
    ELSE
        UPDATE Recipe
        SET 
            title = new_title,
            description = new_description,
            difficulty = new_difficulty,
            prep_time = new_prep_time,
            cook_time = new_cook_time,
            portions = new_portions,
            total_calories = new_total_calories,
            total_fat = new_total_fat,
            total_protein = new_total_protein,
            total_carbohydrate = new_total_carbohydrate,
            Cuisine_id = new_Cuisine_id,
            Type_Meal = new_Type_Meal,
            syntagi = new_syntagi,
            Image = new_Image,
            last_update = CURRENT_TIMESTAMP
        WHERE idRecipe = recipe_id;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateCookDetails(
    IN username VARCHAR(45),
    IN new_first_name VARCHAR(45),
    IN new_last_name VARCHAR(45),
    IN new_phone_number VARCHAR(15),
    IN new_birth_date DATE,
    IN new_age INT,
    IN new_Years_experience INT,
    IN new_Status ENUM('C cook', 'B cook', 'A cook', 'assistant head Chef', 'Chef'),
    IN new_Image INT
)
BEGIN
    DECLARE cook_id INT;

    -- Get the cook_id from the Users and Cook tables
    SELECT c.idCook
    INTO cook_id
    FROM Users u
    INNER JOIN Cook c ON u.idUser = c.User_idUser
    WHERE u.username = username;

    -- Update the cook's details
    UPDATE Cook
    SET 
        first_name = new_first_name,
        last_name = new_last_name,
        phone_number = new_phone_number,
        birth_date = new_birth_date,
        age = new_age,
        Years_experience = new_Years_experience,
        Status = new_Status,
        Image = new_Image,
        last_update = CURRENT_TIMESTAMP
    WHERE idCook = cook_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddAdminUser(
    IN username VARCHAR(45),
    IN user_password VARCHAR(45)
)
BEGIN
    -- Create the admin user
    SET @query = CONCAT('CREATE USER ''', username, '''@''localhost'' IDENTIFIED BY ''', user_password, ''';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant all privileges to the admin user
    SET @query = CONCAT('GRANT ALL PRIVILEGES ON *.* TO ''', username, '''@''localhost'' WITH GRANT OPTION;');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Reload the privileges
    FLUSH PRIVILEGES;

    -- Insert into Users table with the role 'administrator'
    INSERT INTO `Admin` (username, password, role) VALUES (username, user_password, 'administrator');
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddCookUser(
    IN username VARCHAR(45),
    IN user_password VARCHAR(45),
    IN cook_id INT
)
BEGIN
    -- Create the user
    SET @query = CONCAT('CREATE USER \'', username, '\'@\'localhost\' IDENTIFIED BY \'', user_password, '\';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant privileges to the cook user for the views
    SET @query = CONCAT('GRANT SELECT, UPDATE ON Cooking_Competition.CookAssignedRecipes TO \'', username, '\'@\'localhost\';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query = CONCAT('GRANT SELECT, UPDATE ON Cooking_Competition.CookPersonalDetails TO \'', username, '\'@\'localhost\';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant execution privileges for the stored procedures
    SET @query = CONCAT('GRANT EXECUTE ON PROCEDURE Cooking_Competition.UpdateAssignedRecipe TO \'', username, '\'@\'localhost\';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query = CONCAT('GRANT EXECUTE ON PROCEDURE Cooking_Competition.UpdateCookDetails TO \'', username, '\'@\'localhost\';');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Reload the privileges
    FLUSH PRIVILEGES;
    INSERT INTO User (username , password, Cook_idCook  ) VALUES (username , user_password, cook_id );
END //

DELIMITER ;
