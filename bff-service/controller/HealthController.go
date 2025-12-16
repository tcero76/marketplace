package controller

import (
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

func HealthCheckHandler(c echo.Context) error {
	log.Info("HealthCheckHandler called")
	return c.JSON(200, map[string]string{
		"status": "healthy",
	})
}
