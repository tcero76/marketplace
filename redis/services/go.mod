module github.com/tcero76/marketplace/redis/services

go 1.25.2

require (
	github.com/fatih/structs v1.1.0
	github.com/go-redis/redis/v8 v8.11.5
	github.com/joho/godotenv v1.5.1
	github.com/labstack/gommon v0.4.2
	github.com/tcero76/marketplace/config v0.0.0
	github.com/tcero76/marketplace/redis/config v0.0.0
	github.com/tcero76/marketplace/redis/model v0.0.0
)

require (
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/sirupsen/logrus v1.9.3 // indirect
	github.com/stretchr/testify v1.11.1 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.2 // indirect
	golang.org/x/net v0.44.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
)

replace github.com/tcero76/marketplace/bff-service => ../../bff-service

replace github.com/tcero76/marketplace/redis/config => ../config

replace github.com/tcero76/marketplace/redis/model => ../model

replace github.com/tcero76/marketplace/config => ../../config

replace github.com/tcero76/marketplace/clickhouse/config => ../../clickhouse/config

replace github.com/tcero76/marketplace/clickhouse/model => ../../clickhouse/model

replace github.com/tcero76/marketplace/postgres/model => ../../postgres/model
