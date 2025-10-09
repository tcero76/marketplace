package clickhouse

import "github.com/tcero76/marketplace/clickhouse/model"

type Recommendation struct {
	UserID string  `json:"user_id"`
	Modelo string  `json:"modelo"`
	Score  float32 `json:"score"`
}

func ToRecommendationDTO(r model.Recommendation) Recommendation {
	return Recommendation{
		UserID: r.UserID,
		Modelo: r.Modelo,
		Score:  r.Score,
	}
}

func ToRecommendationDTOs(rs []model.Recommendation) []Recommendation {
	dtos := make([]Recommendation, len(rs))
	for i, r := range rs {
		dtos[i] = ToRecommendationDTO(r)
	}
	return dtos
}
