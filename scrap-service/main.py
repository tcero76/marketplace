from prometheus_client import start_http_server
import threading
import psutil
import time
from arsmate.metrics import RAM_USAGE
from arsmate.login import get_cookies
from celery import Celery, chain
from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
import os
import subprocess
import psycopg2

SCRAPY_QUEUE = os.getenv("SCRAPY_QUEUE", "scrapy_queue")
app = Celery('arsmate', broker=os.environ.get("BROKER"))

metrics_thread_started = False

def start_metrics_server():
    port = int(os.getenv("PORT", 8000))
    start_http_server(port)
    while True:
        RAM_USAGE.set(psutil.virtual_memory().percent)
        time.sleep(5)



@app.task
def run_modelos(_=None):
    print(f"Inicia Run_modelos")
    subprocess.run(["scrapy", "crawl", "modelos"])

@app.task
def run_modelo(_=None):
    print(f"Inicia run_modelo")
    subprocess.run(["scrapy", "crawl", "modelo"])

@app.task
def ejecutar_funcion_postgres(_=None):
    print(f"Inicia ejecutar_funcion_postgres")
    url = os.getenv("DATABASE_URL")
    conn = psycopg2.connect(url)
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT scrap.actualizar_items_ultimos();")
            conn.commit()
    finally:
        conn.close()

@app.task
def obtener_cookies(_=None):
    print(f"Inicia get_cookies")
    get_cookies()

@app.task
def run_insta(_=None):
    print(f"Inicia Run_insta")
    subprocess.run(["scrapy", "crawl", "insta"])

@app.task
def run_modelo_spider():
    global metrics_thread_started
    if not metrics_thread_started:
        threading.Thread(target=start_metrics_server, daemon=True).start()
        metrics_thread_started = True
    chain(
        run_insta.s().set(queue=SCRAPY_QUEUE),
        obtener_cookies.s().set(queue=SCRAPY_QUEUE),
        run_modelo.s().set(queue=SCRAPY_QUEUE),
        ejecutar_funcion_postgres.s().set(queue=SCRAPY_QUEUE)
    ).apply_async()
