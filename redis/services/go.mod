module github.com/tcero76/marketplace/redis/services

go 1.25.2

require (
	github.com/fatih/structs v1.1.0
	github.com/go-redis/redis/v8 v8.11.5
	github.com/joho/godotenv v1.5.1
	github.com/sirupsen/logrus v1.9.3
	github.com/tcero76/marketplace/bff-service v0.0.0
	github.com/tcero76/marketplace/config v0.0.0
	github.com/tcero76/marketplace/redis/config v0.0.0
	github.com/tcero76/marketplace/redis/model v0.0.0
)

require (
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/go-sql-driver/mysql v1.8.1 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	github.com/lib/pq v1.10.9 // indirect
	github.com/tcero76/marketplace/clickhouse/model v0.0.0 // indirect
	github.com/tcero76/marketplace/postgres/model v0.0.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	gorm.io/datatypes v1.2.7 // indirect
	gorm.io/driver/mysql v1.5.6 // indirect
	gorm.io/gorm v1.31.0 // indirect
)

replace github.com/tcero76/marketplace/bff-service => ../../bff-service

replace github.com/tcero76/marketplace/redis/config => ../config

replace github.com/tcero76/marketplace/redis/model => ../model

replace github.com/tcero76/marketplace/config => ../../config

replace github.com/tcero76/marketplace/clickhouse/config => ../../clickhouse/config

replace github.com/tcero76/marketplace/clickhouse/model => ../../clickhouse/model

replace github.com/tcero76/marketplace/postgres/model => ../../postgres/model
