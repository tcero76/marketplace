package dto

import (
	"github.com/tcero76/marketplace/postgres/model"
)

type Hashtag struct {
	id     string `json:"id"`
	Nombre string `json:"nombre"`
}

type Mentions struct {
	id     string `json:"id"`
	Nombre string `json:"nombre"`
}

type Metadata struct {
	Hashtags []Hashtag  `json:"hashtags,omitempty"`
	Mentions []Mentions `json:"mentions,omitempty"`
	Urls     []string   `json:"urls,omitempty"`
}

type Posteo struct {
	ID       string   `json:"id,omitempty"`
	Texto    string   `json:"texto"`
	Metadata Metadata `json:"meta"`
	UserId   string   `json:"userId,omitempty"`
}

func ToPosteoDTO(posteo *model.Posteo) *Posteo {
	if posteo == nil {
		return nil
	}
	var menciones []Mentions
	for _, m := range posteo.Menciones {
		menciones = append(menciones, Mentions{
			Nombre: m,
		})
	}
	metadata := Metadata{Mentions: menciones}
	return &Posteo{
		ID:       posteo.ID,
		Texto:    posteo.Texto,
		Metadata: metadata,
		UserId:   posteo.UserId.String(),
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
	var mentions = make([]string, len(posteo.Metadata.Mentions))
	for i, m := range posteo.Metadata.Mentions {
		mentions[i] = m.Nombre
	}
	return &model.Posteo{
		ID:        posteo.ID,
		Texto:     posteo.Texto,
		Menciones: mentions,
	}
}
func ToPosteosModel(posteos []Posteo) []model.Posteo {
	posteoModels := make([]model.Posteo, len(posteos))
	for i, posteo := range posteos {
		posteoModels[i] = *ToPosteoModel(&posteo)
	}
	return posteoModels
}
