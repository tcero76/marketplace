package services

import (
	"github.com/tcero76/marketplace/bff-service/dto"
	logConfig "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/model"
	"gorm.io/gorm"
)

type TopicsService struct {
	log    *logConfig.LoggerLogstash
	dbRead *gorm.DB
}

func NewTopicsService(log *logConfig.LoggerLogstash, dbRead *gorm.DB) *TopicsService {
	return &TopicsService{log: log, dbRead: dbRead}
}

func (s *TopicsService) GetTopics() ([]dto.Topic, error) {
	var servicios []model.Servicios
	err := s.dbRead.Find(&servicios).Error
	if err != nil {
		s.log.Error("Error al obtener los topics: ", err)
		return nil, err
	}
	return dto.ServiciosToTopics(servicios), nil
}
