#!/usr/bin/env bash

# Sube las variables del archivo .env a los secrets del repositorio GitHub
# Requiere: gh CLI autenticado con permisos al repo
# Uso: ./upload_env_to_gh.sh .env

ENV_FILE="${1:-.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Archivo $ENV_FILE no encontrado."
  exit 1
fi

while IFS='=' read -r key value; do
  # Ignora líneas vacías y comentarios
  [[ -z "$key" || "$key" =~ ^# ]] && continue

  # Elimina posibles comillas
  value=$(echo "$value" | sed 's/^"//;s/"$//')
  value=$(echo "$value" | sed "s/^'//;s/'$//")

  echo "🔑 Subiendo $key..."
  gh secret set "$key" -b"$value"
done < "$ENV_FILE"

echo "✅ Todas las variables fueron subidas a los secrets del repositorio."
