#!/bin/sh

set -e

POSTGRES_PASSWORD=$(cat /run/secrets/patroni_admin_password)
echo "⏳ Esperando que la DB esté lista..."
until pg_isready -h $POSTGRES_HOST -U "$POSTGRES_USER" -d "$POSTGRES_DB" -p $POSTGRES_PORT; do
  sleep 3
done
echo "✅ DB lista. Ejecutando migraciones..."
flyway -url="jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}" \
  -user="$POSTGRES_USER" \
  -password="$POSTGRES_PASSWORD" \
  -schemas=marketplace,scrap \
  -locations=filesystem:/flyway/sql \
  -connectRetries=10 \
  -placeholders.URL_EXTERNAL=${URL_EXTERNAL} \
  migrate
