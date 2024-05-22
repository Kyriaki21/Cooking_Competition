-- Delete data from tables
USE Cooking_Competition;

-- Drop foreign keys before deleting data
ALTER TABLE Tips DROP FOREIGN KEY fk_Tips_Recipe1;
ALTER TABLE Steps DROP FOREIGN KEY fk_Steps_Recipe1;
ALTER TABLE Recipe_has_Concept DROP FOREIGN KEY fk_Recipe_has_Concept_Recipe1;
ALTER TABLE Recipe_has_Concept DROP FOREIGN KEY fk_Recipe_has_Concept_Concept1;
ALTER TABLE Recipe_has_Cook DROP FOREIGN KEY fk_Recipe_has_Cook_Recipe1;
ALTER TABLE Recipe_has_Cook DROP FOREIGN KEY fk_Recipe_has_Cook_Cook1;
ALTER TABLE Recipe_has_Label DROP FOREIGN KEY fk_Recipe_has_Label_Recipe1;
ALTER TABLE Recipe_has_Label DROP FOREIGN KEY fk_Recipe_has_Label_Label1;
ALTER TABLE Recipe_has_Equipment DROP FOREIGN KEY fk_Recipe_has_Equipment_Recipe1;
ALTER TABLE Recipe_has_Equipment DROP FOREIGN KEY fk_Recipe_has_Equipment_Equipment1;
ALTER TABLE Recipe_has_Ingredients DROP FOREIGN KEY fk_Recipe_has_Ingredients_Recipe1;
ALTER TABLE Recipe_has_Ingredients DROP FOREIGN KEY fk_Recipe_has_Ingredients_Ingredients1;
ALTER TABLE Episode_has_Participants DROP FOREIGN KEY fk_Episode_Participant_Participant1;
ALTER TABLE Episode_has_Participants DROP FOREIGN KEY fk_Episode_Recipe_Participant1;
ALTER TABLE Episode_has_Participants DROP FOREIGN KEY fk_Episode_Cuisine_Participant1;
ALTER TABLE Episode_has_Judges DROP FOREIGN KEY fk_Episode_Judge_Judge1;
ALTER TABLE Episode_has_Judges DROP FOREIGN KEY fk_Episode_Judge_Episode1;
ALTER TABLE Judge DROP FOREIGN KEY fk_Judge1;
ALTER TABLE Cook_has_Cuisine DROP FOREIGN KEY fk_Cook_Cuisine_Cook1;
ALTER TABLE Cook_has_Cuisine DROP FOREIGN KEY fk_Cook_Cuisine_Cuisine1;

-- Delete data from tables
DELETE FROM Tips;
DELETE FROM Steps;
DELETE FROM Recipe_has_Concept;
DELETE FROM Recipe_has_Cook;
DELETE FROM Recipe_has_Label;
DELETE FROM Recipe_has_Equipment;
DELETE FROM Recipe_has_Ingredients;
DELETE FROM Judge_Participant_Scores;
DELETE FROM Episode_has_Participants;
DELETE FROM Episode_has_Judges;
DELETE FROM Judge;
DELETE FROM Cook_has_Cuisine;
DELETE FROM Cook;
DELETE FROM Label;
DELETE FROM Equipment;
DELETE FROM Ingredients;
DELETE FROM Food_Group;
DELETE FROM Recipe;
DELETE FROM Type_Meal;
DELETE FROM Cuisine;
DELETE FROM Image;

