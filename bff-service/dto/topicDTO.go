package dto

import "github.com/tcero76/marketplace/postgres/model"

type Topic struct {
	Nombre string `json:"nombre"`
}

func ServicioToTopic(servicio model.Servicios) Topic {
	return Topic{Nombre: servicio.Nombre}
}

func ServiciosToTopics(servicios []model.Servicios) []Topic {
	topics := make([]Topic, len(servicios))
	for i, servicio := range servicios {
		topics[i] = ServicioToTopic(servicio)
	}
	return topics
}
