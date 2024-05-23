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
  PRIMARY KEY (`Participant_id`),
  INDEX `fk_Episode_Participant_Episode1_idx` (`Episode_idEpisode` ASC),
  INDEX `fk_Episode_Participant_Cook1_idx` (`Cook_idCook` ASC),
  INDEX `fk_Episode_Participant_Recipe1_idx` (`Recipe_idRecipe` ASC),
  INDEX `fk_Episode_Participant_Cuisine1_idx` (`Cuisine_idCuisine` ASC),
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





--
-- Trigger to limit the number of tips per recipe
-- checked

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


-- ----------------------------------------------------------------------------------------------------------------------

-- 3.1. Average Rating (score) per cook and national cuisine
CREATE VIEW CookScoresByCuisine AS
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

DELIMITER //

CREATE PROCEDURE AVG_SCORE_CUISine_COOK()
BEGIN
	SELECT * FROM CookScoresByCuisine;
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

-- 3.2.b For a given season, the cooks participated in episodes
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
CREATE VIEW YoungCooksInEpisodes AS
SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    c.age,
    ep.idEpisode AS episode_id,
    ep.Episode_number,
    ep.Season_number,
    'Judge' AS role
FROM 
    Cook c
JOIN 
    Judge j ON c.idCook = j.Cook_idCook
JOIN 
    Episode_has_Judges ehj ON j.idJudge = ehj.Judge_idJudge
JOIN 
    Episode ep ON ehj.Episode_idEpisode = ep.idEpisode
WHERE 
    c.age < 30

UNION

SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    c.age,
    ep.idEpisode AS episode_id,
    ep.Episode_number,
    ep.Season_number,
    'Cook' AS role
FROM 
    Cook c
JOIN 
    Episode_has_Participants ehp ON c.idCook = ehp.Cook_idCook
JOIN 
    Episode ep ON ehp.Episode_idEpisode = ep.idEpisode
WHERE 
    c.age < 30;

DELIMITER //

CREATE PROCEDURE GetYoungCooksFromView()
BEGIN
    SELECT * FROM YoungCooksInEpisodes;
END //

DELIMITER ;


-- 3.4 Cooks who have never judged an episode
CREATE OR REPLACE VIEW CooksNeverJudged AS
SELECT 
    c.idCook,
    c.first_name,
    c.last_name,
    c.age
FROM 
    Cook c
LEFT JOIN 
    Judge j ON c.idCook = j.Cook_idCook
WHERE 
    j.Cook_idCook IS NULL;

DELIMITER //

CREATE PROCEDURE GetCooksNeverJudged()
BEGIN
    SELECT * FROM CooksNeverJudged;
END //

DELIMITER ;

-- 3.5 Judges who have participated in the same number of episodes over a period of one year with
CREATE OR REPLACE VIEW JudgesSameNumberOfEpisodes AS
SELECT 
    j.idJudge,
    j.Cook_idCook,
    COUNT(ej.Episode_idEpisode) AS num_episodes
FROM 
    Judge j
INNER JOIN 
    Episode_has_Judges ej ON j.idJudge = ej.Judge_idJudge
INNER JOIN 
    Episode e ON ej.Episode_idEpisode = e.idEpisode
WHERE 
    e.last_update >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY 
    j.idJudge, j.Cook_idCook
HAVING 
    num_episodes > 3

DELIMITER //

CREATE PROCEDURE GetJudgesWithSameNumberOfEpisodes()
BEGIN
    SELECT * FROM JudgesSameNumberOfEpisodes;
END //

DELIMITER ;


-- 3.7 All cooks who have participated at least 5 fewer times than the cook with the most episodes
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

    
-- 3.9 List of average number of grams of carbohydrates in the competition per sezon
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

DELIMITER //

CREATE PROCEDURE CalculateAverageCarbohydratesPerSeason()
BEGIN
    SELECT * FROM AverageCarbohydratesPerSeason;
END //

DELIMITER ;


-- 3.10 Cuisines have the same number of entries in competitions over two consecutive years, with at least 3 entries per year
CREATE VIEW ConsecutiveYearCuisines AS
SELECT 
    cc1.idCuisine,
    cc1.Cuisine,
    COUNT(DISTINCT ep1.idEpisode) AS Entries_Year1,
    COUNT(DISTINCT ep2.idEpisode) AS Entries_Year2
FROM 
    Cooking_Competition.Cuisine cc1
