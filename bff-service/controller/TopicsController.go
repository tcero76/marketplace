package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/tcero76/marketplace/bff-service/services"
	logConfig "github.com/tcero76/marketplace/config"
)

type TopicsController struct {
	log           *logConfig.LoggerLogstash
	topicsService services.ITopicsService
}

func NewTopicsController(log *logConfig.LoggerLogstash, topicsService services.ITopicsService) *TopicsController {
	return &TopicsController{log: log, topicsService: topicsService}
}

func (h *TopicsController) GetTopics() echo.HandlerFunc {
	return func(c echo.Context) error {
		topics, err := h.topicsService.GetTopics()
		if err != nil {
			h.log.Error("Error al obtener los topics: ", err)
			return err
		}
		h.log.Info("Topics obtenidos: ", topics)
		return c.JSON(http.StatusOK, topics)
	}
}
