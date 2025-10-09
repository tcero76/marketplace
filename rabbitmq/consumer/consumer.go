package consumer

import (
	"fmt"
	"log"
	"os"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
)

func GetMsgs(queue string) (<-chan amqp.Delivery, *amqp.Connection, *amqp.Channel) {
	conn, err := ConnectRabbit(100)
	if err != nil {
		log.Fatalf("Error conectando a RabbitMQ: %v", err)
	}
	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Error abriendo canal: %v", err)
	}
	msgs, err := ch.Consume(
		queue,
		"",
		true,  // auto-ack
		false, // exclusiva
		false, // no-local
		false, // no-wait
		nil,
	)
	if err != nil {
		log.Fatalf("Error consumiendo mensajes: %v", err)
	}
	return msgs, conn, ch
}
func ConnectRabbit(retries int) (*amqp.Connection, error) {
	var conn *amqp.Connection
	var err error
	broker := os.Getenv("BROKER")
	for i := 0; i < retries; i++ {
		conn, err = amqp.Dial(broker)
		if err == nil {
			return conn, nil
		}
		log.Printf("Error conectando a RabbitMQ, reintentando en 3s... (%d/%d)", i+1, retries)
		time.Sleep(3 * time.Second)
	}
	return nil, fmt.Errorf("no se pudo conectar a RabbitMQ: %v", err)
}
