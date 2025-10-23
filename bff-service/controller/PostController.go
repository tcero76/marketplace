package controller

import (
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/bff-service/services"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

func GetPosts(postService services.IPostsService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("GetPosts Entrando")
		limit, err := strconv.Atoi(c.QueryParam("limit"))
		if err != nil {
			log.Error("Error al parsear limit: ", err)
			c.JSON(http.StatusBadRequest, map[string]string{
				"error": "limit inválido",
			})
		}
		offset, err := strconv.Atoi(c.QueryParam("offset"))
		if err != nil {
			log.Error("Error al parsear offset: ", err)
			c.JSON(http.StatusBadRequest, map[string]string{
				"error": "offset inválido",
			})
		}
		posts := postService.GetPosts(limit, offset)
		log.Debug("Posts encontrados: ", posts)
		total := postService.GetTotalPosts()
		log.Debug("Total de posts: ", total)
		return c.JSON(http.StatusOK, payload.PostsPage{
			Items:  posts,
			Limit:  limit,
			Offset: offset,
			Total:  total})
	}
}

func CreatePosteo(postService services.IPostsService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("Creando posteo")
		posteo := dto.Posteo{}
		if err := c.Bind(&posteo); err != nil {
			log.Error("Error al parsear el body: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "no se pudo parsear el body",
			})
		}
		claims := c.Get("user").(jwt.MapClaims)
		sub := claims["sub"].(string)
		log.Debug("Usuario: ", sub)
		userId, err := uuid.Parse(sub)
		if err != nil {
			log.Error("Error al parsear el userId: ", err)
			return c.JSON(http.StatusBadRequest, map[string]string{
				"error": "userId inválido",
			})
		}
		posteo.UserId = userId
		log.Debug("Posteo recibido: ", posteo)
		return postService.CreatePosteo(&posteo)
	}
}

func GetPosteos(postService services.IPostsService) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("GetPosteos Entrando")
		log.Debug("Obteniendo posteos")
		modelo := c.QueryParams().Get("modelo")
		log.Debug("Modelo recibido: ", modelo)
		modelos := postService.GetPosteos(modelo)
		log.Debug("Posteos encontrados: ", modelos)
		return c.JSON(http.StatusOK, modelos)
	}
}
