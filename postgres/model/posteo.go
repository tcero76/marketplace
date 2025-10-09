package model

import "github.com/lib/pq"

type Posteo struct {
	ID        string         `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Texto     string         `gorm:"texto"`
	Menciones pq.StringArray `gorm:"type:text[]"`
}

func (posts Posteo) TableName() string {
	return "marketplace.posteos"
}
