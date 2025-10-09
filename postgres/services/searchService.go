package services

import (
	"strings"

	"github.com/labstack/gommon/log"
	"github.com/tcero76/marketplace/bff/dto"
	"github.com/tcero76/marketplace/bff/payload"
	"github.com/tcero76/marketplace/postgres/config"
	"github.com/tcero76/marketplace/postgres/model"
	"gorm.io/gorm"
)

type SearchService struct {
	DB *gorm.DB
}

func NewSearchService() *SearchService {
	db := config.GetPostgres()
	return &SearchService{DB: db}
}

type Specification interface {
	Apply(db *gorm.DB) *gorm.DB
}

type TextSpec struct {
	Words []string
}

func (s TextSpec) Apply(db *gorm.DB) *gorm.DB {
	log.Info("Words son: ", s.Words)
	if len(s.Words) > 0 {
		tsQuery := strings.Join(s.Words, " | ")
		return db.Where("to_tsvector('spanish', descripcion) @@ plainto_tsquery('spanish', ?)", tsQuery)
	}
	return db
}

type MentionSpec struct {
	Mention string
}

func (s MentionSpec) Apply(db *gorm.DB) *gorm.DB {
	log.Info("Mention es: ", s.Mention)
	if s.Mention != "" {
		mention := strings.TrimPrefix(s.Mention, "@")
		return db.Where("modelo ILIKE ?", mention+"%")
	}
	return db
}

type SelectSpec struct {
	Words []string
}

func (s SelectSpec) Apply(db *gorm.DB) *gorm.DB {
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
	log.Info("GetSearch: Iniciando...")
	log.Info("GetSearch: searchRequest es: ", searchRequest)
	specs := []Specification{
		MentionSpec{Mention: searchRequest.Mention},
		TextSpec{Words: searchRequest.Text},
		SelectSpec{Words: searchRequest.Text},
	}
	var modeloSearchDTOs []dto.SearchDTO
	ApplySpecifications(s.DB.Model(&model.Modelo{}), specs...).
		Find(&modeloSearchDTOs)
	return modeloSearchDTOs
}
