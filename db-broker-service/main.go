package main

import (
	"log"
	"os"
	"time"

	"postgres/model"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/streadway/amqp"
)

func main() {

	dsn := os.Getenv("DATABASE_URL")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("❌ Error conectando a Postgres: %v", err)
	}

	// Conexión a RabbitMQ
	conn, err := amqp.Dial(os.Getenv("BROKER"))
	if err != nil {
		log.Fatalf("❌ Error conectando a RabbitMQ: %v", err)
	}
	defer conn.Close()

	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("❌ Error creando canal RabbitMQ: %v", err)
	}
	defer ch.Close()
	// Bucle de polling
	ticker := time.NewTicker(5 * time.Second) // cada 5s
	defer ticker.Stop()
	for range ticker.C {
		var events []model.Outbox
		// Traer eventos no procesados
		if err := db.Where("processed = ?", false).Order("created_at ASC").Find(&events).Error; err != nil {
			log.Printf("⚠️ Error leyendo outbox: %v", err)
			continue
		}
		for _, evt := range events {
			// Publicar en RabbitMQ
			err = ch.Publish(
				os.Getenv("RABBITMQ_USER_DB_UPDATER_EXCHANGE"), // exchange
				os.Getenv("RABBITMQ_USER_DB_UPDATER_QUEUE"),    // routing key
				false,
				false,
				amqp.Publishing{
					ContentType: "application/json",
					Body:        []byte(evt.Payload),
				},
			)
			if err != nil {
				log.Printf("⚠️ Error publicando evento %d: %v", evt.ID, err)
				continue
			}
			// Marcar como procesado
			if err := db.Model(&evt).Update("processed", true).Error; err != nil {
				log.Printf("⚠️ Error marcando procesado evento %d: %v", evt.ID, err)
			} else {
				log.Printf("✅ Evento %d publicado y marcado como procesado", evt.ID)
			}
		}
	}
}
