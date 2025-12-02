#!/bin/sh
set -eu

USER root
mkdir -p /tmp/celery
chown app:app /tmp/celery
chmod 700 /tmp/celery
USER app

chmod 700 /tmp/celery

exec celery -A main beat --loglevel=debug \
     --schedule=/tmp/celery/celerybeat-schedule