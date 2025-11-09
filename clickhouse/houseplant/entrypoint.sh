#!/bin/sh

set -e

if [ -n "$CLICKHOUSE_PASSWORD_FILE" ] && [ -f "$CLICKHOUSE_PASSWORD_FILE" ]; then
  export CLICKHOUSE_PASSWORD="$(cat "$CLICKHOUSE_PASSWORD_FILE")"
fi

echo "⏳ Esperando que ClickHouse esté disponible..."

until curl -s "http://$CLICKHOUSE_HOST:8123/ping" | grep -q "Ok."; do
  echo "⏳ Esperando a que ClickHouse esté disponible en $CLICKHOUSE_HOST..."
  sleep 2
done
echo "✅ ClickHouse está listo. Ejecutando migraciones..."

sleep 10

houseplant migrate:up