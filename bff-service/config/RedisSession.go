package config

import (
	"context"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
	"github.com/tcero76/marketplace/bff-service/services"
)

var ctx = context.Background()

func RedisSessionMiddleware(authCacheService services.IAuthCacheService) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			log.Info("Ip remota: ", c.Request().RemoteAddr)
			log.Info("User Agent: ", c.Request().Header.Get("User-Agent"))
			cookie, err := c.Cookie("session_id")
			log.Debug("Cookie session_id: ", cookie)
			var sessionID string
			if err != nil || cookie.Value == "" {
				sessionID = uuid.New().String()
				newCookie := &http.Cookie{
					Name:     "session_id",
					Value:    sessionID,
					Path:     "/",
					HttpOnly: true,
					Secure:   false,
					MaxAge:   10 * 365 * 24 * 60 * 60,
					Expires:  time.Now().AddDate(10, 0, 0),
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
