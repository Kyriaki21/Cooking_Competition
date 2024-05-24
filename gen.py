import mysql.connector
import random

# Establishing the connection to the database
db = mysql.connector.connect(
    host="localhost",
    user="root",  # replace with your MySQL username
    password="ccbcd668",  # replace with your MySQL password
    database="Cooking_Competition"
)

cursor = db.cursor()

def assign_participants_to_episodes():
    print("Starting to assign participants to episodes")
    cursor.execute("DROP TEMPORARY TABLE IF EXISTS DebugTemp")
    cursor.execute("""
        CREATE TEMPORARY TABLE DebugTemp (
            stage VARCHAR(50),
            episode_id INT,
            cuisine_id INT,
            cook_id INT,
            recipe_id INT,
            status VARCHAR(50)
        )
    """)

    cursor.execute("SELECT idEpisode FROM Episode ORDER BY idEpisode")
    episodes = cursor.fetchall()
    print(f"Fetched {len(episodes)} episodes")

    for (episode_id,) in episodes:
        cursor.execute("DROP TEMPORARY TABLE IF EXISTS TempCuisines")
        cursor.execute("CREATE TEMPORARY TABLE TempCuisines AS SELECT idCuisine FROM Cuisine ORDER BY RAND() LIMIT 10")
        
        while True:
            cursor.execute("SELECT COUNT(*) FROM Episode_has_Participants WHERE Episode_idEpisode = %s", (episode_id,))
            participant_count = cursor.fetchone()[0]

            if participant_count >= 10:
                print(f"Episode {episode_id} already has 10 participants.")
                break

            cursor.execute("SELECT idCuisine FROM TempCuisines")
            cuisines = cursor.fetchall()
            print(f"Fetched {len(cuisines)} cuisines for episode {episode_id}")

            for (cuisine_id,) in cuisines:
                cursor.execute("""
                    SELECT Cook_idCook FROM Cook_has_Cuisine
                    WHERE Cuisine_idCuisine = %s
                    AND Cook_idCook NOT IN (
                        SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode = %s
                    )
                    AND Cook_idCook NOT IN (
                        SELECT Cook_idCook FROM Episode_has_Judges WHERE Episode_idEpisode = %s
                    )
                    AND Cook_idCook NOT IN (
                        SELECT Cook_idCook FROM (
                            SELECT Cook_idCook FROM Episode_has_Participants WHERE Episode_idEpisode != %s ORDER BY Episode_idEpisode DESC LIMIT 3
                        ) AS RecentEpisodes
                    )
                    ORDER BY RAND() LIMIT 1
                """, (cuisine_id, episode_id, episode_id, episode_id))
                cook = cursor.fetchone()

                if cook:
                    cook_id = cook[0]
                    cursor.execute("""
                        SELECT idRecipe FROM Recipe
                        WHERE Cuisine_id = %s
                        AND idRecipe IN (
                            SELECT Recipe_idRecipe FROM Recipe_has_Cook WHERE Cook_idCook = %s
                        )
                        AND idRecipe NOT IN (
                            SELECT Recipe_idRecipe FROM Episode_has_Participants WHERE Episode_idEpisode = %s
                        )
                        AND idRecipe NOT IN (
                            SELECT Recipe_idRecipe FROM (
                                SELECT Recipe_idRecipe FROM Episode_has_Participants WHERE Episode_idEpisode != %s ORDER BY Episode_idEpisode DESC LIMIT 3
                            ) AS RecentRecipes
                        )
                        ORDER BY RAND() LIMIT 1
                    """, (cuisine_id, cook_id, episode_id, episode_id))
                    recipe = cursor.fetchone()

                    if recipe:
                        recipe_id = recipe[0]

                        # Check for duplicates before inserting
                        cursor.execute("""
                            SELECT COUNT(*) FROM Episode_has_Participants
                            WHERE Episode_idEpisode = %s AND Cuisine_idCuisine = %s
                        """, (episode_id, cuisine_id))
                        cuisine_duplicate = cursor.fetchone()[0]

                        if cuisine_duplicate == 0:
                            cursor.execute("""
                                INSERT INTO Episode_has_Participants (Episode_idEpisode, Cook_idCook, Recipe_idRecipe, Cuisine_idCuisine)
                                VALUES (%s, %s, %s, %s)
                            """, (episode_id, cook_id, recipe_id, cuisine_id))
                            cursor.execute("""
                                INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                                VALUES ('Inserted', %s, %s, %s, %s, 'Success')
                            """, (episode_id, cuisine_id, cook_id, recipe_id))
                            print(f"Inserted participant: episode {episode_id}, cuisine {cuisine_id}, cook {cook_id}, recipe {recipe_id}")
                        else:
                            cursor.execute("""
                                INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                                VALUES ('Skipped', %s, %s, %s, %s, 'Duplicate')
                            """, (episode_id, cuisine_id, cook_id, recipe_id))
                            print(f"Skipped participant: episode {episode_id}, cuisine {cuisine_id} (duplicate)")
                    else:
                        cursor.execute("""
                            INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                            VALUES ('Skipped', %s, %s, %s, NULL, 'NoRecipe')
                        """, (episode_id, cuisine_id, cook_id))
                        print(f"Skipped participant: episode {episode_id}, cuisine {cuisine_id}, cook {cook_id} (no recipe)")
                else:
                    cursor.execute("""
                        INSERT INTO DebugTemp (stage, episode_id, cuisine_id, cook_id, recipe_id, status)
                        VALUES ('Skipped', %s, %s, NULL, NULL, 'NoCook')
                    """, (episode_id, cuisine_id))
                    print(f"Skipped participant: episode {episode_id}, cuisine {cuisine_id} (no cook)")

    cursor.execute("SELECT * FROM DebugTemp")
    debug_info = cursor.fetchall()
    for row in debug_info:
        print(row)

