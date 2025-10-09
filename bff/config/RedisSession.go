package config

import (
	"context"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/tcero76/marketplace/bff/services"
)

var ctx = context.Background()

func RedisSessionMiddleware(authCacheService services.IAuthCacheService) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			cookie, err := c.Cookie("session_id")
			var sessionID string
			if err != nil || cookie.Value == "" {
				sessionID = uuid.New().String()
				newCookie := &http.Cookie{
					Name:     "session_id",
					Value:    sessionID,
					Path:     "/",
					HttpOnly: true,
					Secure:   false,
					MaxAge:   3600,
				}
				c.SetCookie(newCookie)
			} else {
				sessionID = cookie.Value
			}
			val, err := authCacheService.LoadSessionAll(sessionID, ctx)
			if err == nil {
				if len(val) == 0 {
					sessionData := make(map[string]string)
					sessionData["session_id"] = sessionID
					sessionData["isAuthenticated"] = "false"
					c.Set("session_data", sessionData)
					err = authCacheService.SaveSessionAll(sessionID, sessionData, ctx)
				} else {
					c.Set("session_data", val)
				}
			} else {
				return c.JSON(http.StatusInternalServerError, "Error al crear session: "+err.Error())
			}
			return next(c)
		}
	}
}
