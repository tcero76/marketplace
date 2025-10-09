package config

import (
	"os"

	log "github.com/sirupsen/logrus"

	"github.com/rabbitmq/amqp091-go"
)

func InitRabbitMQ() <-chan amqp091.Delivery {
	conn, err := amqp091.Dial(os.Getenv("BROKER"))
	if err != nil {
		log.Error("Error conectando a RabbitMQ: %s", err)
	}
	defer conn.Close()
	log.Info("Conexión a RabbitMQ establecida.")

	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Error abriendo canal: %s", err)
	}
	defer ch.Close()
	msgs, err := ch.Consume(
		os.Getenv("RABBITMQ_CHAT_CACHE_UPDATER_QUEUE"),
		"",
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		log.Fatalf("Error iniciando consumo: %s", err)
	}
	log.Info("Consumiendo mensajes de RabbitMQ en la cola: ", os.Getenv("RABBITMQ_CHAT_CACHE_UPDATER_QUEUE"))
	return msgs
}
