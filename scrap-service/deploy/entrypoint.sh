#!/bin/sh
set -eu  # ‘-e’ para salir en error, ‘-u’ para variables no definidas

POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
export POSTGRES_PASSWORD

export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"

exec "$@"
