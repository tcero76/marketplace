package services

import (
	"context"

	"github.com/tcero76/marketplace/bff-service/dto"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/model"
	"gorm.io/gorm"
)

type RecomendationService struct {
	log     *logger.LoggerLogstash
	dbWrite *gorm.DB
	dbRead  *gorm.DB
}

func NewRecomendationService(log *logger.LoggerLogstash, dbWrite *gorm.DB, dbRead *gorm.DB) *RecomendationService {
	return &RecomendationService{log, dbWrite, dbRead}
}

func (h *RecomendationService) GetRecomendationsTs(ctx context.Context, userId string) []dto.IdxDTO {
	h.log.Info("Get Recommendations Ts for user: ", userId)
	var recomendationsTs []model.RecommendationTS
	err := h.dbRead.Where("user_id = ?", userId).Find(&recomendationsTs).Error
	if err != nil {
		h.log.Error("Error querying user model recommendations", "error", err, "user_id", userId)
		return nil
	}
	h.log.Debug("RecomendationsTS: ", recomendationsTs)
	if len(recomendationsTs) > 0 {
		return dto.ToRecommendationTsesDTOs(recomendationsTs)
	}
	var tses []model.TS
	err = h.dbRead.Find(&tses).Error
	if err != nil {
		h.log.Error("Error fetching fallback model recommendations", "error", err)
		return nil
	}
	return dto.FromTsesToIdxDTOs(tses)
}

// func (h *RecomendationService) GetRecomendationsPosts(ctx context.Context, userId string) []dto.RecommendationPostsDTO {
// 	h.log.Info("Get Recommendations Posts for user", "user_id", userId)
// 	var recomendationsPosts = []model.RecomendationsPosts{}
// 	err := h.dbRead.Where("user_id = ?", userId).
// 		Find(&recomendationsPosts).Error
// 	if err != nil {
// 		h.log.Error("Error querying user recommendations", "error", err)
// 		return nil
// 	}
// 	if len(recomendationsPosts) > 0 {
// 		return dto.ToRecommendationPostsDTOs(recomendationsPosts)
// 	}
// 	const fallbackLimit = 10
// 	err = h.dbRead.
// 		Order("RANDOM()").
// 		Limit(fallbackLimit).
// 		Find(&recomendationsPosts).Error
// 	if err != nil {
// 		h.log.Error("Error fetching fallback recommendations", "error", err)
// 		return nil
// 	}
// 	return dto.ToRecommendationPostsDTOs(recomendationsPosts)
// }

// func (h *RecomendationService) GetRecomendationsModels(ctx context.Context, userId string) []dto.RecommendationModelsDTO {
// 	h.log.Info("Get Recommendations Models for user", "user_id", userId)
// 	var recomendationsModels []model.RecomendationsModels
// 	err := h.dbRead.Where("user_id = ?", userId).Find(&recomendationsModels).Error
// 	if err != nil {
// 		h.log.Error("Error querying user model recommendations", "error", err, "user_id", userId)
// 		return nil
// 	}
// 	if len(recomendationsModels) > 0 {
// 		return dto.ToRecommendationModelsDTOs(recomendationsModels)
// 	}
// 	err = h.dbRead.Find(&recomendationsModels).Error
// 	if err != nil {
// 		h.log.Error("Error fetching fallback model recommendations", "error", err)
// 		return nil
// 	}
// 	return dto.ToRecommendationModelsDTOs(recomendationsModels)
// }
