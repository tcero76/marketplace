package services

import (
	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/model"
	searchspecifications "github.com/tcero76/marketplace/postgres/services/SearchSpecifications"

	"gorm.io/gorm"
)

type ModeloService struct {
	log     *logger.LoggerLogstash
	dbWrite *gorm.DB
	dbRead  *gorm.DB
}

func NewModeloService(log *logger.LoggerLogstash, dbWrite *gorm.DB, dbRead *gorm.DB) *ModeloService {
	return &ModeloService{
		dbWrite: dbWrite,
		dbRead:  dbRead,
		log:     log}
}

func (s *ModeloService) GetModelByModelo(query string) (*dto.Modelo, error) {
	s.log.Info("Entrando a GetModelByModelo")
	modelo := &model.Modelo{}
	result := s.dbRead.
		Model(&model.Modelo{}).
		Where("modelo = ?", query).
		Where("modelo = ?", query).First(modelo)
	if result.Error != nil {
		s.log.Error("Error al obtener el modelo: ", result.Error)
		return nil, result.Error
	}
	return dto.ToModeloDTO(modelo), nil
}

func (s *ModeloService) GetModelos() []dto.Modelo {
	s.log.Info("Entrando a GetModelos...")
	var modelos []model.Modelo
	err := s.dbRead.Select("modelo").Find(&modelos)
	if err.Error != nil {
		s.log.Error("Error al obtener los modelos: ", err.Error)
		return []dto.Modelo{}
	}
	return dto.ToModelosDTO(modelos)
}

func (s *ModeloService) GetSearch(searchRequest payload.SearchRequest) []dto.SearchDTO {
	s.log.Info("GetSearch: Iniciando...")
	s.log.Info("GetSearch: searchRequest es: ", searchRequest)
	specs := []searchspecifications.Specification{
		searchspecifications.MentionSpec{Mention: searchRequest.Mention, Log: s.log},
		searchspecifications.TextSpec{Words: searchRequest.Text, Log: s.log},
		searchspecifications.SelectSpec{Words: searchRequest.Text, Log: s.log},
	}
	var modeloSearchDTOs []dto.SearchDTO
	err := searchspecifications.ApplySpecifications(s.dbRead.Model(&model.Modelo{}), specs...).
		Find(&modeloSearchDTOs)
	if err.Error != nil {
		s.log.Error("Error al obtener los modelos en GetSearch: ", err.Error)
		return []dto.SearchDTO{}
	}
	return modeloSearchDTOs
}
