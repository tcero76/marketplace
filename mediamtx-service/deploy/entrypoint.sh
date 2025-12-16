#!/bin/sh
set -x

POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
export POSTGRES_PASSWORD
export DNS="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable&options=-c%20search_path%3Dhydra"

exec "$@"
