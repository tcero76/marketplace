package config

import (
	"context"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
	"github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/redis/model"
)

var ctx = context.Background()

func RedisSessionMiddleware(authCacheService services.IAuthCacheService) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			log.Trace("Ip remota: ", c.Request().RemoteAddr)
			log.Trace("User Agent: ", c.Request().Header.Get("User-Agent"))
			cookie, err := c.Cookie("session_id")
			log.Trace("Cookie session_id: ", cookie)
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
				log.Debug("Session ID from cookie: ", sessionID)
			}
			log.Info("Session ID: ", sessionID)
			val, err := authCacheService.GetSession(sessionID)
			if err != nil {
				log.Error("Error getting session: ", err)
				sessionData := &model.SessionData{}
				sessionData.SessionID = sessionID
				sessionData.IsAuthenticated = false
				authCacheService.SaveSession(sessionID, *sessionData)
			}
			c.Set("session_data", val)
			return next(c)
		}
	}
}
