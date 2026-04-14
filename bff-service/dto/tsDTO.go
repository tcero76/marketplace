package dto

import (
	"time"

	"github.com/lib/pq"
	"github.com/tcero76/marketplace/postgres/model"
)

type Ts struct {
	ID                   string         `json:"id,omitempty"`
	IDJob                int64          `json:"id_job,omitempty"`
	Portal               model.Portal   `json:"portal,omitempty"`
	IDPagina             string         `json:"idpagina,omitempty"`
	Nombre               *string        `json:"nombre,omitempty"`
	Edad                 *int           `json:"edad,omitempty"`
	Ciudad               *string        `json:"ciudad,omitempty"`
	Servicios            pq.StringArray `json:"servicios,omitempty"`
	ServiciosAdicionales pq.StringArray `json:"serviciosAdicionales,omitempty"`
	Descripcion          *string        `json:"descripcion,omitempty"`
	CreatedAt            time.Time      `json:"created_at,omitempty"`
}

func ToTsDTO(ts *model.TS) *Ts {
	dto := &Ts{
		ID:          ts.ID.String(),
		IDJob:       ts.IDJob,
		Portal:      ts.Portal,
		IDPagina:    ts.IDPagina,
		Nombre:      ts.Nombre,
		Edad:        ts.Edad,
		Ciudad:      ts.Ciudad,
		Descripcion: ts.Descripcion,
		CreatedAt:   ts.CreatedAt,
	}

	var servicios []string
	var adicionales []string

	for _, rel := range ts.Servicios {
		if rel.Servicio.Nombre == "" {
			continue
		}

		if rel.Tipo == "principal" {
			servicios = append(servicios, rel.Servicio.Nombre)
		} else if rel.Tipo == "adicional" {
			adicionales = append(adicionales, rel.Servicio.Nombre)
		}
	}

	dto.Servicios = servicios
	dto.ServiciosAdicionales = adicionales

	return dto
}

func ToTsesDTO(tses []model.TS) []Ts {
	tsDTOs := make([]Ts, len(tses))
	for i, ts := range tses {
		tsDTOs[i] = *ToTsDTO(&ts)
	}
	return tsDTOs
}
