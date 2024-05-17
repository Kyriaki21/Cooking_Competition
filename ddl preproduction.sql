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
  INDEX `fk_Cook_Cuisine_Cuisine1_idx` (`Cuisine_idCuisine` ASC)  ,
  INDEX `fk_Cook_Cuisine_Cook1_idx` (`Cook_idCook` ASC)  ,
  CONSTRAINT unique_rec_concept UNIQUE (Cook_idCook,Cuisine_idCuisine),
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
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Episode_idEpisode`, `Cook_idCook`),
  INDEX `fk_Participant_id_idx` (`Participant_id` ASC),
  INDEX `fk_Episode_Participant_Participant1_idx` (`Cook_idCook` ASC)  ,
  INDEX `fk_Episode_Participant_Episode1_idx` (`Episode_idEpisode` ASC)  ,
  CONSTRAINT `fk_Episode_Participant_Episode1`
    FOREIGN KEY (`Episode_idEpisode`)
    REFERENCES `Cooking_Competition`.`Episode` (`idEpisode`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Episode_Participant_Participant1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
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
-- Procedure structure for `calc_nutritional_values`
--

DELIMITER //

-- Stored procedure to calculate nutritional values for a recipe
CREATE PROCEDURE CalculateRecipeNutrition(IN recipe_id INT)
BEGIN
    DECLARE total_calories DECIMAL(10,2) DEFAULT 0;
    DECLARE total_fat DECIMAL(10,2) DEFAULT 0;
    DECLARE total_protein DECIMAL(10,2) DEFAULT 0;
    DECLARE total_carbohydrate DECIMAL(10,2) DEFAULT 0;
    DECLARE total_weight DECIMAL(10,2) DEFAULT 0;
    DECLARE servings INT DEFAULT 1;
    DECLARE done INT DEFAULT FALSE;
    DECLARE ingredient_id INT;
    DECLARE quantity INT;

    -- Cursor to iterate over the ingredients of the recipe
    DECLARE ingredient_cursor CURSOR FOR 
        SELECT Ingredients_idIngredients, quantity
        FROM Recipe_has_Ingredients
        WHERE Recipe_idRecipe = recipe_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Get the total number of servings for the recipe
    SELECT portions INTO servings
    FROM Recipe
    WHERE idRecipe = recipe_id;

    -- Open the cursor
    OPEN ingredient_cursor;

    -- Loop through the ingredients
    read_loop: LOOP
        FETCH ingredient_cursor INTO ingredient_id, quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate total weight of ingredient in grams
        SET total_weight = quantity;

        -- Calculate calories, fat, protein, and carbohydrate per serving for each ingredient
        SELECT 
            (i.total_calories / 100 * total_weight) / servings AS calories,
            (i.total_fat / 100 * total_weight) / servings AS fat,
            (i.total_protein / 100 * total_weight) / servings AS protein,
            (i.total_carbohydrate / 100 * total_weight) / servings AS carbohydrate
        INTO 
            @calories_per_serving, @fat_per_serving, @protein_per_serving, @carbohydrate_per_serving
        FROM Ingredients i
        WHERE i.idIngredients = ingredient_id;

        -- Sum up total calories, fat, protein, and carbohydrate for the recipe
        SET total_calories = total_calories + @calories_per_serving;
        SET total_fat = total_fat + @fat_per_serving;
        SET total_protein = total_protein + @protein_per_serving;
        SET total_carbohydrate = total_carbohydrate + @carbohydrate_per_serving;
    END LOOP;

    -- Close the cursor
    CLOSE ingredient_cursor;

    -- Update recipe table with calculated nutritional information
    UPDATE Recipe
    SET total_calories = total_calories,
        total_fat = total_fat,
        total_protein = total_protein,
        total_carbohydrate = total_carbohydrate
    WHERE idRecipe = recipe_id;
END //

DELIMITER ;

-- Trigger to call the procedure after insert on Recipe_has_Ingredients
DELIMITER //

CREATE TRIGGER AfterInsertRecipeIngredient
AFTER INSERT ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL CalculateRecipeNutrition(NEW.Recipe_idRecipe);
END //

DELIMITER ;

DELIMITER //

-- Trigger to call the procedure after delete on Recipe_has_Ingredients
CREATE TRIGGER AfterDeleteRecipeIngredient
AFTER DELETE ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    CALL CalculateRecipeNutrition(OLD.Recipe_idRecipe);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateRecipeIngredient
BEFORE UPDATE ON Recipe_has_Ingredients
FOR EACH ROW
BEGIN
    IF NEW.Quantity != OLD.Quantity THEN
        CALL CalculateRecipeNutrition(OLD.Recipe_idRecipe);
    END IF;
END //

DELIMITER ;

--
-- Procedure for tips in recipes
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

            -- Recalculate nutritional values for the recipe
            CALL CalculateRecipeNutrition(recipe_id);
        END LOOP;

        CLOSE recipe_cursor;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE CalculateEpisodeWinner(IN episode_id INT)
BEGIN
    DECLARE max_score INT DEFAULT 0;
    DECLARE winner_id INT DEFAULT 0;
    DECLARE total_score INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE participant_cursor CURSOR FOR 
        SELECT Participant_id
        FROM Episode_has_Participants
        WHERE Episode_idEpisode = episode_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Cursor to iterate over all participants of the episode
    OPEN participant_cursor;
    
    participant_loop: LOOP
        FETCH participant_cursor INTO winner_id;
        IF done THEN
            LEAVE participant_loop;
        END IF;
        
        -- Calculate the total score for the current participant
        SELECT SUM(Score) INTO total_score
        FROM Judge_Participant_Scores
        WHERE Episode_idEpisode = episode_id AND Participant_id = winner_id;
        
        -- Check if the current participant's score is the highest
        IF total_score > max_score THEN
            SET max_score = total_score;
            SET winner_id = winner_id;
        END IF;
    END LOOP;

    CLOSE participant_cursor;

    -- Update the episode table with the winner's id
    UPDATE Episode
    SET winner_id = winner_id
    WHERE idEpisode = episode_id;
    
END //

DELIMITER ;

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

DELIMITER //

CREATE TRIGGER Before_Insert_Step
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
