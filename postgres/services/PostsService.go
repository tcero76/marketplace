package services

import (
	log "github.com/sirupsen/logrus"
	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/postgres/config"
	"github.com/tcero76/marketplace/postgres/model"

	"gorm.io/gorm"
)

type PostsService struct {
	DB *gorm.DB
}

func NewPostsService() services.IPostsService {
	db := config.GetPostgres()
	return &PostsService{DB: db}
}

func (c *PostsService) GetPosts(limit int, offset int) []dto.Posts {
	log.Info("GetPosts Entrando al servicio")
	var posts []model.Posts
	err := c.DB.Limit(limit).
		Offset(offset).
		Find(&posts)
	if err.Error != nil {
		log.Error("Error al obtener los posts: ", err.Error)
		return []dto.Posts{}
	}
	postsDTO := dto.ToPostsDTO(posts)
	return postsDTO
}

func (c *PostsService) GetTotalPosts() int64 {
	log.Info("GetTotalPosts Entrando al servicio")
	var total int64
	err := c.DB.Model(&model.Posts{}).
		Count(&total)
	if err.Error != nil {
		log.Error("Error al obtener el total de posts: ", err.Error)
		return 0
	}
	return total
}

func (c *PostsService) CreatePosteo(posteoDTO *dto.Posteo) error {
	log.Info("CreatePosteo Entrando al servicio")
	posteo := dto.ToPosteoModel(posteoDTO)
	result := c.DB.Save(&posteo)
	if result.Error != nil {
		log.Error("Error al crear el posteo: ", result.Error)
	}
	return result.Error
}

func (c *PostsService) GetPosteos(modelo string) []dto.Posteo {
	log.Info("GetPosteos Entrando al servicio modelo: ", modelo)
	posteos := []model.Posteo{}
	err := c.DB.Debug().Where("menciones @> ARRAY[?]::text[]", "#"+modelo).
		Find(&posteos)
	if err.Error != nil {
		log.Error("Error al obtener los posteos: ", err.Error)
		return []dto.Posteo{}
	}
	return dto.ToPosteosDTO(posteos)
}
