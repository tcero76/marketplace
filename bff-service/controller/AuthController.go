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
	log "github.com/sirupsen/logrus"

	"github.com/golang-jwt/jwt/v4"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/oauth2/cor"
	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/redis/model"

	"golang.org/x/oauth2"
)

var token *oauth2.Token

func HandleLogin(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("HandleLogin called")
		return handler.Handle(c)
	}
}

func HandleConsent(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("HandleConsent called")
		return handler.Handle(c)
	}
}

func HandleCallback(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("HandleCallback called")
		return handler.Handle(c)
	}
}

func getKeyFromJWKS(kid string) (*rsa.PublicKey, error) {
	log.Info("Getting key")
	log.WithField("from", os.Getenv("HYDRA_PUBLIC_URL")+"/.well-known/jwks.json").
		Info("Fetching JWKS")
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

func verifyToken(tokenStr string) (jwt.MapClaims, error) {
	log.Info("Verifying token")
	keyFunc := func(token *jwt.Token) (interface{}, error) {
		kid, ok := token.Header["kid"].(string)
		if !ok {
			log.Error("kid header missing or not a string")
			return nil, errors.New("token missing kid header")
		}
		return getKeyFromJWKS(kid)
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

func AuthHandler(c echo.Context) error {
	log.Info("AuthHandler called")
	authHeader := c.Request().Header.Get("Authorization")
	const prefix = "Bearer "
	if !strings.HasPrefix(authHeader, prefix) {
		log.Warn("Invalid or missing Authorization header")
		return echo.NewHTTPError(http.StatusUnauthorized, "Invalid or missing Authorization header")
	}
	tokenStr := strings.TrimPrefix(authHeader, prefix)
	claims, err := verifyToken(tokenStr)
	log.Debug("Claims: ", claims)
	if err != nil {
		log.Error("Token verification failed: ", err)
		return echo.NewHTTPError(http.StatusUnauthorized, err.Error())
	}
	return c.JSON(http.StatusOK, claims)
}

func LogoutHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("LogoutHandler called")
		sessionData := c.Get("session_data").(*model.SessionData)
		sessionData.IsAuthenticated = false
		sessionData.RefreshToken = ""
		err := authCacheService.SaveSession(sessionData.SessionID, *sessionData)
		if err != nil {
			log.WithField("err", err).Error("Error saving session data during logout")
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to logout")
		}
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Logout successful",
		})
	}
}

func RefreshTokenHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("RefreshTokenHandler called")
		redirect := "http://" + os.Getenv("HOST_EXTERNAL") + ":" + os.Getenv("PORT_EXTERNAL") + os.Getenv("RedirectURL")
		sessionData := c.Get("session_data").(*model.SessionData)
		log.Debug("Session Data: ", sessionData)
		conf := &oauth2.Config{
			ClientID:     os.Getenv("CLIENT_ID"),
			ClientSecret: os.Getenv("CLIENT_SECRET"),
			Endpoint: oauth2.Endpoint{
				AuthURL:  os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/auth",
				TokenURL: os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/token",
			},
			RedirectURL: redirect,
			Scopes:      []string{"openid", "offline_access", "mediamtx:stream"},
		}
		log.Debug("Usando el siguiente Access Token: ", sessionData.AccessToken)
		token := &oauth2.Token{
			RefreshToken: sessionData.RefreshToken,
			Expiry:       time.Now().Add(-time.Minute),
		}
		log.Debug("Access Token Refrescado: ", token.AccessToken)
		ctx := c.Request().Context()
		ts := conf.TokenSource(ctx, token)
		log.Debug("TokenSource creado", ts)
		newToken, err := ts.Token()
		log.Debug("Nuevo token obtenido", newToken)
		if err != nil {
			log.WithField("err", err).Error("Error al refrescar token")
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to refresh token")
		}
		sessionData.RefreshToken = newToken.RefreshToken
		err = authCacheService.SaveSession(sessionData.SessionID, *sessionData)
		if err != nil {
			log.WithField("err", err).Error("Error storing refresh token")
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to store refresh token")
		}

		return c.JSON(http.StatusOK, map[string]string{
			"accessToken": newToken.AccessToken})
	}
}

func SignUpHandler(userService services.IUserService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("SignUpHandler called")
		var req payload.SignUpRequest
		if err := c.Bind(&req); err != nil {
			log.Error("Error binding request: ", err)
			return echo.NewHTTPError(http.StatusBadRequest, "Invalid request payload")
		}

		_, err := userService.GetUserByEmail(req.Email)
		if err == nil {
			log.Error("Email already in use: ", req.Email)
			return echo.NewHTTPError(http.StatusConflict, "Email already in use")
		}
		newUser := dto.UserDTO{
			UserID:   uuid.New(),
			Nombre:   req.Email,
			Email:    req.Email,
			Password: req.Password,
			Provider: "internal",
		}
		log.Debug("Creating user: ", newUser)
		if err := userService.CreateUser(&newUser); err != nil {
			log.Error("Error creating user: ", err)
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to create user")
		}
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "User created successfully",
		})
	}
}
