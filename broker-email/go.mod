module github.com/tcero76/marketplace/broker-email

go 1.25.1

require (
	github.com/tcero76/marketplace/rabbitmq/consumer v0.0.0
	github.com/tcero76/marketplace/rabbitmq/events v0.0.0
)

require github.com/rabbitmq/amqp091-go v1.10.0 // indirect

replace github.com/tcero76/marketplace/rabbitmq/consumer => ../rabbitmq/consumer

replace github.com/tcero76/marketplace/rabbitmq/events => ../rabbitmq/events
