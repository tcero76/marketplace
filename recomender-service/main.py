import pika
import implicit
import numpy as np
from scipy.sparse import csr_matrix
import psycopg2
from celery import Celery
import os
import clickhouse_connect
from datetime import datetime

QUEUE_NAME = os.getenv("RECOMENDER_QUEUE", "recommendation_queue")
BROKER = os.getenv("BROKER", "localhost")

app = Celery('main', broker=BROKER)

@app.task
def calculate_recommendations_task():
    data = fetch_interaction_data()
    users = fetch_users()
    items = fetch_items()
    recommendations = calculate_recommendations(data, users, items)
    update_recommendations(recommendations)

def fetch_interaction_data():
    url = os.getenv("DATABASE_URL")
    conn = psycopg2.connect(url)
    try:
        cursor = conn.cursor()
        # Consulta para obtener datos de interacción usuario-item
        query = """
        SELECT model_nick, id_user, magnitud
        FROM marketplace.users_model;
        """
        cursor.execute(query)
        rows = cursor.fetchall()
        user_item_data = np.array(rows, dtype=object)
        cursor.close()
        conn.close()
        return user_item_data
    except Exception as e:
        print(f"Error al obtener datos de PostgreSQL: {e}")
        return None

def fetch_users():
    url = os.getenv("DATABASE_URL")
    conn = psycopg2.connect(url)
    try:
        cursor = conn.cursor()
        # Consulta para obtener datos de usuarios
        query = """
        SELECT user_id FROM marketplace.users;
        """
        cursor.execute(query)
        users = [row[0] for row in cursor.fetchall()] 
        cursor.close()
        conn.close()
        return users
    except Exception as e:
        print(f"Error al obtener datos de PostgreSQL: {e}")

def fetch_items():
    url = os.getenv("DATABASE_URL")
    conn = psycopg2.connect(url)
    try:
        cursor = conn.cursor()
        query = """
        SELECT modelo FROM marketplace.modelos;
        """
        cursor.execute(query)
        items = [row[0] for row in cursor.fetchall()] 
        cursor.close()
        conn.close()
        print(f"Fetched {len(items)} items from PostgreSQL.")
        return items
    except Exception as e:
        print(f"Error al obtener datos de PostgreSQL: {e}")

def calculate_recommendations(data,users,items):
    user_map = {uuid: idx for idx, uuid in enumerate(users)}
    item_map = {item: idx for idx, item in enumerate(items)}
    interaction_dict = { (user_id, item_id): magnitud for item_id, user_id, magnitud in data }
    full_data = []
    for user_id in users:
        for item_id in items:
            magnitud = interaction_dict.get((user_id, item_id), 0) 
            full_data.append((user_id, item_id, magnitud))
    data = np.array(full_data,dtype=object)
    cols = [item_map[row[1]] for row in data]
    rows = [user_map[row[0]] for row in data]
    vals = [row[2] for row in data]
    user_item_matrix = csr_matrix((vals, (rows, cols)))
    model = implicit.als.AlternatingLeastSquares(factors=50, regularization=0.1)
    model.fit(user_item_matrix)
    recommendations = {}
    user_inv_map = {v: k for k, v in user_map.items()}
    item_inv_map = {v: k for k, v in item_map.items()}
    for user_id in range(user_item_matrix.shape[0]):
        recommended_items = model.recommend(user_id, user_item_matrix[user_id],len(items))
        item_indices, scores = recommended_items
        real_items = [(item_inv_map[i], score) for i, score in zip(item_indices, scores)]
        recommendations[user_inv_map[user_id]] = real_items
    return recommendations

def update_recommendations(recommendations):
    client = clickhouse_connect.get_client(
        host='clickhouse',
        port=8123,
        username=os.getenv("CLICKHOUSE_USER", "default"),
        password=os.getenv("CLICKHOUSE_PASSWORD", "default")
    )
    rows = []
    for user_id, item in recommendations.items():
        for id, score in item:
            rows.append([user_id, id, score, datetime.now()])
    create = '''
        CREATE TABLE IF NOT EXISTS recomendaciones (
            user_id UUID,
            modelo VARCHAR(255),
            score Float32,
            timestamp DateTime
        )
        ENGINE = MergeTree()
        ORDER BY (user_id, score)
        '''
    client.command(create)
    client.command('ALTER TABLE recomendaciones DELETE WHERE 1=1')
    client.insert(
        table='recomendaciones',
        data=rows,
        column_names=['user_id', 'modelo', 'score', 'timestamp']
    )