package dto

import (
	"github.com/tcero76/marketplace/postgres/model"
)

type Metadata struct {
	Hashtags []string `json:"hashtags,omitempty"`
	Mentions []string `json:"mentions,omitempty"`
	Urls     []string `json:"urls,omitempty"`
}

type Posteo struct {
	ID       string   `json:"id,omitempty"`
	Texto    string   `json:"texto"`
	Metadata Metadata `json:"meta"`
}

func ToPosteoDTO(posteo *model.Posteo) *Posteo {
	if posteo == nil {
		return nil
	}
	metadata := Metadata{Mentions: posteo.Menciones}
	return &Posteo{
		ID:       posteo.ID,
		Texto:    posteo.Texto,
		Metadata: metadata,
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
		Menciones: posteo.Metadata.Mentions,
	}
}
func ToPosteosModel(posteos []Posteo) []model.Posteo {
	posteoModels := make([]model.Posteo, len(posteos))
	for i, posteo := range posteos {
		posteoModels[i] = *ToPosteoModel(&posteo)
	}
	return posteoModels
}