JOIN 
    Cooking_Competition.Recipe rec ON cc1.idCuisine = rec.Cuisine_id
JOIN 
    Cooking_Competition.Episode_has_Participants epp1 ON rec.idRecipe = epp1.Recipe_idRecipe
JOIN 
    Cooking_Competition.Episode ep1 ON epp1.Episode_idEpisode = ep1.idEpisode
JOIN 
    Cooking_Competition.Episode_has_Participants epp2 ON rec.idRecipe = epp2.Recipe_idRecipe
JOIN 
    Cooking_Competition.Episode ep2 ON epp2.Episode_idEpisode = ep2.idEpisode
WHERE 
    YEAR(ep1.last_update) = YEAR(ep2.last_update) - 1
GROUP BY 
    cc1.idCuisine
HAVING 
    Entries_Year1 >= 3 AND Entries_Year2 >= 3;


DELIMITER //

CREATE PROCEDURE GetConsecutiveYearCuisines()
BEGIN
    SELECT * FROM ConsecutiveYearCuisines;
END//

DELIMITER ;


-- 3.11 Top 5 reviewers who have given the highest overall rating to a cook

CREATE VIEW Top5JudgesTotalScoreView AS
    SELECT 
        (SELECT CONCAT_WS(' ', first_name, last_name) FROM Cook WHERE idCook = jp.Judge_idJudge) AS Judge_name,
        (SELECT CONCAT_WS(' ', first_name, last_name) FROM Cook WHERE idCook = jp.Participant_id) AS Participant_name,
        SUM(jp.Score) AS total_score
    FROM 
        Judge_Participant_Scores jp
    GROUP BY 
        Judge_name, Participant_name
    ORDER BY 
        total_score DESC
    LIMIT 5;
    
DELIMITER //

CREATE PROCEDURE CallTop5JudgesTotalScore()
BEGIN
    -- Select from the view to get the cuisines with the same number of entries over two consecutive years
    SELECT * FROM Top5JudgesTotalScoreView ;
END //

DELIMITER ;

-- 3.12  The most technically challenging, in terms of recipes, episode of the competition per year
CREATE VIEW EpisodeStatusSum AS
SELECT 
    e.idEpisode,
    SUM(CASE
        WHEN c.Status = 'C cook' THEN 1
        WHEN c.Status = 'B cook' THEN 2
        WHEN c.Status = 'A cook' THEN 3
        WHEN c.Status = 'assistant head Chef' THEN 4
        WHEN c.Status = 'Chef' THEN 5
        ELSE 0
    END) AS sum_status
FROM 
    Episode e
INNER JOIN
    Episode_has_Participants ep ON e.idEpisode = ep.Episode_idEpisode
INNER JOIN
    Cook c ON ep.Cook_idCook = c.idCook
GROUP BY 
    e.idEpisode;

DELIMITER //

CREATE PROCEDURE FindLowestSumStatusEpisode()
BEGIN
    -- Select the episode with the lowest sum of status values
    SELECT *
    FROM EpisodeStatusSum
    ORDER BY sum_status
    LIMIT 1;
END//

DELIMITER ;

-- 3.13 Episode garnered the lowest status ranking (judges and cooks)
-- Create the view to calculate the sum of status scores for judges and cooks
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
            WHEN j.idJudge IS NOT NULL THEN
                CASE
                    WHEN c.Status = 'C cook' THEN 1
                    WHEN c.Status = 'B cook' THEN 2
                    WHEN c.Status = 'A cook' THEN 3
                    WHEN c.Status = 'assistant head Chef' THEN 4
                    WHEN c.Status = 'Chef' THEN 5
                    ELSE 0
                END
            ELSE 0
        END) AS judge_status_sum
FROM
    Episode ep
    LEFT JOIN Episode_has_Participants ehp ON ep.idEpisode = ehp.Episode_idEpisode
    LEFT JOIN Cook c ON ehp.Cook_idCook = c.idCook
    LEFT JOIN Episode_has_Judges ehj ON ep.idEpisode = ehj.Episode_idEpisode
    LEFT JOIN Judge j ON ehj.Judge_idJudge = j.idJudge
    LEFT JOIN Cook cj ON j.Cook_idCook = cj.idCook
GROUP BY
    ep.idEpisode;


    
-- Create the procedure to select the episode with the lowest sum of status scores
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
    WHERE cook_status_sum + judge_status_sum = min_sum;