def assign_judges_to_episodes():
    print("Starting to assign judges to episodes")
    cursor.execute("DROP TEMPORARY TABLE IF EXISTS DebugTempJudges")
    cursor.execute("""
        CREATE TEMPORARY TABLE DebugTempJudges (
            stage VARCHAR(50),
            episode_id INT,
            judge_id INT,
            status VARCHAR(50)
        )
    """)

    cursor.execute("SELECT idEpisode FROM Episode ORDER BY idEpisode")
    episodes = cursor.fetchall()
    print(f"Fetched {len(episodes)} episodes")

    for (episode_id,) in episodes:
        while True:
            cursor.execute("SELECT COUNT(*) FROM Episode_has_Judges WHERE Episode_idEpisode = %s", (episode_id,))
            judge_count = cursor.fetchone()[0]

            if judge_count >= 3:
                print(f"Episode {episode_id} already has 3 judges.")
                break

            cursor.execute("SELECT idCook FROM Cook")
            all_judges = cursor.fetchall()

            eligible_judges = []
            for (judge_id,) in all_judges:
                cursor.execute("""
                    SELECT COUNT(*) FROM Episode_has_Participants WHERE Episode_idEpisode = %s AND Cook_idCook = %s
                """, (episode_id, judge_id))
                if cursor.fetchone()[0] == 0:
                    cursor.execute("""
                        SELECT COUNT(*) FROM Episode_has_Judges WHERE Episode_idEpisode = %s AND Cook_idCook = %s
                    """, (episode_id, judge_id))
                    if cursor.fetchone()[0] == 0:
                        eligible_judges.append(judge_id)

            if not eligible_judges:
                print(f"No eligible judges found for episode {episode_id}")
                break

            selected_judge = random.choice(eligible_judges)
            cursor.execute("""
                INSERT INTO Episode_has_Judges (Episode_idEpisode, Cook_idCook)
                VALUES (%s, %s)
            """, (episode_id, selected_judge))
            cursor.execute("""
                INSERT INTO DebugTempJudges (stage, episode_id, judge_id, status)
                VALUES ('Inserted', %s, %s, 'Success')
            """, (episode_id, selected_judge))
            print(f"Inserted judge: episode {episode_id}, judge {selected_judge}")

    cursor.execute("SELECT * FROM DebugTempJudges")
    debug_info = cursor.fetchall()
    for row in debug_info:
        print(row)

# Call the functions to assign participants and judges
assign_participants_to_episodes()
assign_judges_to_episodes()

# Commit the changes to the database
db.commit()

# Close the cursor and the connection
cursor.close()
db.close()
