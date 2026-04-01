package searchspecifications

import (
	"strings"

	logger "github.com/tcero76/marketplace/config"
	"gorm.io/gorm"
)

type TextSpecTs struct {
	Words []string
	Log   *logger.LoggerLogstash
}

func cleanWords(words []string) []string {
	var result []string
	for _, w := range words {
		if w = strings.TrimSpace(w); w != "" {
			result = append(result, w)
		}
	}
	return result
}

func (s TextSpecTs) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("Words son: ", s.Words)
	cleanWords := cleanWords(s.Words)
	if len(cleanWords) > 0 {
		tsQuery := strings.Join(cleanWords, " | ")
		return db.Where("descripcion_tsv @@ plainto_tsquery('spanish', ?)", tsQuery)
	}
	return db
}

type MentionSpecTs struct {
	Mention string
	Log     *logger.LoggerLogstash
}

func (s MentionSpecTs) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("Mention es: ", s.Mention)
	if s.Mention != "" {
		mention := s.Mention[1:]
		return db.Where("nombre ILIKE ?", mention+"%")
	}
	return db
}

type SelectSpecTs struct {
	Words []string
	Log   *logger.LoggerLogstash
}

func (s SelectSpecTs) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("SelectSpecTs Words son: ", s.Words)
	return db.Select("id")
}
