package dto

import (
	"github.com/google/uuid"
	"github.com/tcero76/marketplace/postgres/model"
)

type IdxDTO struct {
	IdItem uuid.UUID `json:"idItem"`
	Score  float32   `json:"score"`
}

func FromTsToIdxDTO(r model.TS) *IdxDTO {
	return &IdxDTO{
		IdItem: r.ID,
	}
}

func FromTsesToIdxDTOs(rs []model.TS) []IdxDTO {
	dtos := make([]IdxDTO, len(rs))
	for i, r := range rs {
		dtos[i] = *FromTsToIdxDTO(r)
	}
	return dtos
}

func FromRecomendationTsToIdxDTO(r model.RecommendationTS) *IdxDTO {
	return &IdxDTO{
		IdItem: r.TSID,
		Score:  r.Rating,
	}
}

func ToRecommendationTsesDTOs(rs []model.RecommendationTS) []IdxDTO {
	dtos := make([]IdxDTO, len(rs))
	for i, r := range rs {
		dtos[i] = *FromRecomendationTsToIdxDTO(r)
	}
	return dtos
}
