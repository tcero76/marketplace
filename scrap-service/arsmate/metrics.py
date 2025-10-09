# metrics.py
from prometheus_client import Summary, Gauge, Counter

# Métricas personalizadas
RAM_USAGE = Gauge('scraper_ram_usage_percent', 'RAM usage in percent')
REQUEST_LATENCY = Summary('scraper_request_latency_seconds', 'Time taken per request')
ACTIVE_REQUESTS = Gauge('scraper_active_requests', 'Number of active HTTP requests')
REQUESTS_COMPLETED = Counter('scraper_requests_total', 'Total number of HTTP requests completed')
TESTING = Counter('scraper_requests_testing', 'latencia de testeo')