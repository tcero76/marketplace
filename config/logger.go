package logger

import (
	"context"
	"runtime"

	"github.com/sirupsen/logrus"
)

type LoggerLogstash struct {
	log *logrus.Entry
}

func (l *LoggerLogstash) Info(args ...interface{}) {
	reportCaller(l.log).Info(args...)
}

func (l *LoggerLogstash) Infof(format string, args ...interface{}) {
	reportCaller(l.log).Infof(format, args...)
}

func (l *LoggerLogstash) Error(args ...interface{}) {
	reportCaller(l.log).Error(args...)
}

func (l *LoggerLogstash) Warn(args ...interface{}) {
	reportCaller(l.log).Warn(args...)
}

func (l *LoggerLogstash) Debug(args ...interface{}) {
	reportCaller(l.log).Debug(args...)
}

func (l *LoggerLogstash) Debugf(format string, args ...interface{}) {
	reportCaller(l.log).Debugf(format, args...)
}

func reportCaller(log *logrus.Entry) *logrus.Entry {
	pc, file, line, ok := runtime.Caller(2)
	if ok {
		fn := runtime.FuncForPC(pc).Name()
		return log.WithFields(logrus.Fields{
			"file": file,
			"line": line,
			"func": fn,
		})
	}
	return log.WithFields(logrus.Fields{})
}

func (l *LoggerLogstash) WithFields(uuid string, method string, path string) *logrus.Entry {
	entry := l.log.WithFields(logrus.Fields{
		"request_id": uuid,
		"method":     method,
		"path":       path,
	})
	return reportCaller(entry)
}

func (l *LoggerLogstash) WithLogger(ctx context.Context, entry *logrus.Entry) context.Context {
	return context.WithValue(ctx, "log", entry)
}
func (l *LoggerLogstash) FromContext(ctx context.Context) *logrus.Entry {
	if log, ok := ctx.Value("log").(*logrus.Entry); ok {
		return log
	}
	return l.log.WithFields(logrus.Fields{})
}
