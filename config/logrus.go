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
	log.SetLevel(log.InfoLevel)
	hook := logrustash.New(conn, logrustash.DefaultFormatter(log.Fields{"type": "bff"}))
	log.AddHook(hook)
	log.SetFormatter(&log.JSONFormatter{})
}

func InitDev() {
	log.SetReportCaller(true)
	log.SetFormatter(&log.TextFormatter{
		ForceColors:               false,
		FullTimestamp:             false,
		DisableColors:             true,
		EnvironmentOverrideColors: false,
	})
	log.SetFormatter(&log.TextFormatter{})
	log.SetLevel(log.InfoLevel)
}
