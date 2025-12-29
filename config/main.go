package logger

import (
	"net"
	"os"

	logrustash "github.com/bshuster-repo/logrus-logstash-hook"
	"github.com/sirupsen/logrus"
)

func NewLoggerLogstash(icon string) *LoggerLogstash {
	if os.Getenv("MONITOREO") == "true" {
		return &LoggerLogstash{log: setLogLevel(initLogrus(icon))}
	}
	return &LoggerLogstash{log: setLogLevel(initDev(icon))}
}

func initLogrus(icon string) *logrus.Entry {
	log := logrus.New()
	conn, err := net.Dial("tcp", "logstash:5000")
	if err != nil {
		log.Fatal(err)
	}
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

func setLogLevel(log *logrus.Entry) *logrus.Entry {
	level := os.Getenv("LOG_LEVEL")
	switch level {
	case "debug":
		log.Logger.SetLevel(logrus.DebugLevel)
	case "info":
		log.Logger.SetLevel(logrus.InfoLevel)
	case "warn":
		log.Logger.SetLevel(logrus.WarnLevel)
	case "error":
		log.Logger.SetLevel(logrus.ErrorLevel)
	default:
		log.Logger.SetLevel(logrus.InfoLevel)
	}
	return log
}
