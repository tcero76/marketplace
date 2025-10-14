package model

import (
	"github.com/google/uuid"
	"github.com/lib/pq"
)

type Posteo struct {
	ID        string         `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Texto     string         `gorm:"texto"`
	Menciones pq.StringArray `gorm:"type:text[]"`
	UserId    uuid.UUID      `gorm:"user_id;type:uuid;not null"`
}

func (posts Posteo) TableName() string {
	return "marketplace.posteos"
}
