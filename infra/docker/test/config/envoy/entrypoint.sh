#!/bin/sh
set -e

echo "Generating envoy.yaml config file..."
cat /tmpl/envoy.yaml | envsubst \$ENVOY_PORT,\$ENVOY_HOST > /etc/envoy.yaml

echo "Starting Envoy..."
/usr/local/bin/envoy -c /etc/envoy.yaml