package main

import (
	"encoding/json"
	"fmt"
	"net/smtp"
	"os"

	logConfig "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/rabbitmq/consumer"
	"github.com/tcero76/marketplace/rabbitmq/events"
)

func main() {
	log := logConfig.NewLoggerLogstash("📧 EMAIL")
	log.Info("Inicio broker-> email")
	msgs, conn, ch := consumer.GetMsgs(os.Getenv("EVT_USER_REGISTERED_EMAIL_QUEUE"))
	defer conn.Close()
	defer ch.Close()
	log.Debug("Esperando mensajes...")
	forever := make(chan bool)
	go func() {
		for d := range msgs {
			log.Info(d.Body)
			var event events.EmailEvent
			if err := json.Unmarshal(d.Body, &event); err != nil {
				log.Error("Error al parsear mensaje: %v", err)
				continue
			}
			log.Info("Recibido evento: %+v", event)
			if err := sendEmail(event); err != nil {
				log.Info("Error enviando correo: %v", err)
			} else {
				log.Info("Correo enviado correctamente a:", event.To)
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
