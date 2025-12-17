package services

import (
	"strings"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/config"
	"github.com/tcero76/marketplace/postgres/model"
	"gorm.io/gorm"
)

type SearchService struct {
	DB  *gorm.DB
	log *logger.LoggerLogstash
}

func NewSearchService(log *logger.LoggerLogstash) *SearchService {
	db := config.GetPostgres(log)
	return &SearchService{DB: db, log: log}
}

type Specification interface {
	Apply(db *gorm.DB) *gorm.DB
}

type TextSpec struct {
	Words []string
	log   *logger.LoggerLogstash
}

func (s TextSpec) Apply(db *gorm.DB) *gorm.DB {
	s.log.Info("Words son: ", s.Words)
	if len(s.Words) > 0 {
		tsQuery := strings.Join(s.Words, " | ")
		return db.Where("to_tsvector('spanish', descripcion) @@ plainto_tsquery('spanish', ?)", tsQuery)
	}
	return db
}

type MentionSpec struct {
	Mention string
	log     *logger.LoggerLogstash
}

func (s MentionSpec) Apply(db *gorm.DB) *gorm.DB {
	s.log.Info("Mention es: ", s.Mention)
	if s.Mention != "" {
		mention := strings.TrimPrefix(s.Mention, "@")
		return db.Where("modelo ILIKE ?", mention+"%")
	}
	return db
}

type SelectSpec struct {
	Words []string
	log   *logger.LoggerLogstash
}

func (s SelectSpec) Apply(db *gorm.DB) *gorm.DB {
	s.log.Info("SelectSpec Words son: ", s.Words)
	if len(s.Words) > 0 {
		tsQuery := strings.Join(s.Words, " | ")
		return db.
			Select("id, descripcion, modelo, ts_rank(to_tsvector('spanish', descripcion), to_tsquery(?)) AS rank", tsQuery)
	}
	return db.Select("id, descripcion, modelo")
}

func ApplySpecifications(db *gorm.DB, specs ...Specification) *gorm.DB {
	for _, spec := range specs {
		db = spec.Apply(db)
	}
	return db
}

func (s *SearchService) GetSearch(searchRequest payload.SearchRequest) []dto.SearchDTO {
	s.log.Info("GetSearch: Iniciando...")
	s.log.Info("GetSearch: searchRequest es: ", searchRequest)
	specs := []Specification{
		MentionSpec{Mention: searchRequest.Mention, log: s.log},
		TextSpec{Words: searchRequest.Text, log: s.log},
		SelectSpec{Words: searchRequest.Text, log: s.log},
	}
	var modeloSearchDTOs []dto.SearchDTO
	err := ApplySpecifications(s.DB.Model(&model.Modelo{}), specs...).
		Find(&modeloSearchDTOs)
	if err.Error != nil {
		s.log.Error("Error al obtener los modelos en GetSearch: ", err.Error)
		return []dto.SearchDTO{}
	}
	return modeloSearchDTOs
}
