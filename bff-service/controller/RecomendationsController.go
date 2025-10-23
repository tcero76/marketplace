package controller

import (
	"github.com/tcero76/marketplace/bff-service/services"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

func GetRecommendations(recomendationService services.IRecomendationService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("Fetching recommendations for user")
		userId := c.QueryParam("userId")
		log.Debug("User ID: ", userId)
		items := recomendationService.GetRecomendations(c.Request().Context(), userId)
		log.Debug("Recommendations: ", items)
		return c.JSON(200, items)
	}
}
