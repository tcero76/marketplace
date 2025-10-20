#!/bin/bash
# set -e

# Función para crear una cola si no existe
create_queue_if_missing() {
  local queue=$1
  local vhost=$2
  local args=$3

  exists=$(rabbitmqadmin --vhost="$vhost" list queues name | grep -w "$queue" || true)

  if [ -z "$exists" ]; then
    echo "Creando cola $queue en vhost $vhost"
    rabbitmqadmin --vhost="$vhost" declare queue \
      --host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD \
      name="$queue" durable=true auto_delete=false arguments="$args"
  else
    echo "Cola $queue ya existe en vhost $vhost"
  fi
}

# Función para crear un exchange si no existe
create_exchange_if_missing() {
  local exchange=$1
  local type=$2
  local vhost=$3

  exists=$(rabbitmqadmin --vhost="$vhost" list exchanges name | grep -w "$exchange" || true)

  if [ -z "$exists" ]; then
    echo "Creando exchange $exchange (type: $type) en vhost $vhost"
    rabbitmqadmin --vhost="$vhost" declare exchange \
      --host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD \
      name="$exchange" type="$type" durable=true auto_delete=false internal=false
  else
    echo "Exchange $exchange ya existe en vhost $vhost"
  fi
}

# Función para crear un binding si no existe
create_binding_if_missing() {
  local source=$1
  local destination=$2
  local destination_type=$3
  local routing_key=$4
  local vhost=$5

  exists=$(rabbitmqadmin --vhost="$vhost" list bindings \
    | grep -w "$source" | grep -w "$destination" | grep -w "$routing_key" || true)

  if [ -z "$exists" ]; then
    echo "Creando binding de $source → $destination con key '$routing_key'"
    rabbitmqadmin --vhost="$vhost" declare binding \
      --host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD \
      source="$source" destination_type="$destination_type" \
      destination="$destination" routing_key="$routing_key"
  else
    echo "Binding $source → $destination con key '$routing_key' ya existe"
  fi
}

# Crear colas
create_queue_if_missing "chat_event_queue" "/" '{"x-queue-type":"classic"}'
create_queue_if_missing "solana_event_queue" "/" '{"x-queue-type":"classic"}'
create_queue_if_missing "recomender_queue" "/" '{"x-queue-type":"classic"}'
create_queue_if_missing "chat_cache_updater_queue" "/" '{"x-queue-type":"classic"}'
create_queue_if_missing "chat_db_updater_queue" "/" '{"x-queue-type":"classic"}'
create_queue_if_missing "user_db_updater_queue" "/" '{"x-queue-type":"classic"}'

# Crear exchanges
create_exchange_if_missing "recomender_queue" "direct" "/"
create_exchange_if_missing "logs" "fanout" "/"
create_exchange_if_missing "user_db_updater_exchange" "fanout" "/"

# Crear bindings
create_binding_if_missing "logs" "chat_event_queue" "queue" "" "/"
create_binding_if_missing "logs" "chat_cache_updater_queue" "queue" "" "/"
create_binding_if_missing "logs" "chat_db_updater_queue" "queue" "" "/"
create_binding_if_missing "recomender_queue" "recomender_queue" "queue" "recomender_queue" "/"
create_binding_if_missing "user_db_updater_exchange" "user_db_updater_queue" "queue" "user_db_updater_queue" "/"


