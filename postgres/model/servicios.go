package model

import "time"

type Servicios struct {
	ID        int       `gorm:"primaryKey;autoIncrement"`
	Nombre    string    `gorm:"type:text;unique;not null"`
	CreatedAt time.Time `gorm:"default:now()"`
}

func (Servicios) TableName() string {
	return "marketplace.servicios"
}
