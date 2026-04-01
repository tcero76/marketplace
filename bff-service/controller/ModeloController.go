package controller

import (
	"net/http"
	"slices"

	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"
	logger "github.com/tcero76/marketplace/config"

	"github.com/labstack/echo/v4"
)

type ModeloController struct {
	log           *logger.LoggerLogstash
	modeloService services.IModeloService
}

func NewModeloController(log *logger.LoggerLogstash, modeloService services.IModeloService) *ModeloController {
	return &ModeloController{log, modeloService}
}

func (h *ModeloController) GetModelo() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Entrando a GetModelo")
		query := c.QueryParam("modelo")
		h.log.Debug("Query parametro modelo: ", query)
		modelo, err := h.modeloService.GetModelByModelo(query)
		if err != nil {
			h.log.Error("Error in GetModelByModelo: ", err)
			return c.String(http.StatusInternalServerError, "Error fetching modelo: "+err.Error())
		}
		h.log.Debug("Modelo found: ", modelo)
		return c.JSON(http.StatusOK, modelo)
	}
}

func (h *ModeloController) GetModelos() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Entrando a GetModelos")
		modelos := h.modeloService.GetModelos()
		nombres := slices.Collect(func(yield func(string) bool) {
			for _, m := range modelos {
				if !yield(m.Modelo) {
					return
				}
			}
		})
		h.log.Debug("Modelos found: ", nombres)
		return c.JSON(http.StatusOK, nombres)
	}
}

func (h *ModeloController) GetSearch() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Entrando a search Modelos")
		var req payload.SearchRequest
		if err := c.Bind(&req); err != nil {
			h.log.Error("Error al parsear JSON: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "Error al parsear JSON",
			})
		}
		h.log.Debug("Request de search: ", req)
		modeloSearchs := h.modeloService.GetSearch(req)
		h.log.Debug("Searchs encontrados: ", modeloSearchs)
		return c.JSON(http.StatusOK, modeloSearchs)
	}
}
