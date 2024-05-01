  + Steps *** 

Triggers: 
  + After insert in Recipe_has_Ingredients 
  + Before delete in Recipe_has_Ingredients
  + Before update when is changing ingredient or quantiny
  + Before update the fat, protein, carbohydrate, calories you need to adjust `calc_nutritional_values` in
    Ingredient
  + The same cook can't be participate in episode more than 3 consecutive times


Procedures: 
  + Procedure structure for `calc_nutritional_values` when add ingredient
  + Procedure structure for `calc_nutritional_values` when delete ingredient
  + Procedure structure for `calc_nutritional_values` when change quantity I want to delete
    the old value of this ingredient and add the new value of ingredient
  + Procedure structure for `calc_nutritional_values` when change portions I want to delete
    the old value of this ingredient and add the new value of ingredient

Tables:
  + Make the table images
    Attaching image files to a database without a graphical user interface (GUI) typically involves storing the images directly in the database as binary large objects (BLOBs) or storing references (e.g., file paths or URLs) to the images. 
