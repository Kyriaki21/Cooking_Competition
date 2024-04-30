
DROP SCHEMA IF EXISTS Cooking_Competition;
CREATE SCHEMA Cooking_Competition;
USE Cooking_Competition;

CREATE TABLE `Cooking_Competition`.`Cuisine` (
  `idCuisine` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cuisine` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCuisine`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Type_Meal` (
  `idType_Meal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type_Meal` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idType_Meal`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Food_Group` (
  `idFood_Group` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_food_group` VARCHAR(45) NOT NULL,
  `description_food_group` TEXT NOT NULL,
  `Recipe_Category` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idFood_Group`),
  UNIQUE INDEX `name_food_group_UNIQUE` (`name_food_group` ASC) VISIBLE,
  UNIQUE INDEX `Recipe_Category_UNIQUE` (`Recipe_Category` ASC) VISIBLE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Equipment` (
  `idEquipment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `equip_name` VARCHAR(45) NOT NULL,
  `equip_use` TEXT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEquipment`),
  UNIQUE INDEX `equip_name_UNIQUE` (`equip_name` ASC) VISIBLE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe` (
  `idRecipe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NOT NULL,
  `difficulty` TINYINT NOT NULL,
  `prep_time` TINYINT NOT NULL,
  `cook_time` TINYINT NOT NULL,
  `portions` TINYINT NOT NULL,
  `Cuisine_id` INT UNSIGNED NOT NULL,
  `Type_Meal_id` INT UNSIGNED NOT NULL,
  `Steps_text` TEXT NOT NULL,
  `syntagi` ENUM('cooking', 'pastry') NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRecipe`),
  INDEX `fk_Recipe_Cuisine1_idx` (`Cuisine_id` ASC) VISIBLE,
  INDEX `fk_Recipe_Type_Meal1_idx` (`Type_Meal_id` ASC) VISIBLE,
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

CREATE TABLE `Cooking_Competition`.`Concept` (
  `idConcept` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Concept_name` VARCHAR(255) NOT NULL,
  `Concept_description` TEXT DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idConcept`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Recipe_has_Concept` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Concept_idConcept` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Concept_idConcept`),
  INDEX `fk_Recipe_has_Concept_Concept1_idx` (`Concept_idConcept` ASC) VISIBLE,
  INDEX `fk_Recipe_has_Concept_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
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
  PRIMARY KEY (`idLabel`),
  UNIQUE INDEX  `Label_name_UNIQUE` (`Label_name` ASC) VISIBLE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Recipe_has_Label` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Label_idLabel` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Label_idLabel`),
  INDEX `fk_Recipe_has_Label_Label1_idx` (`Label_idLabel` ASC) VISIBLE,
  INDEX `fk_Recipe_has_Label_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
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

CREATE TABLE `Cooking_Competition`.`Steps` (
  `idSteps` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Step_number` TINYINT NOT NULL,
  `Step_description` TEXT NOT NULL,
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idSteps`),
  INDEX `fk_Steps_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
  CONSTRAINT Unique_rec_step UNIQUE	(Recipe_idRecipe,idSteps),
  CONSTRAINT `fk_Steps_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Equipment` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Equipment_idEquipment` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Equipment_idEquipment`),
  INDEX `fk_Recipe_has_Equipment_Equipment1_idx` (`Equipment_idEquipment` ASC) VISIBLE,
  INDEX `fk_Recipe_has_Equipment_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
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
  `Default_scale` TINYINT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idIngredients`),
  INDEX `fk_Ingredients_Food_Group_idx` (`Food_Group_idFood_Group` ASC) VISIBLE,
  CONSTRAINT `fk_Ingredients_Food_Group`
    FOREIGN KEY (`Food_Group_idFood_Group`)
    REFERENCES `Cooking_Competition`.`Food_Group` (`idFood_Group`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT fat_pos_constraint CHECK (COALESCE(fat, 0) >= 0),
    CONSTRAINT protein_pos_constraint CHECK (COALESCE(protein, 0) >= 0),
    CONSTRAINT carbohydrate_pos_constraint CHECK (COALESCE(carbohydrate, 0) >= 0),
    CONSTRAINT calories_pos_constraint CHECK (COALESCE(calories, 0) >= 0),
    UNIQUE INDEX  `Ingredient_name_UNIQUE` (`Ingredient_name` ASC) VISIBLE)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Recipe_has_Ingredients` (
  `Recipe_idRecipe` INT UNSIGNED NOT NULL,
  `Ingredients_idIngredients` INT UNSIGNED NOT NULL,
  `Quantity` SMALLINT NOT NULL,
  `is_basic` TINYINT NOT NULL DEFAULT 0,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Recipe_idRecipe`, `Ingredients_idIngredients`),
  INDEX `fk_Recipe_has_Ingredients_Ingredients1_idx` (`Ingredients_idIngredients` ASC) VISIBLE,
  INDEX `fk_Recipe_has_Ingredients_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
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
  PRIMARY KEY (`idCook`))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Judge` (
  `idJudge` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idJudge`),
  INDEX `fk_Judge1_idx` (`Cook_idCook` ASC) VISIBLE,
  CONSTRAINT `fk_Judge1`
    FOREIGN KEY (`Cook_idCook`)
    REFERENCES `Cooking_Competition`.`Cook` (`idCook`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE  `Cooking_Competition`.`Cook_Cuisine` (
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `Cuisine_idCuisine` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Cook_idCook`, `Cuisine_idCuisine`),
  INDEX `fk_Cook_Cuisine_Cuisine1_idx` (`Cuisine_idCuisine` ASC) VISIBLE,
  INDEX `fk_Cook_Cuisine_Cook1_idx` (`Cook_idCook` ASC) VISIBLE,
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

