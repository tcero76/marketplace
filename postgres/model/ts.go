package model

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type TS struct {
	ID                   uuid.UUID    `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()"`
	IDJob                int64        `gorm:"column:id_job;not null;index"`
	Portal               Portal       `gorm:"type:marketplace.portal_enum;not null;uniqueIndex:idx_portal_idpagina"`
	IDPagina             string       `gorm:"type:text;not null;uniqueIndex:uniq_portal_idpagina"`
	Nombre               *string      `gorm:"type:text"`
	Edad                 *int         `gorm:"default:null"`
	Ciudad               *string      `gorm:"type:text"`
	Servicios            []TSServicio `gorm:"foreignKey:TSID"`
	ServiciosAdicionales []TSServicio `gorm:"foreignKey:TSID"`
	// Servicios            pq.StringArray `gorm:"type:text[]"`
	// ServiciosAdicionales pq.StringArray `gorm:"type:text[]"`
	ScrapedAt   time.Time      `gorm:"default:current_timestamp;not null"`
	Descripcion *string        `gorm:"type:text"`
	DeletedAt   gorm.DeletedAt `gorm:"index"`
	CreatedAt   time.Time      `gorm::default:current_timestamp;not null`
	UpdatedAt   time.Time      `gorm::default:current_timestamp;not null`
}

func (TS) TableName() string {
	return "marketplace.ts"
}

type Portal string

const (
	PortalEstokada      Portal = "estokada"
	PortalChimbis       Portal = "chimbis"
	PortalSkokka        Portal = "skokka"
	PortalChaopescao    Portal = "chaopescao"
	PortalWenas         Portal = "wena.cl"
	PortalSexosur       Portal = "sexosur"
	PortalLaplayaescort Portal = "laplayaescort"
	PortalEscortnorte   Portal = "escortnorte"
	PortalPlanetaescort Portal = "planetaescort"
	PortalRelaxchile    Portal = "relaxchile"
)

func (t *TS) BeforeCreate(tx *gorm.DB) (err error) {
	if t.ID == uuid.Nil {
		t.ID = uuid.New()
	}
	return
}
