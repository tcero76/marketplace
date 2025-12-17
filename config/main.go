package logger

import (
	"net"
	"os"

	logrustash "github.com/bshuster-repo/logrus-logstash-hook"
	"github.com/sirupsen/logrus"
)

func NewLoggerLogstash(icon string) *LoggerLogstash {
	if os.Getenv("MONITOREO") == "true" {
		return &LoggerLogstash{log: initLogrus(icon)}
	}
	return &LoggerLogstash{log: initDev(icon)}
}

func initLogrus(icon string) *logrus.Entry {
	log := logrus.New()
	conn, err := net.Dial("tcp", "logstash:5000")
	if err != nil {
		log.Fatal(err)
	}
	log.SetLevel(logrus.InfoLevel)
	hook := logrustash.New(conn, logrustash.DefaultFormatter(logrus.Fields{"type": "bff"}))
	log.AddHook(hook)
	log.SetFormatter(&logrus.JSONFormatter{})
	log.AddHook(&PrefixHook{Prefix: icon})
	return logrus.NewEntry(log)
}

func initDev(icon string) *logrus.Entry {
	log := logrus.New()
	log.SetReportCaller(false)
	log.SetFormatter(&LogstashFormatter{EnableColors: true, icon: icon})
	log.SetLevel(logrus.InfoLevel)
	return logrus.NewEntry(log)
}
