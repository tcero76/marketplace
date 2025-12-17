package config

import (
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	logConfig "github.com/tcero76/marketplace/config"
)

func LoggerMiddleware(log *logConfig.LoggerLogstash) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			entry := log.WithFields(
				uuid.NewString(),
				c.Request().Method,
				c.Request().URL.Path,
			)
			ctx := log.WithLogger(c.Request().Context(), entry)
			c.SetRequest(c.Request().WithContext(ctx))
			return next(c)
		}
	}
}
