#!/bin/sh
set -eu

USER root
RUN mkdir -p /tmp/celery && chown -R app:app /tmp/celery
USER app

chmod 700 /tmp/celery

exec celery -A main beat --loglevel=debug \
     --schedule=/tmp/celery/celerybeat-schedule