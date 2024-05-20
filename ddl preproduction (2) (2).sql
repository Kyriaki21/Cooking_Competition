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
  UNIQUE INDEX `name_food_group_UNIQUE` (`name_food_group` ASC)  ,
  UNIQUE INDEX `Recipe_Category_UNIQUE` (`Recipe_Category` ASC)  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe` (
  `idRecipe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NOT NULL,
  `difficulty` TINYINT NOT NULL,
  `prep_time` TINYINT NOT NULL,
  `cook_time` TINYINT NOT NULL,
  `portions` TINYINT NOT NULL,
  `total_calories` INT NULL,
  `total_fat` INT NULL,
  `total_protein` INT NULL,
  `total_carbohydrate` INT NULL,
  `Cuisine_id` INT UNSIGNED NOT NULL,
  `Type_Meal_id` INT UNSIGNED NOT NULL,
  `syntagi` ENUM('cooking', 'pastry') NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Image` INT UNSIGNED NOT NULL,
   INDEX `fk_Recipe_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Recipe_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idRecipe`),
  INDEX `fk_Recipe_Cuisine1_idx` (`Cuisine_id` ASC)  ,
  INDEX `fk_Recipe_Type_Meal1_idx` (`Type_Meal_id` ASC)  ,
  CONSTRAINT `fk_Recipe_Cuisine1`
    FOREIGN KEY (`Cuisine_id`)
    REFERENCES `Cooking_Competition`.`Cuisine` (`idCuisine`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_Type_Meal1`
    FOREIGN KEY (`Type_Meal_id`)
    REFERENCES `Cooking_Competition`.`Type_Meal` (`idType_Meal`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT range_dif check (difficulty IN (1,5)),
  CONSTRAINT prep_time_check check (prep_time > 0),
  CONSTRAINT portions_check check (portions > 0),
  CONSTRAINT cook_time_check check (cook_time >= 0))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
   INDEX `fk_Label_Image_idx` (`Image` ASC)  ,
  CONSTRAINT `fk_Label_Image`
    FOREIGN KEY (`Image`)
    REFERENCES `Cooking_Competition`.`Image` (`idImage`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  PRIMARY KEY (`idLabel`),
  UNIQUE INDEX  `Label_name_UNIQUE` (`Label_name` ASC)  )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Recipe_has_Label` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Label_idLabel` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Label_idLabel`),
  INDEX `fk_Recipe_has_Label_Label1_idx` (`Label_idLabel` ASC)  ,
  INDEX `fk_Recipe_has_Label_Recipe1_idx` (`Recipe_idRecipe` ASC)  ,
  CONSTRAINT unique_rec_label UNIQUE (Recipe_idRecipe,Label_idLabel),
  CONSTRAINT `fk_Recipe_has_Label_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Label_Label1`
    FOREIGN KEY (`Label_idLabel`)
    REFERENCES `Cooking_Competition`.`Label` (`idLabel`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `fat` SMALLINT NULL,
  `protein` SMALLINT NULL,
  `carbohydrate` SMALLINT NULL,
  `calories` SMALLINT NULL,
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
  `Quantity` SMALLINT NOT NULL,
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

CREATE TABLE `Cooking_Competition`.`Judge` (
  `idJudge` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idJudge`),
  INDEX `fk_Judge1_idx` (`Cook_idCook` ASC)  ,
  CONSTRAINT `fk_Judge1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  PRIMARY KEY (`Episode_idEpisode`, `Cook_idCook`),
  INDEX `fk_Participant_id_idx` (`Participant_id` ASC),
  INDEX `fk_Episode_Participant_Participant1_idx` (`Cook_idCook` ASC),
  INDEX `fk_Episode_Participant_Episode1_idx` (`Episode_idEpisode` ASC),
  INDEX `fk_Episode_Participant_Recipe1_idx` (`Recipe_idRecipe` ASC),
  INDEX `fk_Episode_Participant_Cuisine1_idx` (`Cuisine_idCuisine` ASC),
  CONSTRAINT `fk_Episode_Participant_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Participant_Participant1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Recipe_Participant1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Cuisine_Participant1`
    FOREIGN KEY (`Cuisine_idCuisine`)
    REFERENCES `Cooking_Competition`.`Cuisine` (`idCuisine`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode_has_Judges` (
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Judge_idJudge` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Episode_idEpisode`, `Judge_idJudge`),
  INDEX `fk_Episode_Judge_Judge1_idx` (`Judge_idJudge` ASC)  ,
  INDEX `fk_Episode_Judge_Episode1_idx` (`Episode_idEpisode` ASC)  ,
  CONSTRAINT `fk_Episode_Judge_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Judge_Judge1`
    FOREIGN KEY (`Judge_idJudge`)
    REFERENCES `Cooking_Competition`.`Judge` (`idJudge`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `Cooking_Competition`.`Judge_Participant_Scores` (
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Judge_idJudge` INT UNSIGNED NOT NULL,
  `Participant_id` INT UNSIGNED NOT NULL,
  `Score` TINYINT NOT NULL DEFAULT 0,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Episode_idEpisode`, `Judge_idJudge`, `Participant_id`),
  CONSTRAINT `fk_Judge_Participant_Scores_Episode`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Judge_Participant_Scores_Judge`
    FOREIGN KEY (`Judge_idJudge`)
    REFERENCES `Cooking_Competition`.`Judge` (`idJudge`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Judge_Participant_Scores_Participant`
    FOREIGN KEY (`Participant_id`)
    REFERENCES `Cooking_Competition`.`Episode_has_Participants` (`Participant_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Procedure to update the recipe's nutritional values
--

DELIMITER //

CREATE PROCEDURE UpdateRecipeNutrition(
    IN recipe_id INT, 
    IN ingredient_id INT, 
    IN operation CHAR(1) -- 'A' for add, 'S' for subtract
)
BEGIN
    DECLARE servings INT DEFAULT 1;
    DECLARE quantity DECIMAL(10,2);
    DECLARE calories INT;
    DECLARE fat INT;
    DECLARE protein INT;
    DECLARE carbohydrate INT;

    -- Get the total number of servings for the recipe
    SELECT portions INTO servings
    FROM Recipe
    WHERE idRecipe = recipe_id;

    -- Get the quantity of the specific ingredient in the recipe
    SELECT Quantity INTO quantity
    FROM Recipe_has_Ingredients
    WHERE Recipe_idRecipe = recipe_id AND Ingredients_idIngredients = ingredient_id;

    -- Calculate the nutritional values for the specific ingredient
    SELECT 
        (calories / 100 * quantity) / servings AS ingredient_calories,
        (fat / 100 * quantity) / servings AS ingredient_fat,
        (protein / 100 * quantity) / servings AS ingredient_protein,
        (carbohydrate / 100 * quantity) / servings AS ingredient_carbohydrate
    INTO 
        calories, fat, protein, carbohydrate
    FROM Ingredients
    WHERE idIngredients = ingredient_id;

    -- Update the recipe's nutritional values
    IF operation = 'A' THEN
        UPDATE Recipe
        SET total_calories = total_calories + calories,
            total_fat = total_fat + fat,
            total_protein = total_protein + protein,
            total_carbohydrate = total_carbohydrate + carbohydrate
        WHERE idRecipe = recipe_id;
    ELSEIF operation = 'S' THEN
        UPDATE Recipe
        SET total_calories = total_calories - calories,
            total_fat = total_fat - fat,
            total_protein = total_protein - protein,
            total_carbohydrate = total_carbohydrate - carbohydrate
        WHERE idRecipe = recipe_id;
    END IF;
END //

DELIMITER ;

-- Trigger for after inserting an ingredient
DELIMITER //

CREATE TRIGGER AfterInsertRecipeIngredient
AFTER INSERT ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL UpdateRecipeNutrition(NEW.Recipe_idRecipe, NEW.Ingredients_idIngredients, 'A');
END //

DELIMITER ;

-- Trigger for after deleting an ingredient
DELIMITER //

CREATE TRIGGER AfterDeleteRecipeIngredient
AFTER DELETE ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL UpdateRecipeNutrition(OLD.Recipe_idRecipe, OLD.Ingredients_idIngredients, 'S');
END //

DELIMITER ;

-- Trigger for updating ingredient values
DELIMITER //

CREATE TRIGGER BeforeUpdateIngredients
BEFORE UPDATE ON Ingredients
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE recipe_id INT;

    -- Cursor to iterate over recipes that use this ingredient
    DECLARE recipe_cursor CURSOR FOR 
        SELECT DISTINCT Recipe_idRecipe
        FROM Recipe_has_Ingredients
        WHERE Ingredients_idIngredients = OLD.idIngredients;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Check if any of the nutritional values are being updated
    IF NEW.fat != OLD.fat OR
       NEW.protein != OLD.protein OR
       NEW.carbohydrate != OLD.carbohydrate OR
       NEW.calories != OLD.calories THEN

        OPEN recipe_cursor;
        
        read_loop: LOOP
            FETCH recipe_cursor INTO recipe_id;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Subtract old values
            CALL UpdateRecipeNutrition(recipe_id, OLD.idIngredients, 'S');

            -- Add new values
            CALL UpdateRecipeNutrition(recipe_id, NEW.idIngredients, 'A');
        END LOOP;

        CLOSE recipe_cursor;
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
		CALL UpdateRecipeNutrition(OLD.Recipe_idRecipe, OLD.Ingredients_idIngredients, 'S');
		CALL UpdateRecipeNutrition(NEW.Recipe_idRecipe, NEW.Ingredients_idIngredients, 'A');
	END IF;
END //

DELIMITER ;

--
-- Trigger for a cook participant
--
DELIMITER //

CREATE TRIGGER BeforeInsertParticipant
BEFORE INSERT ON Episode_has_Participants
FOR EACH ROW
BEGIN
    DECLARE consecutive_count INT DEFAULT 0;
    DECLARE curr_episode INT;
    DECLARE curr_season INT;
    DECLARE done INT DEFAULT FALSE;

    -- Declare cursor to iterate over the last three episodes in descending order
    DECLARE recent_episodes CURSOR FOR
        SELECT e.Episode_number, e.Season_number
        FROM Episode e
        LEFT JOIN Episode_has_Participants ep ON e.idEpisode = ep.Episode_idEpisode AND ep.Cook_idCook = NEW.Cook_idCook
        LEFT JOIN Episode_has_Judges ej ON e.idEpisode = ej.Episode_idEpisode AND ej.Judge_idJudge = NEW.Cook_idCook
        WHERE ep.Cook_idCook IS NOT NULL OR ej.Judge_idJudge IS NOT NULL
        ORDER BY e.Season_number DESC, e.Episode_number DESC
        LIMIT 3;

    -- Declare continue handler for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN recent_episodes;

    -- Fetch episodes and check for consecutive participation
    read_loop: LOOP
        FETCH recent_episodes INTO curr_episode, curr_season;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check if the current episode is consecutive
        IF curr_season = (SELECT Season_number FROM Episode WHERE idEpisode = NEW.Episode_idEpisode) AND
           curr_episode = (SELECT Episode_number FROM Episode WHERE idEpisode = NEW.Episode_idEpisode) - consecutive_count - 1 THEN
            SET consecutive_count = consecutive_count + 1;
        ELSE
            SET consecutive_count = 0;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE recent_episodes;

    -- If the cook has participated in the last three consecutive episodes, signal an error
    IF consecutive_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The cook cannot participate in more than three consecutive episodes.';
    END IF;
END //

DELIMITER ;

--
-- Trigger for a cook Judge
--

DELIMITER //

CREATE TRIGGER BeforeInsertJudge
BEFORE INSERT ON Episode_has_Judges
FOR EACH ROW
BEGIN
    DECLARE consecutive_count INT DEFAULT 0;
    DECLARE curr_episode INT;
    DECLARE curr_season INT;
    DECLARE done INT DEFAULT FALSE;

    -- Declare cursor to iterate over the last three episodes in descending order
    DECLARE recent_episodes CURSOR FOR
        SELECT e.Episode_number, e.Season_number
        FROM Episode e
        LEFT JOIN Episode_has_Participants ep ON e.idEpisode = ep.Episode_idEpisode AND ep.Cook_idCook = NEW.Judge_idJudge
        LEFT JOIN Episode_has_Judges ej ON e.idEpisode = ej.Episode_idEpisode AND ej.Judge_idJudge = NEW.Judge_idJudge
        WHERE ep.Cook_idCook IS NOT NULL OR ej.Judge_idJudge IS NOT NULL
        ORDER BY e.Season_number DESC, e.Episode_number DESC
        LIMIT 3;

    -- Declare continue handler for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN recent_episodes;

    -- Fetch episodes and check for consecutive participation
    read_loop: LOOP
        FETCH recent_episodes INTO curr_episode, curr_season;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check if the current episode is consecutive
        IF curr_season = (SELECT Season_number FROM Episode WHERE idEpisode = NEW.Episode_idEpisode) AND
           curr_episode = (SELECT Episode_number FROM Episode WHERE idEpisode = NEW.Episode_idEpisode) - consecutive_count - 1 THEN
            SET consecutive_count = consecutive_count + 1;
        ELSE
            SET consecutive_count = 0;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE recent_episodes;

    -- If the cook has participated in the last three consecutive episodes, signal an error
    IF consecutive_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The cook cannot participate in more than three consecutive episodes.';
    END IF;
END //

DELIMITER ;


--
-- Trigger to limit the number of tips per recipe
--

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
    SELECT Step_number INTO prevStep FROM Steps WHERE Recipe_idRecipe = NEW.Recipe_idRecipe ORDER BY idSteps DESC LIMIT 1;

    -- If no previous step exists or the step number is consecutive, allow the insertion
    IF prevStep IS NULL OR NEW.Step_number = prevStep + 1 THEN
        -- Insert the new step
        INSERT INTO Steps (Step_number, Step_description, Recipe_idRecipe)
        VALUES (NEW.Step_number, NEW.Step_description, NEW.Recipe_idRecipe);
    ELSE
        -- If the previous step doesn't exist or step numbers are not consecutive, raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Previous step does not exist or step numbers are not consecutive for this recipe. Please insert the steps for this recipe in the correct order.';
    END IF;
END //

DELIMITER ;



-- ----------------------------------------------------------------------------------------------------------------------

-- 3.1. Average Rating (score) per cook and national cuisine
DELIMITER //

CREATE PROCEDURE GetCookScoresByCuisine()
BEGIN
    -- Select the required data
    SELECT 
        c.idCook,
        c.first_name,
        c.last_name,
        cu.Cuisine,
        AVG(jps.Score) AS avg_score
    FROM 
        Judge_Participant_Scores jps
    INNER JOIN 
        Episode_has_Participants ehp ON jps.Participant_id = ehp.Participant_id
    INNER JOIN 
        Cook c ON ehp.Cook_idCook = c.idCook
    INNER JOIN 
        Cuisine cu ON ehp.Cuisine_idCuisine = cu.idCuisine
    GROUP BY 
        c.idCook, cu.Cuisine
    ORDER BY 
        cu.Cuisine, avg_score DESC;
END //

DELIMITER ;
    
-- 3.2.a For a given National Cuisine the cooks belonging to it
DELIMITER //

CREATE PROCEDURE CheckCuisineAndCooks(IN cuisine_name VARCHAR(255))
BEGIN
    DECLARE cuisine_count INT;

    -- Check if the cuisine exists
    SELECT COUNT(*) INTO cuisine_count
    FROM Cuisine
    WHERE Cuisine = cuisine_name;

    -- If the cuisine does not exist, output an error
    IF cuisine_count = 0 THEN
        SELECT 'Error: The cuisine does not exist';
    ELSE
        -- Check if there are any cooks for the given cuisine
        IF (SELECT COUNT(*) FROM Cook c JOIN Cuisine cu ON c.Cuisine_idCuisine = cu.idCuisine WHERE cu.Cuisine = cuisine_name) = 0 THEN
            SELECT 'There are no cooks for the given cuisine';
        ELSE
            -- Retrieve the cooks belonging to the given cuisine
            SELECT 
                c.idCook,
                c.first_name,
                c.last_name
            FROM 
                Cook c
            JOIN 
                Cuisine cu ON c.Cuisine_idCuisine = cu.idCuisine
            WHERE 
                cu.Cuisine = cuisine_name;
        END IF;
    END IF;
END //

DELIMITER ;

-- 3.2.b For a given sezon, the cooks participated in episodes
DELIMITER //

CREATE PROCEDURE GetCooksBySeason(IN season_name VARCHAR(255))
BEGIN
    DECLARE season_count INT;
    
    -- Check if the given season exists
    SELECT COUNT(*) INTO season_count FROM Season WHERE SeasonName = season_name;
    
    IF season_count = 0 THEN
        -- Output an error if the season does not exist
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Season does not exist';
    ELSE
        -- Retrieve cooks involved in the given season
        SELECT 
            c.idCook,
            c.first_name,
            c.last_name,
            cu.Cuisine AS National_Cuisine,
            COUNT(DISTINCT ehp.Episode_id) AS episodes_involved
        FROM 
            Cook c
        LEFT JOIN 
            Episode_has_Participants ehp ON c.idCook = ehp.Cook_idCook
        LEFT JOIN 
            Cuisine cu ON c.Cuisine_idCuisine = cu.idCuisine
        WHERE 
            ehp.Season = season_name
        GROUP BY 
            c.idCook, cu.Cuisine
        HAVING 
            episodes_involved > 0;
    END IF;
END //

DELIMITER ;

-- 3.3 The young cooks (age < 30 years) who have the most recipes
DELIMITER //

CREATE PROCEDURE FindYoungCooksWithMostRecipes()
BEGIN
    DECLARE max_recipe_count INT;
    
    -- Find the maximum number of recipes among cooks under 30
    SELECT MAX(recipe_count) INTO max_recipe_count
    FROM (
        SELECT 
            c.idCook,
            COUNT(r.idRecipe) AS recipe_count
        FROM 
            Cook c
        INNER JOIN 
            Recipe r ON c.idCook = r.Cook_idCook
        WHERE 
            TIMESTAMPDIFF(YEAR, c.date_of_birth, CURDATE()) < 30
        GROUP BY 
            c.idCook
    ) AS MAXcounts;
    
    -- Get the cooks with the maximum recipe count and under 30 years old
    SELECT 
        c.idCook,
        c.first_name,
        c.last_name,
        COUNT(r.idRecipe) AS recipe_count
    FROM 
        Cook c
    INNER JOIN 
        Recipe r ON c.idCook = r.Cook_idCook
    WHERE 
        TIMESTAMPDIFF(YEAR, c.date_of_birth, CURDATE()) < 30
    GROUP BY 
        c.idCook, c.first_name, c.last_name
    HAVING 
        recipe_count = max_recipe_count;
END //

DELIMITER 

-- 3.4 Cooks who have never judged an episode
DELIMITER //

CREATE PROCEDURE FindCooksNeverJudgedEpisode()
BEGIN
    SELECT c.idCook, c.first_name, c.last_name
    FROM Cook c
    LEFT JOIN Episode_Judges ej ON c.idCook = ej.Judge_idCook
    WHERE ej.Judge_idCook IS NULL;
END //

DELIMITER ;


-- 3.5 Judges who have participated in the same number of episodes over a period of one year with
DELIMITER //

CREATE PROCEDURE FindJudgesWithSameEpisodes()
BEGIN
    SELECT 
        j1.idJudge AS Judge1_ID,
        j1.first_name AS Judge1_FirstName,
        j1.last_name AS Judge1_LastName,
        j2.idJudge AS Judge2_ID,
        j2.first_name AS Judge2_FirstName,
        j2.last_name AS Judge2_LastName,
        COUNT(*) AS NumEpisodes
    FROM 
        Judge j1
    JOIN 
        Judge j2 ON j1.idJudge <> j2.idJudge
    JOIN 
        Episode_has_Judge ej1 ON j1.idJudge = ej1.Judge_idJudge
    JOIN 
        Episode_has_Judge ej2 ON j2.idJudge = ej2.Judge_idJudge
    WHERE 
        ej1.Episode_idEpisode = ej2.Episode_idEpisode
    GROUP BY 
        j1.idJudge, j2.idJudge
    HAVING 
        NumEpisodes > 3
    ORDER BY 
        NumEpisodes DESC;
END //

DELIMITER ;

-- 3.7 All cooks who have participated at least 5 fewer times than the cook with the most episodes
SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    COUNT(*) AS episodes_participated
FROM 
    Cook c
JOIN 
    Episode_has_Participants ehp ON c.idCook = ehp.Cook_idCook
GROUP BY 
    c.idCook, c.first_name, c.last_name
HAVING 
    episodes_participated <= (
        SELECT 
            MAX(episodes_participated) - 5
        FROM (
            SELECT 
                Cook_idCook,
                COUNT(*) AS episodes_participated
            FROM 
                Episode_has_Participants
            GROUP BY 
                Cook_idCook
        ) AS subquery
    ); 
    
-- 3.9 List of average number of grams of carbohydrates in the competition per sezon
DELIMITER //

CREATE PROCEDURE CalculateMeanCarbohydratesPerSeason()
BEGIN
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
END //

DELIMITER ;

-- 3.10 Cuisines have the same number of entries in competitions over two consecutive years, with at least 3 entries per year
DELIMITER //

CREATE PROCEDURE FindCuisinesWithSameEntries()
BEGIN
    -- Step 1: Calculate count of entries per national cuisine for each year
    WITH entries_per_year AS (
        SELECT cuisine, year, COUNT(*) AS entry_count
        FROM competition
        GROUP BY cuisine, year
    ),

    -- Step 2: Merge the results for the two consecutive years
    merged_entries AS (
        SELECT e1.cuisine, e1.year AS year_1, e1.entry_count AS entry_count_1,
               e2.year AS year_2, e2.entry_count AS entry_count_2
        FROM entries_per_year e1
        JOIN entries_per_year e2 ON e1.cuisine = e2.cuisine AND e1.year = e2.year - 1
    ),

    -- Step 3: Filter out cuisines with fewer than 3 entries per year in either year
    filtered_entries AS (
        SELECT cuisine, year_1, entry_count_1, year_2, entry_count_2
        FROM merged_entries
        WHERE entry_count_1 >= 3 AND entry_count_2 >= 3
    )

    -- Step 4: Identify cuisines with the same number of entries over two consecutive years
    SELECT cuisine
    FROM filtered_entries
    WHERE entry_count_1 = entry_count_2;
END //

DELIMITER ;

-- 3.11 Top 5 reviewers who have given the highest overall rating to a cook

DELIMITER //

CREATE PROCEDURE Top5JudgesTotalScore()
BEGIN
    SELECT 
        (SELECT Cook_name FROM Cooks WHERE idCook = c.Judge_idJudge) AS Judge_name,
        c.Cook_name,
        SUM(sc.score) AS total_score
    FROM 
        Score_given sc
    JOIN 
        Cooks c ON sc.Cook_idCook = c.idCook
    GROUP BY 
        Judge_name, c.Cook_name
    ORDER BY 
        total_score DESC
    LIMIT 5;
END//

DELIMITER ;

-- 3.12  The most technically challenging, in terms of recipes, episode of the competition per year
DELIMITER //

CREATE PROCEDURE MostDifficultEpisodePerSeason()
BEGIN
    SELECT 
        s.Season_number,
        MAX(avg_difficulty) AS max_difficulty,
        (
            SELECT 
                e.Episode_number
            FROM 
                Episodes e
            JOIN 
                Recipes r ON e.idEpisode = r.Episode_idEpisode
            WHERE 
                e.Season_idSeason = s.idSeason
            GROUP BY 
                e.idEpisode
            HAVING 
                AVG(r.Difficulty) = MAX(avg_difficulty)
            LIMIT 1
        ) AS most_difficult_episode
    FROM 
        Seasons s
    JOIN 
        Episodes ep ON s.idSeason = ep.Season_idSeason
    JOIN 
        Recipes rc ON ep.idEpisode = rc.Episode_idEpisode
    GROUP BY 
        s.idSeason;
END//

DELIMITER ;

-- 3.13 Episode garnered the lowest status ranking (judges and cooks)
DELIMITER //
CREATE PROCEDURE LowestSumStatusEpisode()
BEGIN
    -- Select the episode with the lowest sum of status values
    SELECT 
        episode_id,
        SUM(CASE
            WHEN status = 'C cook' THEN 1
            WHEN status = 'B cook' THEN 2
            WHEN status = 'A cook' THEN 3
            WHEN status = 'assistant head Chef' THEN 4
            WHEN status = 'Chef' THEN 5
            ELSE 0
        END) AS sum_status
    FROM 
        Contestants
    GROUP BY 
        episode_id
    ORDER BY 
        sum_status
    LIMIT 1;
END;
DELIMITER ;

-- 3.14  Theme has appeared most often in the competition
DELIMITER //

CREATE PROCEDURE MostCommonConceptAllEpisodes()
BEGIN
    DECLARE most_common_concept VARCHAR(255);

    -- Query to find the most common concept among all episodes
    SELECT Concept_name INTO most_common_concept
    FROM (
        SELECT Concept_idConcept, COUNT(*) AS concept_count
        FROM Recipe_has_Concept
        JOIN Recipe ON Recipe_has_Concept.Recipe_idRecipe = Recipe.idRecipe
        JOIN Episode ON Recipe.Episode_idEpisode = Episode.idEpisode
        GROUP BY Concept_idConcept
        ORDER BY concept_count DESC
        LIMIT 1
    ) AS most_common
    JOIN Concept ON most_common.Concept_idConcept = Concept.idConcept;

    -- Return the most common concept among all episodes
    SELECT most_common_concept AS Most_Common_Concept;
END //

DELIMITER ;

-- 3.15 Food groups that have never appeared in the competition
DELIMITER //
CREATE PROCEDURE FindUnusedFoodGroups()
BEGIN
    -- Select food groups that have not appeared in any recipe linked to an episode
    SELECT *
    FROM Food_Group
    WHERE idFood_Group NOT IN (
        SELECT DISTINCT Food_Group_idFood_Group
        FROM Recipe_has_Ingredients
        WHERE Recipe_idRecipe IN (
            SELECT DISTINCT Recipe_idRecipe
            FROM Episode_has_Participants
            JOIN Recipe_has_Cook ON Episode_has_Participants.Recipe_idRecipe = Recipe_has_Cook.Recipe_idRecipe
        )
    );
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateSeasonEpisodes()
BEGIN
    DECLARE season_num INT;
    DECLARE episode_num INT;
    DECLARE num_episodes INT DEFAULT 10;
    DECLARE i INT DEFAULT 1;
    DECLARE j INT;
    DECLARE selected_cuisine INT;
    DECLARE selected_cook INT;
    DECLARE selected_recipe INT;
    DECLARE selected_judge INT;

    -- Get the next season number
    SELECT IFNULL(MAX(season), 0) + 1 INTO season_num FROM Episode;

    -- Create 10 episodes for the new season
    WHILE i <= num_episodes DO
        INSERT INTO Episode (season, episode_number)
        VALUES (season_num, i);
        SET i = i + 1;
    END WHILE;

    -- Create temporary tables to track consecutive appearances and selections within an episode
    CREATE TEMPORARY TABLE temp_participations (
        idCook INT,
        count INT DEFAULT 0
    );

    CREATE TEMPORARY TABLE temp_episode_cooks (
        idCook INT
    );

    CREATE TEMPORARY TABLE temp_episode_cuisines (
        idCuisine INT
    );

    CREATE TEMPORARY TABLE temp_episode_recipes (
        idRecipe INT
    );

    -- Loop over each new episode to assign cuisines, cooks, recipes, and judges
    SET i = 1;
    WHILE i <= num_episodes DO
        -- Get the current episode number
        SELECT MAX(idEpisode) INTO episode_num FROM Episode WHERE season = season_num AND episode_number = i;

        -- Randomly select 10 cuisines
        CREATE TEMPORARY TABLE temp_cuisines AS
        SELECT idCuisine FROM Cuisine ORDER BY RAND() LIMIT 10;

        SET j = 1;
        WHILE j <= 10 DO
            -- Select a random cuisine that hasn't been selected yet and doesn't appear in the last 3 episodes
            REPEAT
                SELECT idCuisine INTO selected_cuisine FROM temp_cuisines ORDER BY RAND() LIMIT 1;
            UNTIL selected_cuisine NOT IN (SELECT Cuisine_idCuisine FROM Episode_has_Participants 
                                           JOIN Episode ON Episode.idEpisode = Episode_has_Participants.Episode_idEpisode
                                           WHERE Episode.season = season_num AND Episode.episode_number > (i - 3))
            END REPEAT;

            -- Select a random cook for the selected cuisine who hasn't been selected yet in this episode
            REPEAT
                SELECT c.idCook INTO selected_cook 
                FROM Cook c
                JOIN Cook_has_Cuisine chc ON c.idCook = chc.Cook_idCook
                WHERE chc.Cuisine_idCuisine = selected_cuisine
                AND c.idCook NOT IN (SELECT idCook FROM temp_participations WHERE count >= 3)  -- ensure the cook has not participated more than 3 times consecutively
                ORDER BY RAND() LIMIT 1;
            UNTIL selected_cook NOT IN (SELECT idCook FROM temp_episode_cooks)
            END REPEAT;

            -- Select a random recipe for the selected cook that hasn't been selected yet and doesn't appear in the last 3 episodes
            REPEAT
                SELECT r.idRecipe INTO selected_recipe 
                FROM Recipe r
                WHERE r.Cook_idCook = selected_cook AND r.Cuisine_idCuisine = selected_cuisine
                AND r.idRecipe NOT IN (SELECT Recipe_idRecipe FROM Episode_has_Participants 
                                       JOIN Episode ON Episode.idEpisode = Episode_has_Participants.Episode_idEpisode
                                       WHERE Episode.season = season_num AND Episode.episode_number > (i - 3))
                ORDER BY RAND() LIMIT 1;
            UNTIL selected_recipe NOT IN (SELECT idRecipe FROM temp_episode_recipes)
            END REPEAT;

            -- Insert into Episode_has_Participants
            INSERT INTO Episode_has_Participants (Episode_idEpisode, Participant_id, Cuisine_idCuisine, Recipe_idRecipe)
            VALUES (episode_num, selected_cook, selected_cuisine, selected_recipe);

            -- Track selected cooks, cuisines, and recipes
            INSERT INTO temp_episode_cooks (idCook) VALUES (selected_cook);
            INSERT INTO temp_episode_cuisines (idCuisine) VALUES (selected_cuisine);
            INSERT INTO temp_episode_recipes (idRecipe) VALUES (selected_recipe);

            -- Update the participation count
            IF EXISTS (SELECT * FROM temp_participations WHERE idCook = selected_cook) THEN
                UPDATE temp_participations SET count = count + 1 WHERE idCook = selected_cook;
            ELSE
                INSERT INTO temp_participations (idCook, count) VALUES (selected_cook, 1);
            END IF;

            SET j = j + 1;
        END WHILE;

        -- Randomly select 3 judges for the episode from the Cook table who haven't been selected yet in this episode
        CREATE TEMPORARY TABLE temp_judges AS
                SELECT idCook FROM Cook 
        WHERE idCook NOT IN (SELECT idCook FROM temp_participations WHERE count >= 3)  -- ensure the cook has not judged more than 3 times consecutively
        ORDER BY RAND() LIMIT 3;

        SET j = 1;
        WHILE j <= 3 DO
            REPEAT
                SELECT idCook INTO selected_judge FROM temp_judges ORDER BY RAND() LIMIT 1;
            UNTIL selected_judge NOT IN (SELECT idCook FROM temp_episode_cooks)
            END REPEAT;

            -- Insert into Judge table if not already present
            IF NOT EXISTS (SELECT 1 FROM Judge WHERE idJudge = selected_judge) THEN
                INSERT INTO Judge (idJudge) VALUES (selected_judge);
            END IF;

            -- Insert into Episode_has_Judge
            INSERT INTO Episode_has_Judge (Episode_idEpisode, Judge_idJudge)
            VALUES (episode_num, selected_judge);

            -- Track selected judges
            INSERT INTO temp_episode_cooks (idCook) VALUES (selected_judge);

            SET j = j + 1;
        END WHILE;

        -- Create entries in the judge_scores_participant table
        INSERT INTO judge_scores_participant (episode_id, judge_id, participant_id, score)
        SELECT episode_num, selected_judge, selected_cook, 0
        FROM temp_judges;

        -- Clean up temporary tables for the episode
        DELETE FROM temp_episode_cooks;
        DELETE FROM temp_episode_cuisines;
        DELETE FROM temp_episode_recipes;
        DROP TEMPORARY TABLE IF EXISTS temp_cuisines;
        DROP TEMPORARY TABLE IF EXISTS temp_judges;

        SET i = i + 1;
    END WHILE;

    -- Drop temporary tables
    DROP TEMPORARY TABLE IF EXISTS temp_participations;
    DROP TEMPORARY TABLE IF EXISTS temp_episode_cooks;
    DROP TEMPORARY TABLE IF EXISTS temp_episode_cuisines;
    DROP TEMPORARY TABLE IF EXISTS temp_episode_recipes;
END //

DELIMITER ;





-- trigger for all cuisine/cook.judge/recipe in one
DELIMITER //
CREATE TRIGGER before_episode_insert
BEFORE INSERT ON Episode_has_Participants
FOR EACH ROW
BEGIN
    DECLARE last_episode_id INT;
    DECLARE last_episode_cook_participant INT;
    DECLARE last_episode_cook_judge INT;
    DECLARE last_episode_cuisine INT;
    DECLARE last_episode_recipe INT;
    
    -- Get the ID of the last episode in the same season
    SELECT Episode_idEpisode INTO last_episode_id 
    FROM Episode_has_Participants 
    WHERE Episode_idEpisode = NEW.Episode_idEpisode
    ORDER BY Episode_idEpisode DESC 
    LIMIT 1;

    IF last_episode_id IS NOT NULL THEN
        -- Get the number of times the cook appeared as a participant in the last episode
        SELECT COUNT(*) INTO last_episode_cook_participant
        FROM Episode_has_Participants
        WHERE Episode_idEpisode = last_episode_id
        AND Cook_idCook = NEW.Cook_idCook;

        -- Get the number of times the cook appeared as a judge in the last episode
        SELECT COUNT(*) INTO last_episode_cook_judge
        FROM Episode_has_Judges
        WHERE Episode_idEpisode = last_episode_id
        AND Judge_idJudge = NEW.Cook_idCook;

        -- Get the cuisine of the last episode
        SELECT Cuisine_idCuisine INTO last_episode_cuisine
        FROM Episode_has_Participants
        WHERE Episode_idEpisode = last_episode_id
        LIMIT 1;

        -- Get the recipe of the last episode
        SELECT Recipe_idRecipe INTO last_episode_recipe
        FROM Episode_has_Participants
        WHERE Episode_idEpisode = last_episode_id
        LIMIT 1;

        -- Check if the cook exceeds the limit as a participant or a judge
        IF last_episode_cook_participant >= 3 OR last_episode_cook_judge >= 3 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A cook cannot participate or judge in more than 3 consecutive episodes';
        END IF;

        -- Check if the same cuisine or recipe appears in the last episode
        IF last_episode_cuisine = NEW.Cuisine_idCuisine THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The same cuisine cannot appear in more than 3 consecutive episodes';
        END IF;

        IF last_episode_recipe = NEW.Recipe_idRecipe THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The same recipe cannot appear in more than 3 consecutive episodes';
        END IF;
    END IF;
END;
//
DELIMITER ;


-- after cookhasrecipe
DELIMITER //
CREATE TRIGGER after_cook_recipe_insert
AFTER INSERT ON Recipe_has_Cook
FOR EACH ROW
BEGIN
    DECLARE cuisine_exists INT;

    -- Check if the cook already has the cuisine of this recipe
    SELECT COUNT(*) INTO cuisine_exists
    FROM Cook_has_Cuisine
    WHERE Cook_idCook = NEW.Cook_idCook
    AND Cuisine_idCuisine = (SELECT Cuisine_idCuisine FROM Recipe WHERE idRecipe = NEW.Recipe_idRecipe);

    -- If the cuisine doesn't exist for the cook, insert a new entry
    IF cuisine_exists = 0 THEN
        INSERT INTO Cook_has_Cuisine (Cook_idCook, Cuisine_idCuisine) 
        VALUES (NEW.Cook_idCook, (SELECT Cuisine_idCuisine FROM Recipe WHERE idRecipe = NEW.Recipe_idRecipe));
    END IF;
END;
//
DELIMITER ;


-- after update cookhasrecipe
DELIMITER //
CREATE TRIGGER after_cook_recipe_update
AFTER UPDATE ON Recipe_has_Cook
FOR EACH ROW
BEGIN
    DECLARE cuisine_count INT;

    -- Count the number of recipes the cook has for the cuisine
    SELECT COUNT(*) INTO cuisine_count
    FROM Recipe_has_Cook rc
    WHERE rc.Cook_idCook = NEW.Cook_idCook
    AND rc.Cuisine_idCuisine = Cuisine_idCuisine;

    -- If the count is zero, delete the entry from Cook_has_Cuisine
    IF cuisine_count = 0 THEN
        DELETE FROM Cook_has_Cuisine
        WHERE Cook_idCook = NEW.Cook_idCook
        AND Cuisine_idCuisine = Cuisine_idCuisine;
    END IF;
END;
//
DELIMITER ;


-- after delete cookhasrecipe
DELIMITER //

CREATE PROCEDURE Delete_Recipe_Has_Cook_And_Check_Cuisine (
    IN p_Cook_id INT,
    IN p_Cuisine_id INT
)
BEGIN
    -- Delete from Recipe_has_Cook
    DELETE FROM Recipe_has_Cook
    WHERE Cook_idCook = p_Cook_id AND Cuisine_idCuisine = p_Cuisine_id;

    -- Check if there are any remaining recipes with the same cuisine
    IF NOT EXISTS (
        SELECT 1 FROM Recipe_has_Cook WHERE Cuisine_idCuisine = p_Cuisine_id
    ) THEN
        -- Delete the entry from Cook_has_Cuisine
        DELETE FROM Cook_has_Cuisine
        WHERE Cook_idCook = p_Cook_id AND Cuisine_idCuisine = p_Cuisine_id;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER after_delete_recipe_has_cook
AFTER DELETE ON Recipe_has_Cook
FOR EACH ROW
BEGIN
    DECLARE cuisine_id INT;
    
    -- Get the cuisine ID from the deleted row
    SELECT Cuisine_idCuisine INTO cuisine_id
    FROM Recipe_has_Cook
    WHERE Cook_idCook = OLD.Cook_idCook
    LIMIT 1;
    
    -- Call the stored procedure to delete and check cuisine
    CALL Delete_Recipe_Has_Cook_And_Check_Cuisine(OLD.Cook_idCook, cuisine_id);
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateMultipleSeasonsforsetseed()
BEGIN
    DECLARE i INT DEFAULT 1;

    -- Set a fixed seed for randomization
    SET SESSION rand_seed1 = 1;
    SET SESSION rand_seed2 = 1;

    -- Call GenerateSeasonEpisodes() six times to generate data for six seasons
    WHILE i <= 6 DO
        CALL GenerateSeasonEpisodes();
        SET i = i + 1;

        -- Reset the seed for the next call
        SET SESSION rand_seed1 = i;
        SET SESSION rand_seed2 = i;
    END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateMultipleSeasons(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    -- Call GenerateSeasonEpisodes() n times to generate data for n seasons
    WHILE i <= n DO
        CALL GenerateSeasonEpisodes();
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;


