module github.com/tcero76/marketplace/postgres/services

go 1.25.2

require (
	github.com/lestrrat-go/jwx v1.2.31
	github.com/tcero76/marketplace/bff-service v0.0.0
	github.com/tcero76/marketplace/config v0.0.0
	github.com/tcero76/marketplace/postgres/model v0.0.0
	github.com/tcero76/marketplace/rabbitmq/events v0.0.0
	gorm.io/datatypes v1.2.7
	gorm.io/gorm v1.31.0
)

replace github.com/tcero76/marketplace/rabbitmq/events => ../../rabbitmq/events

replace github.com/tcero76/marketplace/bff-service => ../../bff-service

replace github.com/tcero76/marketplace/config => ../../config

replace github.com/tcero76/marketplace/postgres/config => ../config

replace github.com/tcero76/marketplace/postgres/model => ../model

replace github.com/tcero76/marketplace/clickhouse/model => ../../clickhouse/model

require (
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0 // indirect
	github.com/decred/dcrd/dcrec/secp256k1/v4 v4.4.0 // indirect
	github.com/go-sql-driver/mysql v1.8.1 // indirect
	github.com/goccy/go-json v0.10.3 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	github.com/lestrrat-go/backoff/v2 v2.0.8 // indirect
	github.com/lestrrat-go/blackmagic v1.0.3 // indirect
	github.com/lestrrat-go/httpcc v1.0.1 // indirect
	github.com/lestrrat-go/iter v1.0.2 // indirect
	github.com/lestrrat-go/option v1.0.1 // indirect
	github.com/lib/pq v1.10.9 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/sirupsen/logrus v1.9.3 // indirect
	golang.org/x/crypto v0.42.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	gorm.io/driver/mysql v1.5.6 // indirect
)
