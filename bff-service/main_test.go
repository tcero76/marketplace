package main

import (
	"BFF/config"
	"BFF/controller"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestGetRecommendations(t *testing.T) {
	fmt.Println("Starting TestGetRecommendations...")
	e := echo.New()
	_ = godotenv.Load("../infra/.env")
	os.Setenv("CLICKHOUSE_HOST", "localhost")
	os.Setenv("CLICKHOUSE_PORT", "9000")
	conn := config.GetClickhouse()
	userId := "123e4567-e89b-12d3-a456-426614174000"
	endpoint := fmt.Sprintf("/getRecommendations?userId=%s", userId)
	req := httptest.NewRequest(http.MethodGet, endpoint, nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	handler := controller.GetRecommendations(conn)
	if assert.NoError(t, handler(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		t.Logf("Body: %s", rec.Body.String())
	}
}
