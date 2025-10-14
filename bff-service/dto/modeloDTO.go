package dto

import (
	"github.com/tcero76/marketplace/postgres/model"
)

type Modelo struct {
	Id          int     `json:"id"`
	IdJob       float64 `json:"id_job"`
	Modelo      string  `json:"modelo"`
	Descripcion string  `json:"descripcion"`
	createdAt   string  `json:"created_at"`
}

func ToModeloDTO(modelo *model.Modelo) *Modelo {
	return &Modelo{
		Id:          modelo.Id,
		Descripcion: modelo.Descripcion,
		Modelo:      modelo.Modelo,
	}
}

func ToModelosDTO(modelos []model.Modelo) []Modelo {
	modeloDTOs := make([]Modelo, len(modelos))
	for i, modelo := range modelos {
		modeloDTOs[i] = *ToModeloDTO(&modelo)
	}
	return modeloDTOs
}
