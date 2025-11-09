#!/bin/bash
set -e

clickhouse client -u $CLICKHOUSE_ADMIN_USER --password $CLICKHOUSE_ADMIN_PASSWORD -n <<-EOSQL
CREATE TABLE IF NOT EXISTS schema_migrations ( 
    version String,
    name String,
    applied_at DateTime DEFAULT now(),
    active UInt8 DEFAULT 1
) ENGINE = ReplacingMergeTree() ORDER BY version;
EOSQL

