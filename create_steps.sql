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