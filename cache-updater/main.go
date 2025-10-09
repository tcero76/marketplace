package main

import (
	"cache-updater/config"
	"context"

	log "github.com/sirupsen/logrus"
)

func main() {
	config.InitLogrus()
	rdb := config.InitRedis()
	msgs := config.InitRabbitMQ()
	log.Info("Esperando mensajes.")
	forever := make(chan bool)
	ctx := context.Background()
	go func() {
		for d := range msgs {
			message := string(d.Body)
			log.Printf("Recibido: %s", message)

			err := rdb.LPush(ctx, "clave", message).Err()
			if err != nil {
				log.Printf("Error agregando a Redis: %v", err)
				continue
			}
			err = rdb.LTrim(ctx, "clave", 0, 9).Err()
			if err != nil {
				log.Printf("Error truncando lista en Redis: %v", err)
			}
		}
	}()

	<-forever
}
