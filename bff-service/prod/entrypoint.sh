#!/bin/sh
set -eu  # ‘-e’ para salir en error, ‘-u’ para variables no definidas

load_secret() {
  local var_name="$1"
  local secret_file="/run/secrets/$var_name"

  if [ -f "$secret_file" ]; then
    export "$var_name"="$(cat "$secret_file" | tr -d '\r\n')"
    echo "Loaded secret for $var_name"
  else
    echo "Warning: secret file $secret_file not found. Skipping."
  fi
}

load_secret CLIENT_SECRET
load_secret GOOGLE_OAUTH2_CLIENT_SECRET
load_secret POSTGRES_PASSWORD

exec "$@"
