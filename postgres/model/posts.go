package model

import "time"

type Posts struct {
	Id            int       `gorm:"column:id;type:INTEGER;primaryKey;"`
	IdModelos     int       `gorm:"column:id_modelos;type:INTEGER;"`
	IdJob         float64   `gorm:"column:id_job;type:DOUBLE PRECISION;"`
	Descripcion   string    `gorm:"column:descripcion;type:TEXT"`
	Modelo        string    `gorm:"column:modelo;type:VARCHAR(125);"`
	FechaRegistro time.Time `gorm:"column:fecharegistro;type:timestamp without time zone;"`
	CreatedAt     time.Time `gorm:"column:created_at;type:timestamp without time zone;"`
	Likes         int64     `gorm:"column:likes;type:INTEGER;"`
}

func (posts Posts) TableName() string {
	return "marketplace.posts"
}
