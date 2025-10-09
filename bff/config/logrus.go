package config

import (
	"net"

	logrustash "github.com/bshuster-repo/logrus-logstash-hook"
	log "github.com/sirupsen/logrus"
)

func InitLogrus() {
	conn, err := net.Dial("tcp", "logstash:5000")
	if err != nil {
		log.Fatal(err)
	}

	hook := logrustash.New(conn, logrustash.DefaultFormatter(log.Fields{"type": "bff"}))
	log.AddHook(hook)
	log.SetFormatter(&log.JSONFormatter{})
}
