module github.com/tcero76/marketplace/bff

go 1.25.1

require (
	github.com/MicahParks/keyfunc v1.9.0
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0
	github.com/go-redis/redis/v8 v8.11.5
	github.com/golang-jwt/jwt/v4 v4.5.2
	github.com/google/uuid v1.6.0
	github.com/gorilla/securecookie v1.1.2
	github.com/joho/godotenv v1.5.1
	github.com/labstack/echo/v4 v4.13.3
	github.com/labstack/gommon v0.4.2
	github.com/lestrrat-go/jwx/v2 v2.1.6
	github.com/ory/hydra-client-go/v2 v2.2.1
	github.com/sirupsen/logrus v1.9.3
	github.com/stretchr/testify v1.11.1
	github.com/tcero76/marketplace/clickhouse/model v0.0.0
	github.com/tcero76/marketplace/clickhouse/services v0.0.0
	github.com/tcero76/marketplace/postgres/model v0.0.0
	github.com/tcero76/marketplace/postgres/services v0.0.0
	github.com/tcero76/marketplace/redis/services v0.0.0-00010101000000-000000000000
	golang.org/x/oauth2 v0.28.0
	gorm.io/gorm v1.31.0
)

replace github.com/tcero76/marketplace/rabbitmq/events => ../rabbitmq/events

replace github.com/tcero76/marketplace/clickhouse/config => ../clickhouse/config

replace github.com/tcero76/marketplace/clickhouse/services => ../clickhouse/services

replace github.com/tcero76/marketplace/clickhouse/model => ../clickhouse/model

replace github.com/tcero76/marketplace/postgres/config => ../postgres/config

replace github.com/tcero76/marketplace/postgres/services => ../postgres/services

replace github.com/tcero76/marketplace/postgres/model => ../postgres/model

replace github.com/tcero76/marketplace/redis/config => ../redis/config

replace github.com/tcero76/marketplace/redis/services => ../redis/services

require (
	cloud.google.com/go/compute/metadata v0.3.0 // indirect
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/ClickHouse/ch-go v0.68.0 // indirect
	github.com/ClickHouse/clickhouse-go/v2 v2.40.3 // indirect
	github.com/andybalholm/brotli v1.2.0 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/decred/dcrd/dcrec/secp256k1/v4 v4.4.0 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/go-faster/city v1.0.1 // indirect
	github.com/go-faster/errors v0.7.1 // indirect
	github.com/go-sql-driver/mysql v1.8.1 // indirect
	github.com/goccy/go-json v0.10.3 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/pgx/v5 v5.6.0 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	github.com/klauspost/compress v1.18.0 // indirect
	github.com/lestrrat-go/blackmagic v1.0.3 // indirect
	github.com/lestrrat-go/httpcc v1.0.1 // indirect
	github.com/lestrrat-go/httprc v1.0.6 // indirect
	github.com/lestrrat-go/iter v1.0.2 // indirect
	github.com/lestrrat-go/option v1.0.1 // indirect
	github.com/lib/pq v1.10.9 // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/paulmach/orb v0.11.1 // indirect
	github.com/pierrec/lz4/v4 v4.1.22 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/rogpeppe/go-internal v1.14.1 // indirect
	github.com/segmentio/asm v1.2.0 // indirect
	github.com/shopspring/decimal v1.4.0 // indirect
	github.com/tcero76/marketplace/clickhouse/config v0.0.0 // indirect
	github.com/tcero76/marketplace/postgres/config v0.0.0 // indirect
	github.com/tcero76/marketplace/rabbitmq/events v0.0.0 // indirect
	github.com/tcero76/marketplace/redis/config v0.0.0 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.2 // indirect
	go.opentelemetry.io/otel v1.38.0 // indirect
	go.opentelemetry.io/otel/trace v1.38.0 // indirect
	go.yaml.in/yaml/v3 v3.0.4 // indirect
	golang.org/x/crypto v0.42.0 // indirect
	golang.org/x/net v0.44.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
	gorm.io/datatypes v1.2.7 // indirect
	gorm.io/driver/mysql v1.5.6 // indirect
	gorm.io/driver/postgres v1.6.0 // indirect
)
