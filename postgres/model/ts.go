package model

import (
	"time"

	"github.com/google/uuid"
	"github.com/lib/pq"
	"gorm.io/gorm"
)

type TS struct {
	ID                   uuid.UUID      `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()"`
	IDJob                int64          `gorm:"column:id_job;not null;index"`                        // o uint64 si prefieres
	Portal               PortalEnum     `gorm:"type:varchar(50);not null;index"`                     // ajusta el tamaño según necesites
	IDPagina             string         `gorm:"type:text;not null;uniqueIndex:uniq_portal_idpagina"` // clave compuesta más abajo
	Nombre               *string        `gorm:"type:text"`                                           // nullable
	Edad                 *int           `gorm:"default:null"`                                        // nullable
	Ciudad               *string        `gorm:"type:text"`
	Servicios            pq.StringArray `gorm:"type:text[]"`
	ServiciosAdicionales pq.StringArray `gorm:"type:text[]"`
	ScrapedAt            time.Time      `gorm:"default:current_timestamp;not null"`
	Descripcion          *string        `gorm:"type:text"`
	DeletedAt            gorm.DeletedAt `gorm:"index"`
	CreatedAt            time.Time      `gorm::default:current_timestamp;not null`
	UpdatedAt            time.Time      `gorm::default:current_timestamp;not null`
}

func (TS) TableName() string {
	return "marketplace.ts"
}

type PortalEnum string

const (
	PortalSitioA   PortalEnum = "sitioa"
	PortalSitioB   PortalEnum = "sitiob"
	PortalOnlyFans PortalEnum = "onlyfans"
)

func (t *TS) BeforeCreate(tx *gorm.DB) (err error) {
	if t.ID == uuid.Nil {
		t.ID = uuid.New()
	}
	return
}
