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

	"github.com/golang-jwt/jwt/v5"

	"github.com/tcero76/marketplace/bff/dto"
	"github.com/tcero76/marketplace/bff/oauth2/cor"
	"github.com/tcero76/marketplace/bff/services"

	"golang.org/x/oauth2"
)

var token *oauth2.Token

func HandleLogin(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		return handler.Handle(c)
	}
}

func HandleConsent(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		return handler.Handle(c)
	}
}

func HandleCallback(handler cor.Handler) echo.HandlerFunc {
	return func(c echo.Context) error {
		return handler.Handle(c)
	}
}

func getKeyFromJWKS(kid string) (*rsa.PublicKey, error) {
	url := os.Getenv("HYDRA_PUBLIC_URL") + "/.well-known/jwks.json"
	set, err := jwk.Fetch(context.Background(), url, jwk.WithHTTPClient(http.DefaultClient))
	if err != nil {
		return nil, fmt.Errorf("failed to fetch JWKS: %w", err)
	}
	key, found := set.LookupKeyID(kid)
	if !found {
		return nil, fmt.Errorf("no key found with kid: %s", kid)
	}
	var pubKey rsa.PublicKey
	if err := key.Raw(&pubKey); err != nil {
		return nil, fmt.Errorf("failed to get rsa public key: %w", err)
	}
	return &pubKey, nil
}

func verifyToken(tokenStr string) (jwt.MapClaims, error) {
	keyFunc := func(token *jwt.Token) (interface{}, error) {
		kid, ok := token.Header["kid"].(string)
		if !ok {
			return nil, errors.New("token missing kid header")
		}
		return getKeyFromJWKS(kid)
	}

	token, err := jwt.ParseWithClaims(tokenStr, jwt.MapClaims{}, keyFunc)
	if err != nil {
		return nil, fmt.Errorf("failed to parse token: %w", err)
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, errors.New("invalid token")
}

func AuthHandler(c echo.Context) error {
	authHeader := c.Request().Header.Get("Authorization")
	const prefix = "Bearer "
	if !strings.HasPrefix(authHeader, prefix) {
		return echo.NewHTTPError(http.StatusUnauthorized, "Invalid or missing Authorization header")
	}
	tokenStr := strings.TrimPrefix(authHeader, prefix)
	claims, err := verifyToken(tokenStr)
	log.Info("Claims: ", claims)
	if err != nil {
		return echo.NewHTTPError(http.StatusUnauthorized, err.Error())
	}
	return c.JSON(http.StatusOK, claims)
}

func LogoutHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		sessionData := c.Get("session_data").(map[string]string)
		authCacheService.StoreTokenInRedis(sessionData["session_id"], "isAuthenticated", "false", c.Request().Context())
		authCacheService.StoreTokenInRedis(sessionData["session_id"], "refresh_token", "", c.Request().Context())
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Logout successful",
		})
	}
}

func RefreshTokenHandler(authCacheService services.IAuthCacheService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("RefreshTokenHandler called")
		redirect := "http://" + os.Getenv("HOST_EXTERNAL") + ":" + os.Getenv("PORT_EXTERNAL") + os.Getenv("RedirectURL")
		sessionData := c.Get("session_data").(map[string]string)

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

		token := &oauth2.Token{
			RefreshToken: sessionData["refresh_token"],
			Expiry:       time.Now().Add(-time.Minute), // lo forzamos a que esté expirado
		}
		ctx := c.Request().Context()
		ts := conf.TokenSource(ctx, token)
		newToken, err := ts.Token()
		if err != nil {
			panic(err)
		}
		err = authCacheService.StoreTokenInRedis(sessionData["session_id"], "refresh_token", newToken.RefreshToken, ctx)
		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to store refresh token")
		}
		return c.JSON(http.StatusOK, map[string]string{
			"accessToken": newToken.AccessToken})
	}
}

func SignUpHandler(userService services.IUserService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("SignUpHandler called")
		type SignUpRequest struct {
			Username string `json:"username" form:"username"`
			Email    string `json:"email" form:"email"`
			Password string `json:"password" form:"password"`
		}
		var req SignUpRequest
		if err := c.Bind(&req); err != nil {
			return echo.NewHTTPError(http.StatusBadRequest, "Invalid request payload")
		}
		_, err := userService.GetUserByEmail(req.Email)
		if err == nil {
			return echo.NewHTTPError(http.StatusConflict, "Email already in use")
		}
		newUser := dto.UserDTO{
			UserID:   uuid.New(),
			Nombre:   req.Email,
			Email:    req.Email,
			Password: req.Password,
			Provider: "internal",
		}
		log.Info("Creating user: ", newUser)
		if err := userService.CreateUser(&newUser); err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, "Failed to create user")
		}
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "User created successfully",
		})
	}
}
