package controller

import (
	"github.com/labstack/echo/v4"
	logConfig "github.com/tcero76/marketplace/config"
)

func HealthCheckHandler(log *logConfig.LoggerLogstash) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.FromContext(c.Request().Context()).Info("HealthCheckHandler called")
		return c.JSON(200, map[string]string{
			"status": "healthy",
		})
	}
}
