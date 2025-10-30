#!/bin/bash
set -e

echo "Cargando variables de entorno desde .env..."
if [ -f /root/.env ]; then
    # Forma robusta de exportar variables
    set -a
    . /root/.env
    set +a
else
    echo ".env no encontrado, continuando sin variables"
fi

echo "Desplegando stack..."
docker stack deploy \
  -c /root/docker/postgres.yml \
  -c /root/docker/hydra.yml \
  -c /root/docker/rabbitmq.yml \
  -c /root/docker/common.yml \
  mystack \
  --with-registry-auth

echo "Despliegue completado."
