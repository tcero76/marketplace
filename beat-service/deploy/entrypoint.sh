#!/bin/sh
set -eu

exec celery -A main beat --loglevel=debug \
     --schedule=/tmp/celery/celerybeat-schedule