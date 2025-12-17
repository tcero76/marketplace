package logger

import (
	"fmt"
	"time"

	"github.com/sirupsen/logrus"
)

type LogstashFormatter struct {
	EnableColors bool
	icon         string
}

func (f *LogstashFormatter) Format(entry *logrus.Entry) ([]byte, error) {
	timestamp := entry.Time.Format(time.RFC3339)
	color := ""
	reset := ""
	file := entry.Data["file"]
	line := entry.Data["line"]
	fn := entry.Data["func"]
	method := entry.Data["method"]
	requestId := entry.Data["request_id"]
	path := entry.Data["path"]

	msg := entry.Message

	if f.EnableColors {
		color = levelColor(entry.Level)
		reset = colorReset
	}

	if method == nil {
		return []byte(fmt.Sprintf(
			"%s%s %s %-5s%s %s:%v %v: %s\n",
			color,
			f.icon,
			timestamp,
			entry.Level.String(),
			reset,
			file,
			line,
			fn,
			msg,
		)), nil
	} else {
		return []byte(fmt.Sprintf(
			"%s%s %s %-5s%s %s %s %s %s:%v %v: %s\n",
			color,
			f.icon,
			timestamp,
			entry.Level.String(),
			reset,
			method,
			requestId,
			path,
			file,
			line,
			fn,
			msg,
		)), nil
	}

}
func levelColor(level logrus.Level) string {
	switch level {
	case logrus.DebugLevel:
		return colorGray
	case logrus.InfoLevel:
		return colorCyan
	case logrus.WarnLevel:
		return colorYellow
	case logrus.ErrorLevel, logrus.FatalLevel, logrus.PanicLevel:
		return colorRed
	default:
		return colorReset
	}
}

const (
	colorReset  = "\033[0m"
	colorRed    = "\033[31m"
	colorGreen  = "\033[32m"
	colorYellow = "\033[33m"
	colorBlue   = "\033[34m"
	colorCyan   = "\033[36m"
	colorGray   = "\033[90m"
)
