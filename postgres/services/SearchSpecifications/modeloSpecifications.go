package searchspecifications

import (
	"strings"

	logger "github.com/tcero76/marketplace/config"
	"gorm.io/gorm"
)

type TextSpec struct {
	Words []string
	Log   *logger.LoggerLogstash
}

func (s TextSpec) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("Words son: ", s.Words)
	if len(s.Words) > 0 {
		tsQuery := strings.Join(s.Words, " | ")
		return db.Where("to_tsvector('spanish', descripcion) @@ plainto_tsquery('spanish', ?)", tsQuery)
	}
	return db
}

type MentionSpec struct {
	Mention string
	Log     *logger.LoggerLogstash
}

func (s MentionSpec) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("Mention es: ", s.Mention)
	if s.Mention != "" {
		mention := strings.TrimPrefix(s.Mention, "@")
		return db.Where("modelo ILIKE ?", mention+"%")
	}
	return db
}

type SelectSpec struct {
	Words []string
	Log   *logger.LoggerLogstash
}

func (s SelectSpec) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("SelectSpec Words son: ", s.Words)
	if len(s.Words) > 0 {
		tsQuery := strings.Join(s.Words, " | ")
		return db.
			Select("id, descripcion, modelo, ts_rank(to_tsvector('spanish', descripcion), to_tsquery(?)) AS rank", tsQuery)
	}
	return db.Select("id, descripcion, modelo")
}