-- Reset auto-increment values
ALTER TABLE Tips AUTO_INCREMENT = 1;
ALTER TABLE Steps AUTO_INCREMENT = 1;
ALTER TABLE Recipe_has_Concept AUTO_INCREMENT = 1;
ALTER TABLE Recipe_has_Cook AUTO_INCREMENT = 1;
ALTER TABLE Recipe_has_Label AUTO_INCREMENT = 1;
ALTER TABLE Recipe_has_Equipment AUTO_INCREMENT = 1;
ALTER TABLE Recipe_has_Ingredients AUTO_INCREMENT = 1;
ALTER TABLE Judge_Participant_Scores AUTO_INCREMENT = 1;
ALTER TABLE Episode_has_Participants AUTO_INCREMENT = 1;
ALTER TABLE Episode_has_Judges AUTO_INCREMENT = 1;
ALTER TABLE Judge AUTO_INCREMENT = 1;
ALTER TABLE Cook_has_Cuisine AUTO_INCREMENT = 1;
ALTER TABLE Cook AUTO_INCREMENT = 1;
ALTER TABLE Label AUTO_INCREMENT = 1;
ALTER TABLE Equipment AUTO_INCREMENT = 1;
ALTER TABLE Ingredients AUTO_INCREMENT = 1;
ALTER TABLE Food_Group AUTO_INCREMENT = 1;
ALTER TABLE Recipe AUTO_INCREMENT = 1;
ALTER TABLE Type_Meal AUTO_INCREMENT = 1;
ALTER TABLE Cuisine AUTO_INCREMENT = 1;
ALTER TABLE Image AUTO_INCREMENT = 1;

-- Recreate foreign keys
ALTER TABLE Tips ADD CONSTRAINT fk_Tips_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Steps ADD CONSTRAINT fk_Steps_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Concept ADD CONSTRAINT fk_Recipe_has_Concept_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Concept ADD CONSTRAINT fk_Recipe_has_Concept_Concept1 FOREIGN KEY (Concept_idConcept) REFERENCES Concept(idConcept) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Cook ADD CONSTRAINT fk_Recipe_has_Cook_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Cook ADD CONSTRAINT fk_Recipe_has_Cook_Cook1 FOREIGN KEY (Cook_idCook) REFERENCES Cook(idCook) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Label ADD CONSTRAINT fk_Recipe_has_Label_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Label ADD CONSTRAINT fk_Recipe_has_Label_Label1 FOREIGN KEY (Label_idLabel) REFERENCES Label(idLabel) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Equipment ADD CONSTRAINT fk_Recipe_has_Equipment_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Equipment ADD CONSTRAINT fk_Recipe_has_Equipment_Equipment1 FOREIGN KEY (Equipment_idEquipment) REFERENCES Equipment(idEquipment) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Ingredients ADD CONSTRAINT fk_Recipe_has_Ingredients_Recipe1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Recipe_has_Ingredients ADD CONSTRAINT fk_Recipe_has_Ingredients_Ingredients1 FOREIGN KEY (Ingredients_idIngredients) REFERENCES Ingredients(idIngredients) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Episode_has_Participants ADD CONSTRAINT fk_Episode_Participant_Participant1 FOREIGN KEY (Cook_idCook) REFERENCES Cook(idCook) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Episode_has_Participants ADD CONSTRAINT fk_Episode_Recipe_Participant1 FOREIGN KEY (Recipe_idRecipe) REFERENCES Recipe(idRecipe) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Episode_has_Participants ADD CONSTRAINT fk_Episode_Cuisine_Participant1 FOREIGN KEY (Cuisine_idCuisine) REFERENCES Cuisine(idCuisine) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Episode_has_Judges ADD CONSTRAINT fk_Episode_Judge_Judge1 FOREIGN KEY (Judge_idJudge) REFERENCES Judge(idJudge) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Episode_has_Judges ADD CONSTRAINT fk_Episode_Judge_Episode1 FOREIGN KEY (Episode_idEpisode) REFERENCES Episode(idEpisode) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Judge ADD CONSTRAINT fk_Judge1 FOREIGN KEY (Cook_idCook) REFERENCES Cook(idCook) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Cook_has_Cuisine ADD CONSTRAINT fk_Cook_Cuisine_Cook1 FOREIGN KEY (Cook_idCook) REFERENCES Cook(idCook) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Cook_has_Cuisine ADD CONSTRAINT fk_Cook_Cuisine_Cuisine1 FOREIGN KEY (Cuisine_idCuisine) REFERENCES Cuisine(idCuisine) ON DELETE RESTRICT ON UPDATE CASCADE;
