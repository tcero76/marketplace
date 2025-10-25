package cor

import (
	"net/http"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
	"github.com/tcero76/marketplace/redis/model"
)

type LoginInternalHandler struct {
	BaseHandler
	InternalAuth InternalAuth
}

func (h *LoginInternalHandler) Handle(c echo.Context) error {
	var idp = c.QueryParam("idp")
	sessionData := c.Get("session_data").(*model.SessionData)
	sessionData.LoginChallenge = c.QueryParam("login_challenge")
	if sessionData.LoginChallenge == "" {
		return c.String(http.StatusBadRequest, "No login challenge provided")
	}
	sessionData.Idp = idp
	err := h.AuthCacheService.SaveSession(sessionData.SessionID, *sessionData)
	if err != nil {
		log.Error("Error saving session data: ", err)
		return c.String(http.StatusInternalServerError, "Error saving session data: "+err.Error())
	}
	if idp == "internal" {
		err := h.setEncodedCookie(&c)
		if err != nil {
			return c.String(http.StatusBadRequest, "Error setting cookie: "+err.Error())
		}
		userForm := c.FormValue("user")
		// password := c.FormValue("password")
		userDTO, err := h.InternalAuth.userServices.GetUser(userForm)
		sessionData.UserID = userDTO.UserID.String()
		if err != nil {
			log.Error("Error fetching user from DB: ", err)
			return c.String(http.StatusBadRequest, "Error fetching user: "+err.Error())
		}
		log.Info("UserDTO from db: ", userDTO)
		redirect, errLogin := h.InternalAuth.Login(sessionData.LoginChallenge, userDTO, c.Request().Context())
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
	log.Debug("ExpectedState and CookieValue: ", expectedState, cookie.Value)
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
	sessionData := c.Get("session_data").(*model.SessionData)
	if sessionData.Idp == "internal" {
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
		sessionData.AccessToken = token.AccessToken
		sessionData.RefreshToken = token.RefreshToken
		h.AuthCacheService.SaveSession(sessionData.SessionID, *sessionData)
		log.Debug("Storing tokens in session Data: ", sessionData)
		return c.Redirect(http.StatusFound, "/home?accessToken="+token.AccessToken)
	} else {
		return h.Next.Handle(c)
	}
}