CREATE TABLE `Cooking_Competition`.`Season` (
  `idSeason` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idSeason`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode` (
  `idEpisode` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Episode_number` INT NOT NULL,
  `Season_idSeason` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEpisode`),
  INDEX `fk_Episode_Season1_idx` (`Season_idSeason` ASC) VISIBLE,
  CONSTRAINT `fk_Episode_Season1`
    FOREIGN KEY (`Season_idSeason`)
    REFERENCES `Cooking_Competition`.`Season` (`idSeason`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Cooking_Competition`.`Episode_Participant` (
  `Episode_idEpisode` INT UNSIGNED NOT NULL,
  `Cook_idCook` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Episode_idEpisode`, `Cook_idCook`),
  INDEX `fk_Episode_Participant_Participant1_idx` (`Cook_idCook` ASC) VISIBLE,
  INDEX `fk_Episode_Participant_Episode1_idx` (`Episode_idEpisode` ASC) VISIBLE,
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

--
-- Procedure structure for procedure `calc_nutritional_values`
--

DELIMITER //

CREATE PROCEDURE CalculateRecipeNutrition(IN recipe_id INT)
BEGIN
    DECLARE total_calories DECIMAL(10,2) DEFAULT 0;
    DECLARE total_fat DECIMAL(10,2) DEFAULT 0;
    DECLARE total_protein DECIMAL(10,2) DEFAULT 0;
    DECLARE total_carbohydrate DECIMAL(10,2) DEFAULT 0;
    DECLARE total_weight DECIMAL(10,2) DEFAULT 0;
    DECLARE servings INT;
	DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR 
        SELECT Ingredients_idIngredients, Quantity
        FROM Recipe_has_Ingredients
        WHERE Recipe_idRecipe = recipe_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Get the total number of servings for the recipe
    SELECT portions INTO servings
    FROM Recipe
    WHERE idRecipe = recipe_id;
    
    -- Iterate through ingredients
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO ingredient_id, quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate total weight of ingredient in grams
        SET total_weight = quantity;
        
        -- Calculate calories, fat, protein, and carbohydrate per serving for each ingredient
        SELECT 
            (i.calories / 100 * total_weight) / servings AS calories,
            (i.fat / 100 * total_weight) / servings AS fat,
            (i.protein / 100 * total_weight) / servings AS protein,
            (i.carbohydrate / 100 * total_weight) / servings AS carbohydrate
        INTO 
            @calories, @fat, @protein, @carbohydrate
        FROM Ingredients i
        WHERE i.idIngredients = ingredient_id;
        
        -- Sum up total calories, fat, protein, and carbohydrate for the recipe
        SET total_calories = total_calories + @calories;
        SET total_fat = total_fat + @fat;
        SET total_protein = total_protein + @protein;
        SET total_carbohydrate = total_carbohydrate + @carbohydrate;
    END LOOP;
    
    CLOSE cur;

    -- Update recipe table with calculated nutritional information
    UPDATE Recipe
    SET calories_per_serving = total_calories,
        fat_per_serving = total_fat,
        protein_per_serving = total_protein,
        carbohydrate_per_serving = total_carbohydrate
    WHERE idRecipe = recipe_id;
    
END //

DELIMITER ;

--
-- Procedure for step count step 
--
DELIMITER //

CREATE PROCEDURE create_steps(
    IN Steps_text_input TEXT
)
BEGIN
    DECLARE step_text VARCHAR(255);
    DECLARE step_number INT DEFAULT 1;
    DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE step_start INT DEFAULT 1;
    DECLARE step_end INT DEFAULT 1;
    
    -- Find the first occurrence of "Step [number]: " in the recipe text
        SET step_start = LOCATE(CONCAT('Step ', step_number, ': '), Steps_text_input);
        
        -- If "Step [number]: " is not found, exit the loop
        IF step_start = 0 THEN
            SET done = TRUE;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have not inserted proper steps';
        END IF;
        
    WHILE NOT done DO
        
        -- Find the end of the current step (the start of the next step or the end of the text)
        SET step_end = LOCATE(CONCAT('Step ', step_number + 1, ': '), Steps_text_input);
        IF step_end = 0 THEN
            SET step_end = LENGTH(Steps_text_input) + 1;
        END IF;
        
        -- Extract the step text between step_start and step_end
        SET step_text = SUBSTRING(Steps_text_input, step_start, step_end - step_start);
        
        -- Insert the step into the recipe_steps table
        INSERT INTO Steps (Step_number,Step_description,Recipe_idRecipe)
        VALUES ((SELECT step_number, step_text,LAST_INSERT_ID()));
        
        -- Increment the step number
        SET step_number = step_number + 1;
        -- Find the next occurrence of "Step [number]: " in the recipe text
        SET step_start = LOCATE(CONCAT('Step ', step_number, ': '), Steps_text_input);
        
        -- If "Step [number]: " is not found, exit the loop
        IF step_start = 0 THEN
            SET done = TRUE;
        END IF;
        
    END WHILE;
END

DELIMITER ;