package searchspecifications

import (
	"strings"

	"github.com/lib/pq"
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
	clean := cleanWords(s.Words)
	if len(clean) > 0 {
		text := strings.Join(clean, " ")
		return db.Where("descripcion_tsv @@ plainto_tsquery('spanish', ?)", text)
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

type ServicioSpecTs struct {
	ServicioIDs []int
	Log         *logger.LoggerLogstash
}

func (s ServicioSpecTs) Apply(db *gorm.DB) *gorm.DB {
	if len(s.ServicioIDs) == 0 {
		return db
	}
	query := `
	EXISTS (
		SELECT 1
		FROM marketplace.ts_servicios tss
		WHERE tss.ts_id = marketplace.ts.id
		  AND tss.servicio_id = ANY(?)
	`
	args := []interface{}{pq.Array(s.ServicioIDs)}
	query += ")"
	return db.Where(query, args...)
}

type SelectSpecTs struct {
	Words []string
	Log   *logger.LoggerLogstash
}

func (s SelectSpecTs) Apply(db *gorm.DB) *gorm.DB {
	s.Log.Info("SelectSpecTs Words son: ", s.Words)
	return db.Select("id")
}

type CiudadSpecTs struct {
	Ciudades []string
	Log      *logger.LoggerLogstash
}

func (s CiudadSpecTs) Apply(db *gorm.DB) *gorm.DB {
	if len(s.Ciudades) == 0 {
		return db
	}

	s.Log.Info("Filtrando por ciudades: ", s.Ciudades)

	return db.Where("ciudad IN ?", s.Ciudades)
}
