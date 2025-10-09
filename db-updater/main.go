package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/rabbitmq/amqp091-go"
)

func main() {
	conn, err := amqp091.Dial(os.Getenv("BROKER"))
	if err != nil {
		log.Fatalf("Error conectando a RabbitMQ: %s", err)
	}
	defer conn.Close()

	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Error abriendo canal: %s", err)
	}
	defer ch.Close()

	msgs, err := ch.Consume(
		os.Getenv("RABBITMQ_CHAT_DB_UPDATER_QUEUE"),
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

	ctx := context.Background()

	dbConn, err := pgx.Connect(ctx, os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Fatalf("No se pudo conectar a la base de datos: %v", err)
	}
	defer dbConn.Close(ctx)

	log.Println("Esperando mensajes.")

	forever := make(chan bool)
	type ChatMessage struct {
		Body        string `json:"body"`
		UserID      string `json:"userId"`
		CurrentUser string `json:"current_user"`
	}
	go func() {
		for d := range msgs {
			var msg ChatMessage
			log.Printf("Mensaje recibido: %s", d.Body)
			err := json.Unmarshal(d.Body, &msg)
			if err != nil {
				log.Printf("Error deserializando mensaje: %v", err)
				continue
			}
			_, err = dbConn.Exec(ctx,
				`INSERT INTO chat.chats (user_origin, user_destination, is_public, message)
				VALUES ($1, $2, $3, $4)`,
				msg.CurrentUser,
				msg.UserID,
				true,
				msg.Body)
			if err != nil {
				log.Fatalf("Error insertando datos: %v", err)
			}

			fmt.Println("Dato insertado correctamente")
		}
	}()

	<-forever
}
