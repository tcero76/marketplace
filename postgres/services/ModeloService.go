package services

import (
	"strings"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/postgres/config"
	"github.com/tcero76/marketplace/postgres/model"

	log "github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type ModeloService struct {
	DB *gorm.DB
}

func NewModeloService() services.IModeloService {
	db := config.GetPostgres()
	return &ModeloService{DB: db}
}

func (s *ModeloService) GetModelByModelo(query string) (*dto.Modelo, error) {
	log.Info("Entrando a GetModelByModelo")
	modelo := &model.Modelo{}
	result := s.DB.
		Model(&model.Modelo{}).
		Where("modelo = ?", query).
		Where("modelo = ?", query).First(modelo)
	if result.Error != nil {
		log.Error("Error al obtener el modelo: ", result.Error)
		return nil, result.Error
	}
	return dto.ToModeloDTO(modelo), nil
}

func (s *ModeloService) GetSearch(text []string) (*[]dto.Modelo, error) {
	log.Info("Entrando a GetSearch")
	var modelos []dto.Modelo
	tsquery := strings.Join(text, " | ")
	query := `
	SELECT id, descripcion, descripcion_tsv, 
		ts_rank(descripcion_tsv, to_tsquery('spanish', ?)) AS rank
	FROM marketplace.posts 
	WHERE descripcion_tsv @@ to_tsquery('spanish', ?)
	ORDER BY rank DESC
	`
	result := s.DB.Raw(query, tsquery, tsquery).Scan(&modelos)
	if result.Error != nil {
		log.Error("Error al obtener los modelos: ", result.Error)
		return nil, result.Error
	}
	return &modelos, nil
}

func (s *ModeloService) GetModelos() []dto.Modelo {
	var modelos []model.Modelo
	err := s.DB.Select("modelo").Find(&modelos)
	if err.Error != nil {
		log.Error("Error al obtener los modelos: ", err.Error)
		return []dto.Modelo{}
	}
	return dto.ToModelosDTO(modelos)
}
