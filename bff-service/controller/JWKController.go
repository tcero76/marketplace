package controller

import (
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
	"github.com/tcero76/marketplace/bff-service/services"
	logConfig "github.com/tcero76/marketplace/config"
)

// // --- Simulación de DB ---
// var rsaPrivateKey *rsa.PrivateKey
// var jwkSet jwk.Set

// func initKeys() {
// 	// Genera una llave RSA de 2048 bits
// 	var err error
// 	rsaPrivateKey, err = rsa.GenerateKey(rand.Reader, 2048)
// 	if err != nil {
// 		log.Fatalf("Error generando RSA key: %v", err)
// 	}

// 	// Convierte a JWK y crea un JWKS
// 	key, err := jwk.New(&rsaPrivateKey.PublicKey)
// 	if err != nil {
// 		log.Fatalf("Error creando JWK: %v", err)
// 	}

// 	// Asignamos un kid (identificador)
// 	key.Set(jwk.KeyIDKey, "mediamtx-demo-key")
// 	jwkSet = jwk.NewSet()
// 	jwkSet.Add(key)
// }

// --- Endpoint JWKS ---
func JwksHandler(jwkService services.IJWKService, log *logConfig.LoggerLogstash) echo.HandlerFunc {
	return func(c echo.Context) error {
		_, jwkSet, err := jwkService.GetKeys()
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "Error obteniendo claves")
		}
		return c.JSON(http.StatusOK, jwkSet)
	}
}

// --- Endpoint para generar token JWT ---
func TokenHandler(jwkService services.IJWKService, log *logConfig.LoggerLogstash) echo.HandlerFunc {
	return func(c echo.Context) error {
		rsaPrivateKey, _, err := jwkService.GetKeys()
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
