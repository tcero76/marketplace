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
		items := recomendationService.GetRecomendations(c.Request().Context(), userId)
		return c.JSON(200, items)
	}
}
