package controller

import (
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"
	logger "github.com/tcero76/marketplace/config"

	"github.com/labstack/echo/v4"
)

type PostController struct {
	log         *logger.LoggerLogstash
	postService services.IPostsService
}

func NewPostController(log *logger.LoggerLogstash, postService services.IPostsService) *PostController {
	return &PostController{log, postService}
}

func (h *PostController) GetPosts() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("GetPosts Entrando")
		limit, err := strconv.Atoi(c.QueryParam("limit"))
		if err != nil {
			h.log.Error("Error al parsear limit: ", err)
			c.JSON(http.StatusBadRequest, map[string]string{
				"error": "limit inválido",
			})
		}
		offset, err := strconv.Atoi(c.QueryParam("offset"))
		if err != nil {
			h.log.Error("Error al parsear offset: ", err)
			c.JSON(http.StatusBadRequest, map[string]string{
				"error": "offset inválido",
			})
		}
		posts := h.postService.GetPosts(limit, offset)
		h.log.Debug("Posts encontrados: ", posts)
		total := h.postService.GetTotalPosts()
		h.log.Debug("Total de posts: ", total)
		return c.JSON(http.StatusOK, payload.PostsPage{
			Items:  posts,
			Limit:  limit,
			Offset: offset,
			Total:  total})
	}
}

func (h *PostController) CreatePosteo() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Creando posteo")
		posteo := dto.Posteo{}
		if err := c.Bind(&posteo); err != nil {
			h.log.Error("Error al parsear el body: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "no se pudo parsear el body",
			})
		}
		claims := c.Get("user").(jwt.MapClaims)
		sub := claims["sub"].(string)
		h.log.Debug("Usuario: ", sub)
		userId, err := uuid.Parse(sub)
		if err != nil {
			h.log.Error("Error al parsear el userId: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "userId inválido",
			})
		}
		h.log.Debug("Posteo recibido: ", posteo)
		err = h.postService.CreatePosteo(&posteo, userId.String())
		if err != nil {
			h.log.Error("Error al crear el posteo: ", err)
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"error": "no se pudo crear el posteo",
			})
		}
		h.log.Info("Posteo creado exitosamente")
		return c.JSON(http.StatusCreated, "Posteo creado exitosamente")
	}
}

func (h *PostController) GetPosteos() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("GetPosteos Entrando")
		h.log.Debug("Obteniendo posteos")
		nombre := c.QueryParams().Get("nombre")
		h.log.Debug("Modelo recibido: ", nombre)
		posteos := h.postService.GetPosteos("@" + nombre)
		h.log.Debug("Posteos encontrados: ", posteos)
		return c.JSON(http.StatusOK, posteos)
	}
}
