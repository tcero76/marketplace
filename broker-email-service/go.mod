module github.com/tcero76/marketplace/broker-email

go 1.25.2

require (
	github.com/tcero76/marketplace/config v0.0.0
	github.com/tcero76/marketplace/rabbitmq/consumer v0.0.0
	github.com/tcero76/marketplace/rabbitmq/events v0.0.0
)

require (
	github.com/bshuster-repo/logrus-logstash-hook v1.1.0 // indirect
	github.com/rabbitmq/amqp091-go v1.10.0 // indirect
	github.com/sirupsen/logrus v1.9.3 // indirect
	golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect
)

replace github.com/tcero76/marketplace/rabbitmq/consumer => ../rabbitmq/consumer

replace github.com/tcero76/marketplace/rabbitmq/events => ../rabbitmq/events

replace github.com/tcero76/marketplace/config => ../config
