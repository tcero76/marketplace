package controller

import (
	"net/http"

	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"
	logger "github.com/tcero76/marketplace/config"

	"github.com/labstack/echo/v4"
)

type TsController struct {
	log       *logger.LoggerLogstash
	tsService services.ITsService
}

func NewTsController(log *logger.LoggerLogstash, tsService services.ITsService) *TsController {
	return &TsController{log, tsService}
}

func (h *TsController) GetTs() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Entrando a GetTs")
		query := c.QueryParam("ts")
		h.log.Debug("Query parametro ts: ", query)

		ts, err := h.tsService.GetTs(query)
		if err != nil {
			h.log.Error("Error in GetTs: ", err)
			return c.String(http.StatusInternalServerError, "Error fetching ts: "+err.Error())
		}

		h.log.Debug("Ts found: ", ts)
		return c.JSON(http.StatusOK, ts)
	}
}

func (h *TsController) GetTses() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Entrando a GetModelos")
		tses, err := h.tsService.GetTses()
		if err != nil {
			h.log.Error("Error in GetTses")
			c.JSON(http.StatusInternalServerError, "Error fetching GetTses")
		}
		h.log.Debug("Modelos found: ", tses)
		return c.JSON(http.StatusOK, tses)
	}
}

func (h *TsController) GetSearchTs() echo.HandlerFunc {
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
		modeloSearchs := h.tsService.GetSearchTs(req)
		h.log.Debug("Searchs encontrados: ", modeloSearchs)
		return c.JSON(http.StatusOK, modeloSearchs)
	}
}
