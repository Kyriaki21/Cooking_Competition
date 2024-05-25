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

# Fetch episode, participants, and judges data
def fetch_episode_data(cursor):
    cursor.execute("SELECT idEpisode FROM Episode")
    episodes = [row[0] for row in cursor.fetchall()]

    episode_participants = {}
    for episode in episodes:
        cursor.execute("SELECT Participant_id FROM Episode_has_Participants WHERE Episode_idEpisode = %s", (episode,))
        participants = [row[0] for row in cursor.fetchall()]
        episode_participants[episode] = participants

    episode_judges = {}
    for episode in episodes:
        cursor.execute("SELECT Judge_idJudge FROM Episode_has_Judges WHERE Episode_idEpisode = %s", (episode,))
        judges = [row[0] for row in cursor.fetchall()]
        episode_judges[episode] = judges

    return episodes, episode_participants, episode_judges

# Insert random scores
def insert_random_scores(cursor, episode, participants, judges):
    for judge in judges:
        for participant in participants:
            score = random.randint(1, 5)
            cursor.execute("INSERT INTO Judge_Participant_Scores (Episode_idEpisode, Participant_id, Judge_idJudge, Score, last_update) VALUES (%s, %s, %s, %s, %s)", 
                           (episode, participant, judge, score, datetime.now()))

# Main function
def main():
    try:
        connection = create_connection()
        cursor = connection.cursor()

        episodes, episode_participants, episode_judges = fetch_episode_data(cursor)

        for episode in episodes:
            participants = episode_participants[episode]
            judges = episode_judges[episode]
            insert_random_scores(cursor, episode, participants, judges)

        connection.commit()
        print("Scores inserted successfully")

    except Error as e:
        print(f"Error: {e}")
        if connection:
            connection.rollback()
    finally:
        if connection:
            cursor.close()
            connection.close()

if __name__ == "__main__":
    main()
