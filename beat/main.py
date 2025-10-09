from celery import Celery
import os
from celery.schedules import crontab
from datetime import timedelta


RECOMENDER_QUEUE = os.getenv("RECOMENDER_QUEUE", "recommendation_queue")
SCRAPY_QUEUE = os.getenv("SCRAPY_QUEUE", "scrapy_queue")
BROKER=os.environ.get("BROKER")

app = Celery('arsmate', broker=BROKER)

cron_hour = int(os.getenv("CRON_HOUR", "2"))
cron_minute = int(os.getenv("CRON_MINUTE", "30"))

app.conf.beat_schedule = {
    'run-spider': {
        'task': 'main.run_modelo_spider',
        'schedule': crontab(hour=cron_hour, minute=cron_minute),
        'options': {'queue': SCRAPY_QUEUE},
    },
    'run-recommendations': {
        'task': 'main.calculate_recommendations_task',
        'schedule': crontab(hour=cron_hour, minute=cron_minute),
        'options': {'queue': RECOMENDER_QUEUE},
    },
}

app.conf.timezone = 'UTC'