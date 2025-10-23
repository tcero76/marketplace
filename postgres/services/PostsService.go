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
	var posts []model.Posts
	c.DB.Limit(limit).
		Offset(offset).
		Find(&posts)
	postsDTO := dto.ToPostsDTO(posts)
	return postsDTO
}

func (c *PostsService) GetTotalPosts() int64 {
	var total int64
	c.DB.Model(&model.Posts{}).
		Count(&total)
	return total
}

func (c *PostsService) CreatePosteo(posteoDTO *dto.Posteo) error {
	posteo := dto.ToPosteoModel(posteoDTO)
	result := c.DB.Save(&posteo)
	return result.Error
}

func (c *PostsService) GetPosteos(modelo string) []dto.Posteo {
	log.Info("GetPosteos Entrando al servicio modelo: ", modelo)
	posteos := []model.Posteo{}
	c.DB.Debug().Where("menciones @> ARRAY[?]::text[]", "#"+modelo).
		Find(&posteos)
	return dto.ToPosteosDTO(posteos)
}
