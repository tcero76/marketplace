module github.com/tcero76/marketplace/postgres/services

go 1.25.1

require (
	github.com/sirupsen/logrus v1.9.3
	github.com/tcero76/marketplace/bff-service v0.0.0
	github.com/tcero76/marketplace/postgres/config v0.0.0
	github.com/tcero76/marketplace/postgres/model v0.0.0
	github.com/tcero76/marketplace/rabbitmq/events v0.0.0
	gorm.io/datatypes v1.2.7
	gorm.io/gorm v1.31.0
)

replace github.com/tcero76/marketplace/rabbitmq/events => ../../rabbitmq/events

replace github.com/tcero76/marketplace/bff-service => ../../bff-service

replace github.com/tcero76/marketplace/postgres/config => ../config

replace github.com/tcero76/marketplace/postgres/model => ../model

replace github.com/tcero76/marketplace/clickhouse/model => ../../clickhouse/model

require (
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/go-sql-driver/mysql v1.8.1 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/pgx/v5 v5.6.0 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	github.com/labstack/gommon v0.4.2 // indirect
	github.com/lib/pq v1.10.9 // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/tcero76/marketplace/clickhouse/model v0.0.0 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.2 // indirect
	golang.org/x/crypto v0.42.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	gorm.io/driver/mysql v1.5.6 // indirect
	gorm.io/driver/postgres v1.6.0 // indirect
)
