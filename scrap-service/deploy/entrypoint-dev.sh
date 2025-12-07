#!/bin/bash

echo "🔁 Running Celery worker in auto-reload mode..."

watchfiles \
  --filter=python \
  --target-type=command \
  "celery -A main worker --loglevel=debug"
