package model

import "github.com/google/uuid"

type TSServicio struct {
	TSID       uuid.UUID `gorm:"type:uuid;primaryKey"`
	ServicioID int       `gorm:"primaryKey"`
	Tipo       string    `gorm:"type:text;primaryKey;check:tipo IN ('principal','adicional')"`

	TS       TS        `gorm:"foreignKey:TSID;constraint:OnDelete:CASCADE"`
	Servicio Servicios `gorm:"foreignKey:ServicioID;constraint:OnDelete:RESTRICT"`
}

func (TSServicio) TableName() string {
	return "marketplace.ts_servicios"
}
