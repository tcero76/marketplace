package controller

import (
	"net/http"

	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"

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
			log.Error("Error al parsear JSON: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "Error al parsear JSON",
			})
		}
		log.Debug("Request de search: ", req)
		modeloSearchs := searchService.GetSearch(req)
		log.Debug("Searchs encontrados: ", modeloSearchs)
		return c.JSON(http.StatusOK, modeloSearchs)
	}
}
