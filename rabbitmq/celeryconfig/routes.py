from .queues import SCRAPY_QUEUE, RECOMMENDER_QUEUE
import os

SCRAPY_QUEUE = os.getenv("CMD_SCRAPY_START_QUEUE", "cmd_scrapy_start_queue")
RECOMMENDER_QUEUE = os.getenv("CMD_RECOMMENDER_CALCULATE_QUEUE", "cmd_recommender_calculate_queue")

task_routes = {
    'main.run_modelo_spider': {
        'queue': SCRAPY_QUEUE,
        'routing_key': 'scrapy.run',
    },
    'main.calculate_recommendations_task': {
        'queue': RECOMMENDER_QUEUE,
        'routing_key': 'recommendations.run',
    },
}
 