package controller

import (
	"context"
	"crypto/rsa"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/lestrrat-go/jwx/v2/jwk"

	"github.com/golang-jwt/jwt/v4"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/oauth2/cor"
	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"
	logConfig "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/redis/model"

	"golang.org/x/oauth2"
)

type AuthController struct {
	log *logConfig.LoggerLogstash
}

func NewAuthController(log *logConfig.LoggerLogstash) *AuthController {
	return &AuthController{log}
}

var token *oauth2.Token

func (h *AuthController) HandleLogin(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("HandleLogin called")
		return handler.Handle(c)
	}
}

func (h *AuthController) HandleConsent(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("HandleConsent called")
		return handler.Handle(c)
	}
}

func (h *AuthController) HandleCallback(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("HandleCallback called")
		return handler.Handle(c)
	}
}

func getKeyFromJWKS(kid string, log *logConfig.LoggerLogstash) (*rsa.PublicKey, error) {
	log.Info("Getting key")
	log.Info("Fetching JWKS")
	url := os.Getenv("HYDRA_PUBLIC_URL") + "/.well-known/jwks.json"
	set, err := jwk.Fetch(context.Background(), url, jwk.WithHTTPClient(http.DefaultClient))
	if err != nil {
		log.Error("Error fetching JWKS: ", err)
		return nil, fmt.Errorf("failed to fetch JWKS: %w", err)
	}
	key, found := set.LookupKeyID(kid)
	if !found {
		log.Warn("Key not found with kid: ", kid)
		return nil, fmt.Errorf("no key found with kid: %s", kid)
	}
	var pubKey rsa.PublicKey
	if err := key.Raw(&pubKey); err != nil {
		log.Error("Error getting RSA public key: ", err)
		return nil, fmt.Errorf("failed to get rsa public key: %w", err)
	}
	return &pubKey, nil
}

func verifyToken(tokenStr string, log *logConfig.LoggerLogstash) (jwt.MapClaims, error) {
	log.Info("Verifying token")
	keyFunc := func(token *jwt.Token) (interface{}, error) {
		kid, ok := token.Header["kid"].(string)
		if !ok {
			log.Error("kid header missing or not a string")
			return nil, errors.New("token missing kid header")
		}
		return getKeyFromJWKS(kid, log)
	}
	token, err := jwt.ParseWithClaims(tokenStr, jwt.MapClaims{}, keyFunc)
	if err != nil {
		log.Error("Error parsing token: ", err)
		return nil, err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims, nil
	}
	log.Error("Invalid token")
	return nil, errors.New("invalid token")
}
func (h *AuthController) AuthHandler() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("AuthHandler called")
		authHeader := c.Request().Header.Get("Authorization")
		const prefix = "Bearer "
		if !strings.HasPrefix(authHeader, prefix) {
			h.log.Warn("Invalid or missing Authorization header")
			return echo.NewHTTPError(http.StatusUnauthorized, "Invalid or missing Authorization header")
		}
		tokenStr := strings.TrimPrefix(authHeader, prefix)
		claims, err := verifyToken(tokenStr, h.log)
		h.log.Debug("Claims: ", claims)
		if err != nil {
			h.log.Error("Token verification failed: ", err)
			return echo.NewHTTPError(http.StatusUnauthorized, err.Error())
		}
		return c.JSON(http.StatusOK, claims)
	}
}
func (h *AuthController) LogoutHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("LogoutHandler called")
		sessionData := c.Get("session_data").(*model.SessionData)
		sessionData.IsAuthenticated = false
		sessionData.RefreshToken = ""
		err := authCacheService.SaveSession(sessionData.SessionID, *sessionData, c.Request().Context())
		if err != nil {
			h.log.Error("Error saving session data during logout: ", err)
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to logout")
		}
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Logout successful",
		})
	}
}

func (h *AuthController) RefreshTokenHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("RefreshTokenHandler called")
		sessionData := c.Get("session_data").(*model.SessionData)
		h.log.Debug("Session Data: ", sessionData)
		conf := &oauth2.Config{
			ClientID:     os.Getenv("CLIENT_ID"),
			ClientSecret: os.Getenv("CLIENT_SECRET"),
			Endpoint: oauth2.Endpoint{
				AuthURL:  os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/auth",
				TokenURL: os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/token",
			},
			RedirectURL: os.Getenv("REDIRECT_URL"),
			Scopes:      []string{"openid", "offline_access", "mediamtx:stream"},
		}
		h.log.Debug("Usando el siguiente Access Token: ", sessionData.AccessToken)
		token := &oauth2.Token{
			RefreshToken: sessionData.RefreshToken,
			Expiry:       time.Now().Add(-time.Minute),
		}
		h.log.Debug("Access Token Refrescado: ", token.AccessToken)
		ctx := c.Request().Context()
		ts := conf.TokenSource(ctx, token)
		h.log.Debug("TokenSource creado", ts)
		newToken, err := ts.Token()
		h.log.Debug("Nuevo token obtenido", newToken)
		if err != nil {
			h.log.Error("Error al refrescar token: ", err)
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to refresh token")
		}
		sessionData.RefreshToken = newToken.RefreshToken
		err = authCacheService.SaveSession(sessionData.SessionID, *sessionData, c.Request().Context())
		if err != nil {
			h.log.Error("Error storing refresh token: ", err)
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to store refresh token")
		}

		return c.JSON(http.StatusOK, map[string]string{
			"accessToken": newToken.AccessToken})
	}
}

func (h *AuthController) SignUpHandler(userService services.IUserService) echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("SignUpHandler called")
		var req payload.SignUpRequest
		if err := c.Bind(&req); err != nil {
			h.log.Error("Error binding request: ", err)
			return echo.NewHTTPError(http.StatusBadRequest, "Invalid request payload")
		}

		_, err := userService.GetUserByEmail(req.Email)
		if err == nil {
			h.log.Error("Email already in use: ", req.Email)
			return echo.NewHTTPError(http.StatusConflict, "Email already in use")
		}
		newUser := dto.UserDTO{
			UserID:   uuid.New(),
			Nombre:   req.Email,
			Email:    req.Email,
			Password: req.Password,
			Provider: "internal",
		}
		h.log.Debug("Creating user: ", newUser)
		if err := userService.CreateUser(&newUser); err != nil {
			h.log.Error("Error creating user: ", err)
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to create user")
		}
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "User created successfully",
		})
	}
}
