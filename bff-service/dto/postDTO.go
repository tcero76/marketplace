package dto

import (
	"time"

	"github.com/tcero76/marketplace/postgres/model"
)

type Posts struct {
	Id            int       `json:"id"`
	IdModelos     int       `json:"id_modelos"`
	IdJob         float64   `json:"id_job"`
	Descripcion   string    `json:"descripcion"`
	Modelo        string    `json:"modelo"`
	FechaRegistro time.Time `json:"fecha_registro"`
	CreatedAt     time.Time `json:"created_at"`
	Likes         int64     `json:"likes"`
}

func ToPostDTO(post model.Posts) Posts {
	return Posts{
		Id:            post.Id,
		IdModelos:     post.IdModelos,
		IdJob:         post.IdJob,
		Descripcion:   post.Descripcion,
		Modelo:        post.Modelo,
		FechaRegistro: post.FechaRegistro,
		CreatedAt:     post.CreatedAt,
		Likes:         post.Likes,
	}
}

func ToPostsDTO(posts []model.Posts) []Posts {
	var postsDTO []Posts
	for _, post := range posts {
		postsDTO = append(postsDTO, ToPostDTO(post))
	}
	return postsDTO
}
