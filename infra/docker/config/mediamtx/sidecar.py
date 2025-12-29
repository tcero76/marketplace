import http.server, socketserver, requests, threading

MEDIAMTX_URL = "http://mediamtx:9998/metrics"
PORT = 9100
USERNAME = "admin"
PASSWORD = "supersecret"

metrics_cache = ""

def update_metrics():
    global metrics_cache
    import time
    while True:
        try:
            r = requests.get(MEDIAMTX_URL, auth=(USERNAME, PASSWORD), timeout=2)
            metrics_cache = r.text
        except Exception:
            metrics_cache = ""
        time.sleep(5)

threading.Thread(target=update_metrics, daemon=True).start()

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(metrics_cache.encode())

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving metrics on port {PORT}")
    httpd.serve_forever()
