package controller

import (
	"net/http"
	"slices"

	"github.com/tcero76/marketplace/bff-service/services"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

func GetModelo(modeloService services.IModeloService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("Entrando a GetModelo")
		query := c.QueryParam("modelo")
		log.Debug("Query parametro modelo: ", query)
		modelo, err := modeloService.GetModelByModelo(query)
		if err != nil {
			log.Error("Error in GetModelByModelo: ", err)
			return c.String(http.StatusInternalServerError, "Error fetching modelo: "+err.Error())
		}
		log.Debug("Modelo found: ", modelo)
		c.JSON(http.StatusOK, modelo)
		return nil
	}
}

func GetModelos(modeloService services.IModeloService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("Entrando a GetModelos")
		modelos := modeloService.GetModelos()
		nombres := slices.Collect(func(yield func(string) bool) {
			for _, m := range modelos {
				if !yield(m.Modelo) {
					return
				}
			}
		})
		log.Debug("Modelos found: ", nombres)
		return c.JSON(http.StatusOK, nombres)
	}
}
