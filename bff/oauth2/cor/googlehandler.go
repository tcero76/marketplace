package cor

import (
	"crypto/rand"
	"encoding/json"
	"math/big"
	"net/http"

	"github.com/tcero76/marketplace/bff/dto"
	"github.com/tcero76/marketplace/bff/model"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
	"golang.org/x/oauth2"
	"gorm.io/gorm"
)

type LoginGoogleHandler struct {
	BaseHandler
	GoogleAuth GoogleAuth
}

func (h *LoginGoogleHandler) Handle(c echo.Context) error {
	var idp = c.QueryParam("idp")
	if idp == "google" {
		redirect, _ := h.GoogleAuth.Login(c.QueryParam("state"), nil, c.Request().Context())
		h.AuthCacheService.StoreTokenInRedis(c.Get("session_data").(map[string]string)["session_id"], "loginChallenge", c.QueryParam("login_challenge"), c.Request().Context())
		url := make(map[string]string)
		url["url"] = redirect
		return c.JSON(http.StatusOK, url)
	}
	if h.Next != nil {
		return h.Next.Handle(c)
	}
	return nil
}

type ConsentGoogleHandler struct {
	BaseHandler
	googleAuth GoogleAuth
}

type CallbackGoogleHandler struct {
	BaseHandler
	InternalAuth InternalAuth
	GoogleAuth   GoogleAuth
}

func (h *CallbackGoogleHandler) Handle(c echo.Context) error {
	sessionData := c.Get("session_data").(map[string]string)
	if sessionData["idp"] == "google" && sessionData["isAuthenticated"] == "false" {
		log.Info("Entró a CallbackGoogleHandler")
		token, err := h.GoogleAuth.Callback(c.QueryParam("code"), c.Request().Context())
		if err != nil {
			log.Error("Error in Google callback: ", err)
			return c.String(http.StatusInternalServerError, "Error in Google callback: "+err.Error())
		}
		log.Info("Token received in Google callback: ", token)
		if token == nil {
			log.Error("Token is nil in Google callback")
			return c.String(http.StatusInternalServerError, "Token is nil in Google callback")
		}
		password, err := GeneratePassword(12)
		if err != nil {
			log.Error("Error generating password: ", err)
			return c.String(http.StatusInternalServerError, "Error generating password: "+err.Error())
		}
		googleUser, err := GetGoogleUser(token)
		if err != nil {
			log.Error("Error getting Google user: ", err)
			return c.String(http.StatusInternalServerError, "Error getting Google user: "+err.Error())
		}
		user, err := h.GoogleAuth.userServices.GetUserByEmail(googleUser.Email)
		if err != nil {
			if err == gorm.ErrRecordNotFound {
				var userDTO = dto.UserDTO{
					UserID:     uuid.New(),
					Password:   password,
					Provider:   "google",
					Email:      googleUser.Email,
					Avatar:     googleUser.Picture,
					Nombre:     googleUser.Name,
					IDProvider: googleUser.ID,
				}
				err = h.GoogleAuth.userServices.CreateUser(&userDTO)
			}
			log.Error("Error retrieving user by email: ", err.Error)
		}
		loginChallenge, err := h.AuthCacheService.LoadTokenFromRedis(c.Get("session_data").(map[string]string)["session_id"], "loginChallenge", c.Request().Context())
		if err != nil {
			log.Error("Error loading login challenge from Redis: ", err)
			return c.String(http.StatusInternalServerError, "Error loading login challenge from Redis: "+err.Error())
		}
		redirect, err := h.InternalAuth.Login(loginChallenge, user, c.Request().Context())
		log.Info("Redirect URL after Google login: ", redirect)
		if err != nil {
			log.Error("Error in internal login: ", err)
			return c.String(http.StatusInternalServerError, "Error in internal login: "+err.Error())
		}
		h.setEncodedCookie(&c)
		err = h.AuthCacheService.StoreTokenInRedis(sessionData["session_id"], "isAuthenticated", "true", c.Request().Context())
		if err != nil {
			log.Error("Error storing isAuthenticated in Redis: ", err)
			return c.String(http.StatusInternalServerError, "Error storing isAuthenticated in Redis: "+err.Error())
		}
		err = h.AuthCacheService.StoreTokenInRedis(sessionData["session_id"], "idp", "internal", c.Request().Context())
		if err != nil {
			log.Error("Error storing access token in Redis: ", err)
		}
		return c.Redirect(http.StatusFound, redirect)
	}
	if h.Next != nil {
		return h.Next.Handle(c)
	}
	return nil
}

func GetGoogleUser(token *oauth2.Token) (*model.GoogleUser, error) {
	resp, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + token.AccessToken)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var user model.GoogleUser
	if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
		return nil, err
	}

	return &user, nil
}

func GeneratePassword(length int) (string, error) {
	password := make([]byte, length)
	for i := range password {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(charset))))
		if err != nil {
			return "", err
		}
		password[i] = charset[num.Int64()]
	}
	return string(password), nil
}
