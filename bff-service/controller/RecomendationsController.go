package controller

import (
	"net/http"

	"github.com/golang-jwt/jwt/v4"
	"github.com/tcero76/marketplace/bff-service/services"
	logger "github.com/tcero76/marketplace/config"

	"github.com/labstack/echo/v4"
)

type RecomendationController struct {
	log                  *logger.LoggerLogstash
	recomendationService services.IRecomendationService
}

func NewRecomendationController(log *logger.LoggerLogstash, recomendationService services.IRecomendationService) *RecomendationController {
	return &RecomendationController{log, recomendationService}
}

func (h *RecomendationController) GetRecommendations() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Fetching recommendations for user")
		user := c.Get("user").(jwt.MapClaims)
		userId := user["sub"].(string)
		h.log.Debug("User ID: ", userId)
		items := h.recomendationService.GetRecomendationsTs(c.Request().Context(), userId)
		return c.JSON(http.StatusOK, items)
	}
}
