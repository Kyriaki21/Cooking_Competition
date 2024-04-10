create database Cooking_Competition;

use Cooking_Competition;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Food_Group` (
  `idFood_Group` INT NOT NULL,
  `name_food_group` VARCHAR(45) NOT NULL,
  `description_food_group` VARCHAR(45) NOT NULL,
  `Recipe_Category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFood_Group`),
  UNIQUE INDEX `name_food_group_UNIQUE` (`name_food_group` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Equipment` (
  `idEquipment` INT NOT NULL,
  `equip_name` VARCHAR(45) NOT NULL,
  `equip_use` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`idEquipment`),
  UNIQUE INDEX `equip_name_UNIQUE` (`equip_name` ASC) VISIBLE,
  UNIQUE INDEX `equip_use_UNIQUE` (`equip_use` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Recipe` (
  `idRecipe` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `syntagi` VARCHAR(45) NOT NULL,
  `description` TEXT(500) NOT NULL,
  `difficulty` TINYINT NOT NULL,
  `prep_time` TINYINT NOT NULL,
  `cook_time` TINYINT NOT NULL,
  `portions` TINYINT NOT NULL,
  `Cuisine` VARCHAR(45) NOT NULL,
  `Type_meal` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRecipe`),
  CONSTRAINT range_dif check (difficulty IN (1,5)))
ENGINE = InnoDB
COMMENT = '\n';

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Label` (
  `idLabel` INT NOT NULL,
  `Label_name` VARCHAR(45) NULL,
  PRIMARY KEY (`idLabel`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Recipe_has_Label` (
  `Recipe_idRecipe` INT NOT NULL,
  `Label_idLabel` INT NOT NULL,
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
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Steps` (
  `idSteps` INT NOT NULL,
  `Step_number` TINYINT NOT NULL,
  `Step_description` VARCHAR(45) NOT NULL,
  `Recipe_idRecipe` INT NOT NULL,
  PRIMARY KEY (`idSteps`),
  INDEX `fk_Steps_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
  CONSTRAINT Unique_rec_step UNIQUE	(Recipe_idRecipe,idSteps),
  CONSTRAINT `fk_Steps_Recipe1`
    FOREIGN KEY (`Recipe_idRecipe`)
    REFERENCES `Cooking_Competition`.`Recipe` (`idRecipe`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Recipe_has_Equipment` (
  `Recipe_idRecipe` INT NOT NULL,
  `Equipment_idEquipment` INT NOT NULL,
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
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Ingredients` (
  `idIngredients` INT NOT NULL,
  `Ingredient_name` VARCHAR(45) NOT NULL,
  `fat` SMALLINT NULL,
  `protein` SMALLINT NULL,
  `carbohydrate` SMALLINT NULL,
  `calories` SMALLINT NULL,
  `Food_Group_idFood_Group` INT NOT NULL,
  `Measurement_Type` VARCHAR(45) NOT NULL,
  `Default_scale` TINYINT NOT NULL,
  PRIMARY KEY (`idIngredients`),
  INDEX `fk_Ingredients_Food_Group_idx` (`Food_Group_idFood_Group` ASC) VISIBLE,
  CONSTRAINT `fk_Ingredients_Food_Group`
    FOREIGN KEY (`Food_Group_idFood_Group`)
    REFERENCES `Cooking_Competition`.`Food_Group` (`idFood_Group`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cooking_Competition`.`Recipe_has_Ingredients` (
  `Recipe_idRecipe` INT NOT NULL,
  `Ingredients_idIngredients` INT NOT NULL,
  `Quantity` SMALLINT NULL,
  `is_basic` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Recipe_idRecipe`, `Ingredients_idIngredients`),
  INDEX `fk_Recipe_has_Ingredients_Ingredients1_idx` (`Ingredients_idIngredients` ASC) VISIBLE,
  INDEX `fk_Recipe_has_Ingredients_Recipe1_idx` (`Recipe_idRecipe` ASC) VISIBLE,
  CONSTRAINT unique_rec_label UNIQUE (Recipe_idRecipe,Ingredients_idIngredients),
  CONSTRAINT chk_basic CHECK (is_basic IN (0, 1)),
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
ENGINE = InnoDB;