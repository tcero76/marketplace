package cor

import (
	"fmt"
	"net/http"

	"github.com/tcero76/marketplace/bff/services"

	"github.com/labstack/echo/v4"
)

type BaseHandler struct {
	Next             Handler
	UserServices     services.IUserService
	AuthCacheService services.IAuthCacheService
}

func (b *BaseHandler) SetNext(handler Handler) {
	if b.Next != nil {
		b.Next.SetNext(handler)
	} else {
		b.Next = handler
	}
}

func (b *BaseHandler) Handle(request echo.Context) error {
	if b.Next != nil {
		b.Next.Handle(request)
	}
	return nil
}

func (h *BaseHandler) setEncodedCookie(c *echo.Context) error {
	state := (*c).QueryParam("state")
	if state == "" {
		return (*c).String(http.StatusBadRequest, "No state provided")
	}
	encoded, errEncode := s.Encode("oauth_state", state)
	if errEncode != nil {
		fmt.Println("Encode error:", errEncode.Error())
	}
	cookie := new(http.Cookie)
	cookie.Name = "oauth_state"
	cookie.Value = encoded
	cookie.Path = "/"
	cookie.HttpOnly = true
	cookie.Secure = true
	cookie.SameSite = http.SameSiteLaxMode
	(*c).SetCookie(cookie)
	return nil
}
