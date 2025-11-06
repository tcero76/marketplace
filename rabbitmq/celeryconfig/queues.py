from kombu import Exchange, Queue
import os

SCRAPY_EXCHANGE = os.getenv("CMD_SCRAPY_START_EXCHANGE", "cmd_scrapy_start_exchange")
SCRAPY_QUEUE = os.getenv("CMD_SCRAPY_START_QUEUE", "cmd_scrapy_start_queue")

RECOMMENDER_EXCHANGE = os.getenv("CMD_RECOMMENDER_CALCULATE_EXCHANGE", "cmd_recommender_calculate_exchange")
RECOMMENDER_QUEUE = os.getenv("CMD_RECOMMENDER_CALCULATE_QUEUE", "cmd_recommender_calculate_queue")

task_queues = (
    Queue(
        SCRAPY_QUEUE,
        exchange=Exchange(SCRAPY_EXCHANGE, type='direct'),
        routing_key='scrapy.run'
    ),
    Queue(
        RECOMMENDER_QUEUE,
        exchange=Exchange(RECOMMENDER_EXCHANGE, type='direct'),
        routing_key='recommendations.run'
    ),
)

task_queues_scrap = (
    Queue(
        SCRAPY_QUEUE,
        exchange=Exchange(SCRAPY_EXCHANGE, type='direct'),
        routing_key='scrapy.run'
    ),
)

task_queues_recomender= (
    Queue(
        RECOMMENDER_QUEUE,
        exchange=Exchange(RECOMMENDER_EXCHANGE, type='direct'),
        routing_key='recommendations.run'
    ),
)