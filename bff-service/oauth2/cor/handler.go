package cor

import (
	"github.com/gorilla/securecookie"
	"github.com/labstack/echo/v4"
)

var s = securecookie.New([]byte("very-secret-key"), nil)

type Handler interface {
	SetNext(handler Handler)
	Handle(request echo.Context) error
}
