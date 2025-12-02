#!/bin/sh
set -eu

mkdir -p /tmp/celery
chmod 700 /tmp/celery

exec celery -A main beat --loglevel=debug \
     --schedule=/tmp/celery/celerybeat-schedule