package cor

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
)

type LoginInternalHandler struct {
	BaseHandler
	InternalAuth InternalAuth
}

func (h *LoginInternalHandler) Handle(c echo.Context) error {
	var idp = c.QueryParam("idp")
	sessionData := c.Get("session_data").(map[string]string)
	h.AuthCacheService.StoreTokenInRedis(sessionData["session_id"], "idp", idp, c.Request().Context())
	if idp == "internal" {
		h.AuthCacheService.StoreTokenInRedis(sessionData["session_id"], "idp", idp, c.Request().Context())
		loginChallenge := c.QueryParam("login_challenge")
		log.Info("Login challenge received: ", loginChallenge)
		if loginChallenge == "" {
			return c.String(http.StatusBadRequest, "No login challenge provided")
		}
		err := h.setEncodedCookie(&c)
		if err != nil {
			return c.String(http.StatusBadRequest, "Error setting cookie: "+err.Error())
		}
		userForm := c.FormValue("user")
		// password := c.FormValue("password")
		userDTO, err := h.InternalAuth.userServices.GetUser(userForm)
		if err != nil {
			log.Error("Error fetching user from DB: ", err)
			return c.String(http.StatusBadRequest, "Error fetching user: "+err.Error())
		}
		log.Info("UserDTO from db: ", userDTO)
		redirect, errLogin := h.InternalAuth.Login(loginChallenge, userDTO, c.Request().Context())
		if errLogin != nil {
			return c.String(http.StatusBadRequest, "Error in login: "+errLogin.Error())
		}
		return c.Redirect(http.StatusFound, redirect)
	} else {
		return h.Next.Handle(c)
	}
}

type ConsentInternalHandler struct {
	BaseHandler
	InternalAuth InternalAuth
}

func (h *ConsentInternalHandler) Handle(c echo.Context) error {
	cookie, err := c.Cookie("oauth_state")
	if err != nil {
		return c.String(http.StatusBadRequest, "Missing state cookie")
	}
	var expectedState string
	err = s.Decode("oauth_state", cookie.Value, &expectedState)
	fmt.Printf("ExpectedState: %s, CookieValue: %s \n", expectedState, cookie.Value)
	if err != nil {
		return c.String(http.StatusBadRequest, "Invalid state cookie")
	}
	consentChallenge := c.QueryParam("consent_challenge")
	if consentChallenge == "" {
		return c.String(http.StatusBadRequest, "No consent_challenge provided")
	}

	url, err := h.InternalAuth.Consent(c.Request().Context(), consentChallenge)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Error accepting consent")
	}
	return c.Redirect(http.StatusFound, url)

}

type CallbackInternalHandler struct {
	BaseHandler
	InternalAuth InternalAuth
}

func (h *CallbackInternalHandler) Handle(c echo.Context) error {
	sessionData := c.Get("session_data").(map[string]string)
	if sessionData["idp"] == "internal" {
		code := c.QueryParam("code")
		if code == "" {
			return c.String(http.StatusBadRequest, "No code provided")
		}
		cookie, errCookie := c.Cookie("oauth_state")
		if errCookie != nil {
			return c.String(http.StatusBadRequest, "Missing state cookie")
		}
		var expectedState string
		errDecode := s.Decode("oauth_state", cookie.Value, &expectedState)
		if errDecode != nil {
			return c.String(http.StatusBadRequest, "Invalid state cookie")
		}
		returnedState := c.QueryParam("state")
		if returnedState != expectedState {
			return c.String(http.StatusBadRequest, "State mismatch")
		}
		token := h.InternalAuth.Callback(code, c.Request().Context())
		sessionId := c.Get("session_data").(map[string]string)["session_id"]
		err := h.AuthCacheService.StoreTokenInRedis(sessionId, "access_token", token.AccessToken, c.Request().Context())
		if err != nil {
			log.Error("Error storing access token in Redis: ", err)
		}
		log.Info("Token stored in Redis for sessionId: ", token)
		err = h.AuthCacheService.StoreTokenInRedis(sessionId, "refresh_token", token.RefreshToken, c.Request().Context())
		if err != nil {
			log.Error("Error storing refresh token in Redis: ", err)
		}
		log.Info("Storing isAuthenticated true in Redis for sessionId: ", sessionId)
		err = h.AuthCacheService.StoreTokenInRedis(sessionId, "isAuthenticated", "true", c.Request().Context())
		if err != nil {
			log.Error("Error storing access token in Redis: ", err)
		}
		return c.Redirect(http.StatusFound, "/home?accessToken="+token.AccessToken)
	} else {
		return h.Next.Handle(c)
	}
}
