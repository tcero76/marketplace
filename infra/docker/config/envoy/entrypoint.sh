#!/bin/sh
set -e

echo "Generating envoy.yaml config file..."
cat /tmpl/envoy.yaml | envsubst \$ENVOY_PORT,\$ENVOY_HOST > /etc/envoy/envoy.yaml

echo "Starting Envoy..."
exec envoy -c /etc/envoy/envoy.yaml