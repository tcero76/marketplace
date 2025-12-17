package logger

import (
	log "github.com/sirupsen/logrus"
)

type PrefixHook struct {
	Prefix string
}

func (h *PrefixHook) Levels() []log.Level {
	return log.AllLevels
}

func (h *PrefixHook) Fire(entry *log.Entry) error {
	entry.Message = h.Prefix + " " + entry.Message
	return nil
}