END //

DELIMITER ;

-- 3.14  Theme has appeared most often in the competition
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

DELIMITER //

CREATE PROCEDURE GetMostCommonConcept()
BEGIN
	SELECT * FROM MostCommonConceptAllEpisodes;
END //

DELIMITER ;

-- 3.15 Food groups that have never appeared in the competition
CREATE VIEW UnusedFoodGroupsView AS
    SELECT fg.*
    FROM Food_Group fg
    LEFT JOIN (
        SELECT DISTINCT rhi.Ingredients_idIngredients, ig.Food_Group_idFood_Group
        FROM Recipe_has_Ingredients rhi
        JOIN Ingredients ig ON rhi.Ingredients_idIngredients = ig.idIngredients
    ) rhi ON fg.idFood_Group = rhi.Food_Group_idFood_Group
    WHERE rhi.Ingredients_idIngredients IS NULL;

DELIMITER //

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
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateNextSeasonEpisodes()
BEGIN
  DECLARE EpisodeNumber INT DEFAULT 1;
  DECLARE MaxSeasonNumber INT;

  -- Get the current maximum season number
  SELECT IFNULL(MAX(Season_number), 0) INTO MaxSeasonNumber FROM `Cooking_Competition`.`Episode`;

  -- Increment to get the next season number
  SET MaxSeasonNumber = MaxSeasonNumber + 1;

  -- Insert 10 episodes for the new season
  WHILE EpisodeNumber <= 10 DO
    INSERT INTO `Cooking_Competition`.`Episode` (Episode_number, Season_number, last_update)
    VALUES (EpisodeNumber, MaxSeasonNumber, CURRENT_TIMESTAMP);
    SET EpisodeNumber = EpisodeNumber + 1;
  END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateMultipleSeasons(
  IN NumberOfSeasons INT
)
BEGIN
  DECLARE Counter INT DEFAULT 1;

  WHILE Counter <= NumberOfSeasons DO
    CALL GenerateNextSeasonEpisodes();
    SET Counter = Counter + 1;
  END WHILE;
END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE GetRandomCuisine(
  OUT CuisineID INT,
  IN LastEpisodeCuisine1 INT,
  IN LastEpisodeCuisine2 INT,
  IN LastEpisodeCuisine3 INT
)
BEGIN
  SELECT idCuisine INTO CuisineID
  FROM Cuisine
  WHERE idCuisine NOT IN (LastEpisodeCuisine1, LastEpisodeCuisine2, LastEpisodeCuisine3)
  ORDER BY RAND()
  LIMIT 1;

  IF CuisineID IS NOT NULL THEN
    -- Check if the selected cuisine has appeared in the last three episodes
    IF (CuisineID = LastEpisodeCuisine1 AND CuisineID = LastEpisodeCuisine2 AND CuisineID = LastEpisodeCuisine3) THEN
      -- Select another random cuisine if the selected cuisine has appeared in the last three episodes
      CALL GetRandomCuisine(CuisineID, LastEpisodeCuisine1, LastEpisodeCuisine2, LastEpisodeCuisine3);
    END IF;
  END IF;
END //


DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetRandomCookWithCuisine(
  OUT CookID INT,
  IN CuisineID INT,
  IN LastEpisodeID1 INT,
  IN LastEpisodeID2 INT,
  IN LastEpisodeID3 INT
)
BEGIN
  SELECT 
    idCook INTO CookID
  FROM 
    Cook
  WHERE 
    idCook NOT IN (
      SELECT DISTINCT Cook_idCook 
      FROM Episode_has_Participants 
      WHERE Episode_idEpisode IN (LastEpisodeID1, LastEpisodeID2, LastEpisodeID3)
    )
    AND idCook IN (
      SELECT Cook_idCook 
      FROM Cook_has_Cuisine 
      WHERE Cuisine_idCuisine = CuisineID
    )
    AND idCook NOT IN (
      SELECT DISTINCT Judge_idJudge 
      FROM Episode_has_Judges 
      WHERE Episode_idEpisode IN (LastEpisodeID1, LastEpisodeID2, LastEpisodeID3)
    )
  ORDER BY RAND()
  LIMIT 1;

  IF CookID IS NOT NULL THEN
    -- Check if the selected cook has appeared in the last episode
    IF (CookID IN (SELECT DISTINCT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = LastEpisodeID1)) THEN
      -- Select another random cook if the selected cook has appeared in the last episode
      CALL GetRandomCookWithCuisine(CookID, CuisineID, LastEpisodeID1, LastEpisodeID2, LastEpisodeID3);
    END IF;
  END IF;
