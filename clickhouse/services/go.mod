module github.com/tcero76/marketplace/clickhouse/services

go 1.25.2

require (
	github.com/ClickHouse/clickhouse-go/v2 v2.40.3
	github.com/sirupsen/logrus v1.9.3
	github.com/tcero76/marketplace/bff-service v0.0.0
	github.com/tcero76/marketplace/clickhouse/config v0.0.0
	github.com/tcero76/marketplace/clickhouse/model v0.0.0
	github.com/tcero76/marketplace/config v0.0.0
)

require (
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/ClickHouse/ch-go v0.68.0 // indirect
	github.com/andybalholm/brotli v1.2.0 // indirect
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0 // indirect
	github.com/go-faster/city v1.0.1 // indirect
	github.com/go-faster/errors v0.7.1 // indirect
	github.com/go-sql-driver/mysql v1.8.1 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	github.com/klauspost/compress v1.18.0 // indirect
	github.com/labstack/gommon v0.4.2 // indirect
	github.com/lib/pq v1.10.9 // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/paulmach/orb v0.11.1 // indirect
	github.com/pierrec/lz4/v4 v4.1.22 // indirect
	github.com/segmentio/asm v1.2.0 // indirect
	github.com/shopspring/decimal v1.4.0 // indirect
	github.com/tcero76/marketplace/postgres/model v0.0.0 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.2 // indirect
	go.opentelemetry.io/otel v1.38.0 // indirect
	go.opentelemetry.io/otel/trace v1.38.0 // indirect
	go.yaml.in/yaml/v3 v3.0.4 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	gorm.io/datatypes v1.2.7 // indirect
	gorm.io/driver/mysql v1.5.6 // indirect
	gorm.io/gorm v1.31.0 // indirect
)

replace github.com/tcero76/marketplace/bff-service => ../../bff-service

replace github.com/tcero76/marketplace/config => ../../config

replace github.com/tcero76/marketplace/clickhouse/model => ../model

replace github.com/tcero76/marketplace/clickhouse/config => ../config

replace github.com/tcero76/marketplace/postgres/model => ../../postgres/model
