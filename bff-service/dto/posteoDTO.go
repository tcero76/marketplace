package dto

import (
	"github.com/google/uuid"
	"github.com/tcero76/marketplace/postgres/model"
)

type Posteo struct {
	ID        string    `json:"id"`
	Texto     string    `json:"texto"`
	Menciones []string  `json:"menciones"`
	UserId    uuid.UUID `json:"userId"`
}

func ToPosteoDTO(posteo *model.Posteo) *Posteo {
	if posteo == nil {
		return nil
	}
	return &Posteo{
		ID:        posteo.ID,
		Texto:     posteo.Texto,
		Menciones: posteo.Menciones,
		UserId:    posteo.UserId,
	}
}
func ToPosteosDTO(posteos []model.Posteo) []Posteo {
	posteoDTOs := make([]Posteo, len(posteos))
	for i, posteo := range posteos {
		posteoDTOs[i] = *ToPosteoDTO(&posteo)
	}
	return posteoDTOs
}
func ToPosteoModel(posteo *Posteo) *model.Posteo {
	if posteo == nil {
		return nil
	}
	return &model.Posteo{
		ID:        posteo.ID,
		Texto:     posteo.Texto,
		Menciones: posteo.Menciones,
		UserId:    posteo.UserId,
	}
}
func ToPosteosModel(posteos []Posteo) []model.Posteo {
	posteoModels := make([]model.Posteo, len(posteos))
	for i, posteo := range posteos {
		posteoModels[i] = *ToPosteoModel(&posteo)
	}
	return posteoModels
}
