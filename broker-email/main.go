package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/smtp"
	"os"

	"github.com/tcero76/marketplace/rabbitmq/consumer"
	"github.com/tcero76/marketplace/rabbitmq/events"
)

func main() {
	msgs, conn, ch := consumer.GetMsgs(os.Getenv("RABBITMQ_USER_DB_UPDATER_QUEUE"))
	defer conn.Close()
	defer ch.Close()
	log.Println("Esperando mensajes...")
	forever := make(chan bool)
	go func() {
		for d := range msgs {
			log.Println(d.Body)
			var event events.EmailEvent
			if err := json.Unmarshal(d.Body, &event); err != nil {
				log.Printf("Error al parsear mensaje: %v", err)
				continue
			}

			log.Printf("Recibido evento: %+v", event)
			if err := sendEmail(event); err != nil {
				log.Printf("Error enviando correo: %v", err)
			} else {
				log.Println("Correo enviado correctamente a:", event.To)
			}
		}
	}()
	<-forever
}

func sendEmail(e events.EmailEvent) error {
	smtpHost := os.Getenv("SMTP_HOST")
	smtpPort := os.Getenv("SMTP_PORT")
	smtpUser := os.Getenv("SMTP_USER")
	smtpPass := os.Getenv("SMTP_PASS")
	auth := smtp.PlainAuth("", smtpUser, smtpPass, smtpHost)
	msg := []byte(fmt.Sprintf(
		"To: %s\r\nSubject: %s\r\n\r\n%s\r\n",
		e.To, e.Subject, e.Body,
	))
	addr := fmt.Sprintf("%s:%s", smtpHost, smtpPort)
	return smtp.SendMail(addr, auth, smtpUser, []string{e.To}, msg)
}
