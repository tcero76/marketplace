from celery import Celery
import os
from celery.schedules import crontab
from datetime import timedelta
from rabbitmq.celeryconfig import queues, routes

cron_hour = int(os.getenv("CRON_HOUR", "2"))
cron_minute = int(os.getenv("CRON_MINUTE", "30"))

app = Celery('arsmate')
app.conf.update(
    broker_url=os.environ.get("BROKER"),
    task_queues=queues.task_queues,
    task_routes=routes.task_routes,
    beat_schedule={
        'run-spider': {
            'task': 'main.run_modelo_spider',
            'schedule': crontab(hour=cron_hour, minute=cron_minute),
            'options': {'queue': os.getenv("CMD_SCRAPY_START_QUEUE", "cmd_scrapy_start_queue")},
        },
        'run-recommendations': {
            'task': 'main.calculate_recommendations_task',
            'schedule': crontab(hour=cron_hour, minute=cron_minute),
            'options': {'queue': os.getenv("CMD_RECOMMENDER_CALCULATE_QUEUE", "cmd_recommender_calculate_queue")},
        },
    },
    timezone='UTC',
)