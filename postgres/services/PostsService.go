package services

import (
	"github.com/tcero76/marketplace/bff-service/dto"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/postgres/model"

	"gorm.io/gorm"
)

type PostsService struct {
	dbWrite *gorm.DB
	dbRead  *gorm.DB
	log     *logger.LoggerLogstash
}

func NewPostsService(log *logger.LoggerLogstash, dbWrite *gorm.DB, dbRead *gorm.DB) *PostsService {
	return &PostsService{dbWrite: dbWrite, dbRead: dbRead, log: log}
}

func (c *PostsService) GetPosts(limit int, offset int) []dto.Posts {
	c.log.Info("GetPosts Entrando al servicio")
	var posts []model.Posts
	err := c.dbRead.Limit(limit).
		Offset(offset).
		Find(&posts)
	if err.Error != nil {
		c.log.Error("Error al obtener los posts: ", err.Error)
		return []dto.Posts{}
	}
	postsDTO := dto.ToPostsDTO(posts)
	return postsDTO
}

func (c *PostsService) GetTotalPosts() int64 {
	c.log.Info("GetTotalPosts Entrando al servicio")
	var total int64
	err := c.dbRead.Model(&model.Posts{}).
		Count(&total)
	if err.Error != nil {
		c.log.Error("Error al obtener el total de posts: ", err.Error)
		return 0
	}
	return total
}

func (c *PostsService) CreatePosteo(posteoDTO *dto.Posteo, userId string) error {
	c.log.Info("CreatePosteo Entrando al servicio")
	posteo := dto.ToPosteoModel(posteoDTO)
	posteo.UserId = userId
	result := c.dbWrite.Save(&posteo)
	if result.Error != nil {
		c.log.Error("Error al crear el posteo: ", result.Error)
		return result.Error
	}
	return result.Error
}

func (c *PostsService) GetPosteos(modelo string) []dto.Posteo {
	c.log.Info("GetPosteos Entrando al servicio modelo: ", modelo)
	posteos := []model.Posteo{}
	err := c.dbRead.Where("menciones @> ARRAY[?]::text[]", modelo).
		Find(&posteos)
	if err.Error != nil {
		c.log.Error("Error al obtener los posteos: ", err.Error)
		return []dto.Posteo{}
	}
	return dto.ToPosteosDTO(posteos)
}
