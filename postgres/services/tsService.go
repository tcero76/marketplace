package services

import (
	"strconv"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/model"
	searchspecifications "github.com/tcero76/marketplace/postgres/services/SearchSpecifications"
	"gorm.io/gorm"
)

type TsService struct {
	log     *logger.LoggerLogstash
	dbRead  *gorm.DB
	dbWrite *gorm.DB
}

func NewTsService(log *logger.LoggerLogstash, dbRead *gorm.DB, dbWrite *gorm.DB) *TsService {
	return &TsService{log, dbRead, dbWrite}
}

func (h *TsService) GetTs(query string) (*dto.Ts, error) {
	h.log.Info("Entrando a GetModelByModelo")
	var ts model.TS
	err := h.dbRead.Where("id = ?", query).First(&ts).Error
	if err != nil {
		h.log.Error("Error al obtener Ts: ", query)
		return nil, err
	}
	return dto.ToTsDTO(&ts), nil
}

func (h *TsService) GetTses() ([]dto.Ts, error) {
	h.log.Info("Entrando a GetTses")
	var tses []dto.Ts
	err := h.dbRead.
		Model(&model.TS{}).
		Select("id, nombre").
		Scan(&tses).Error
	if err != nil {
		h.log.Error("Error al obtener tses: ", err)
		return nil, err
	}
	return tses, nil
}

func (h *TsService) GetSearchTs(searchRequest payload.SearchRequest) []dto.IdxDTO {
	h.log.Info("Entrando a search Tses")
	h.log.Info("GetSearch: searchRequest es: ", searchRequest)
	var servicioIDs []int
	if searchRequest.Hashtag != "" {
		if id, err := strconv.Atoi(searchRequest.Hashtag); err == nil {
			servicioIDs = []int{id}
		} else {
			h.log.Warn("Hashtag inválido (no es número): %s", searchRequest.Hashtag)
		}
	}
	h.log.Debug("GetSearch: servicioIDs es: ", servicioIDs)
	specs := []searchspecifications.Specification{
		searchspecifications.MentionSpecTs{Mention: searchRequest.Mention, Log: h.log},
		searchspecifications.TextSpecTs{Words: searchRequest.Text, Log: h.log},
		searchspecifications.ServicioSpecTs{ServicioIDs: servicioIDs, Log: h.log},
		searchspecifications.SelectSpecTs{Words: searchRequest.Text, Log: h.log},
	}
	var tses []model.TS
	err := searchspecifications.ApplySpecifications(h.dbRead.Model(&model.TS{}), specs...).Find(&tses)
	if err.Error != nil {
		h.log.Error("Error al obtener los tses en GetSearch: ", err.Error)
		return []dto.IdxDTO{}
	}
	return dto.FromTsesToIdxDTOs(tses)
}