END //




DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetRandomRecipeForCookAndCuisine(
  OUT RecipeID INT,
  IN CookID INT,
  IN CuisineID INT,
  IN LastEpisodeID1 INT,
  IN LastEpisodeID2 INT,
  IN LastEpisodeID3 INT
)
BEGIN
  SELECT rc.Recipe_idRecipe INTO RecipeID
  FROM Recipe_has_Cook rc
  JOIN Recipe r ON rc.Recipe_idRecipe = r.idRecipe
  WHERE rc.Cook_idCook = CookID
    AND r.Cuisine_id = CuisineID
    AND rc.Recipe_idRecipe NOT IN (
      SELECT Recipe_idRecipe
      FROM Episode_has_Participants
      WHERE Episode_idEpisode IN (LastEpisodeID1, LastEpisodeID2, LastEpisodeID3)
    )
  ORDER BY RAND()
  LIMIT 1;

  IF RecipeID IS NOT NULL THEN
    -- Check if the selected recipe has appeared in the last three episodes
    IF (RecipeID = LastEpisodeID1 AND RecipeID = LastEpisodeID2 AND RecipeID = LastEpisodeID3) THEN
      -- Select another random recipe if the selected recipe has appeared in the last three episodes
      CALL GetRandomRecipeForCookAndCuisine(RecipeID, CookID, CuisineID, LastEpisodeID1, LastEpisodeID2, LastEpisodeID3);
    END IF;
  END IF;
END //


DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetRandomJudge(
  OUT JudgeID INT,
  IN LastEpisodeID1 INT,
  IN LastEpisodeID2 INT,
  IN LastEpisodeID3 INT
)
BEGIN
  SELECT idCook INTO JudgeID
  FROM Cook
  WHERE idCook NOT IN (
    SELECT Judge_idJudge
    FROM Episode_has_Judges
    WHERE Episode_idEpisode IN (LastEpisodeID1, LastEpisodeID2, LastEpisodeID3)
  )
  AND idCook NOT IN (
    SELECT Cook_idCook
    FROM Episode_has_Participants
    WHERE Episode_idEpisode IN (LastEpisodeID1, LastEpisodeID2, LastEpisodeID3)
  )
  ORDER BY RAND()
  LIMIT 1;

  -- Check if the selected cook is not already a judge
  IF NOT EXISTS (
    SELECT 1
    FROM Judge
    WHERE idJudge = JudgeID
  ) THEN
    -- Insert the selected cook as a new judge
    INSERT INTO Judge (idJudge)
    VALUES (JudgeID);
  END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertEpisodeData(
  IN SeasonNumber INT
)
BEGIN
  DECLARE EpisodeNumber INT DEFAULT 1;
  DECLARE i INT;
  DECLARE CuisineID INT;
  DECLARE CookID INT;
  DECLARE RecipeID INT;

  -- Loop through each episode
  WHILE EpisodeNumber <= 10 DO
    SET i = 1;
    -- Pick 10 cuisines, cooks, and recipes
    WHILE i <= 10 DO
      -- Call the procedure to get a random cuisine
      CALL GetRandomCuisine(CuisineID, -1, -1, -1);
      
      -- Call the procedure to get a random cook for the cuisine
      CALL GetRandomCookWithCuisine(CookID, CuisineID, -1, -1, -1);
      
      -- Call the procedure to get a random recipe for the cook and cuisine
      CALL GetRandomRecipeForCookAndCuisine(RecipeID, CookID, CuisineID, -1, -1, -1);

      -- Check if RecipeID is not NULL and CookID is not NULL
      IF RecipeID IS NOT NULL AND CookID IS NOT NULL THEN
        -- Insert into Episode_has_Participants table
        INSERT INTO Episode_has_Participants (Episode_idEpisode, Cook_idCook, Recipe_idRecipe, Cuisine_idCuisine, last_update)
        VALUES (EpisodeNumber, CookID, RecipeID, CuisineID, CURRENT_TIMESTAMP);
      END IF;

      SET i = i + 1;
    END WHILE;

    SET EpisodeNumber = EpisodeNumber + 1;
  END WHILE;
END //


DELIMITER ;






















