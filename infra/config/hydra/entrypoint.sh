#!/bin/sh
set -eu  # ‘-e’ para salir en error, ‘-u’ para variables no definidas

load_secret() {
  local var_name="$1"
  local secret_file="${var_name}_FILE"

  if [ -f "$secret_file" ]; then
    export "$var_name"="$(cat "$secret_file" | tr -d '\r\n')"
    echo "Loaded secret for $var_name"
  else
    echo "Warning: secret file $secret_file not found. Skipping."
  fi
}

load_secret POSTGRES_PASSWORD
export DNS="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable&options=-c%20search_path%3Dmarketplace"

exec "$@"
