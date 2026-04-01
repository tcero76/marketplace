package controller

import (
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
	"github.com/tcero76/marketplace/bff-service/services"
	logConfig "github.com/tcero76/marketplace/config"
)

type JWKController struct {
	jwkService services.IJWKService
	log        *logConfig.LoggerLogstash
}

func NewJwksHandler(log *logConfig.LoggerLogstash, jwkService services.IJWKService) *JWKController {
	return &JWKController{jwkService, log}
}

func (h *JWKController) JwksHandler() echo.HandlerFunc {
	return func(c echo.Context) error {
		_, jwkSet, err := h.jwkService.GetKeys()
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "Error obteniendo claves")
		}
		return c.JSON(http.StatusOK, jwkSet)
	}
}

func (h *JWKController) TokenHandler() echo.HandlerFunc {
	return func(c echo.Context) error {
		rsaPrivateKey, _, err := h.jwkService.GetKeys()
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "Error obteniendo claves")
		}
		// Define claims según Mediamtx
		claims := jwt.MapClaims{
			"mediamtx_permissions": []map[string]interface{}{
				{"action": "publish", "path": "streams"},
				{"action": "read", "path": "streams"},
				{"action": "playback", "path": "streams"},
				{"action": "metrics", "path": "metrics"},
			},
			"iat": time.Now().Unix(),
			"exp": time.Now().Add(10 * time.Minute).Unix(),
		}

		token := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)
		token.Header["kid"] = "mediamtx-demo-key"

		signed, err := token.SignedString(rsaPrivateKey)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "Error firmando token")
		}

		resp := map[string]interface{}{
			"access_token": signed,
			"token_type":   "bearer",
			"expires_in":   600,
		}

		return c.JSON(http.StatusOK, resp)
	}
}
