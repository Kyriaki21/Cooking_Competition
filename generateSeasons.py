import random
import mysql.connector
from mysql.connector import Error
from datetime import datetime

# Database connection
def create_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='ccbcd668',
        database='Cooking_Competition'
    )

# Fetch data from the database
def fetch_data(cursor):
    cursor.execute("SELECT idCook FROM Cook")
    cooks = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT idCuisine FROM Cuisine")
    cuisines = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT idRecipe, Cuisine_id FROM Recipe")
    recipes = cursor.fetchall()

    return cooks, cuisines, recipes

# Insert data into Episode table
def insert_episode(cursor, episode_number, season_number):
    cursor.execute("INSERT INTO Episode (Episode_number, Season_number, last_update) VALUES (%s, %s, %s)", 
                   (episode_number, season_number, datetime.now()))
    return cursor.lastrowid

# Insert participants and judges
def insert_participants_and_judges(cursor, episode_id, participants, judges, recipes, selected_cuisines):
    for participant, cuisine in zip(participants, selected_cuisines):
        recipe = random.choice([r for r in recipes if r[1] == cuisine])
        cursor.execute("INSERT INTO Episode_has_Participants (Episode_idEpisode, Cook_idCook, Recipe_idRecipe, Cuisine_idCuisine, last_update) VALUES (%s, %s, %s, %s, %s)", 
                       (episode_id, participant, recipe[0], cuisine, datetime.now()))

    for judge in judges:
        cursor.execute("INSERT INTO Episode_has_Judges (Episode_idEpisode, Cook_idCook, last_update) VALUES (%s, %s, %s)", 
                       (episode_id, judge, datetime.now()))

# Check and update consecutive appearances
def can_participate(entity_dict, entity_id, current_episode, max_consecutive_episodes=3):
    if entity_id not in entity_dict:
        entity_dict[entity_id] = []
    if len(entity_dict[entity_id]) < max_consecutive_episodes:
        return True
    return (current_episode - entity_dict[entity_id][-max_consecutive_episodes]) > max_consecutive_episodes

def update_participation(entity_dict, entity_id, current_episode):
    if entity_id not in entity_dict:
        entity_dict[entity_id] = []
    entity_dict[entity_id].append(current_episode)
    if len(entity_dict[entity_id]) > 3:
        entity_dict[entity_id].pop(0)

# Main function
def main(seasons_count):
    try:
        connection = create_connection()
        cursor = connection.cursor()

        cooks, cuisines, recipes = fetch_data(cursor)

        if len(cuisines) < 10:
            raise ValueError("Not enough cuisines in the database to create episodes")

        cook_appearance = {}
        cuisine_appearance = {}
        recipe_appearance = {}

        for season in range(1, seasons_count + 1):
            for episode in range(1, 11):
                episode_id = insert_episode(cursor, episode, season)

                selected_cuisines = set()
                while len(selected_cuisines) < 10:
                    candidate_cuisines = [c for c in cuisines if can_participate(cuisine_appearance, c, episode)]
                    if not candidate_cuisines:
                        # Loosen the constraint to fill the episode
                        candidate_cuisines = cuisines
                    cuisine = random.choice(candidate_cuisines)
                    selected_cuisines.add(cuisine)
                    update_participation(cuisine_appearance, cuisine, episode)

                participants = []
                judges = []
                used_cooks = set()  # Keep track of used cooks in the episode

                for cuisine in selected_cuisines:
                    possible_participants = [cook for cook in cooks if cook not in used_cooks and can_participate(cook_appearance, cook, episode)]
                    if not possible_participants:
                        # Loosen the constraint to fill the episode
                        possible_participants = [cook for cook in cooks if cook not in used_cooks]
                    participant = random.choice(possible_participants)
                    participants.append(participant)
                    used_cooks.add(participant)
                    update_participation(cook_appearance, participant, episode)

                possible_judges = [cook for cook in cooks if cook not in used_cooks and can_participate(cook_appearance, cook, episode)]
                if len(possible_judges) < 3:
                    # Loosen the constraint to fill the episode
                    possible_judges = [cook for cook in cooks if cook not in used_cooks]
                judges = random.sample(possible_judges, 3)
                for judge in judges:
                    used_cooks.add(judge)
                    update_participation(cook_appearance, judge, episode)

                insert_participants_and_judges(cursor, episode_id, participants, judges, recipes, list(selected_cuisines))

        connection.commit()
        print("Data inserted successfully")

    except Error as e:
        print(f"Error: {e}")
        if connection:
            connection.rollback()
    except ValueError as ve:
        print(f"ValueError: {ve}")
    finally:
        if connection:
            cursor.close()
            connection.close()

if __name__ == "__main__":
    main(6)  # Example: Create 6 seasons
