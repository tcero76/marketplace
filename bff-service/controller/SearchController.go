package controller

import (
	"net/http"

	"github.com/tcero76/marketplace/bff/payload"
	"github.com/tcero76/marketplace/bff/services"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

type SearchController struct {
}

type ISearchController interface {
	Search()
}

func GetSearch(searchService services.ISearchService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("Entrando a search")
		var req payload.SearchRequest
		if err := c.Bind(&req); err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "Error al parsear JSON",
			})
		}
		log.Info("Request de search: ", req)
		modeloSearchs := searchService.GetSearch(req)
		return c.JSON(http.StatusOK, modeloSearchs)
	}
	return nil
}
