package model

import (
	"time"

	"gorm.io/datatypes"
)

type Outbox struct {
	ID            uint           `gorm:"primaryKey"`
	AggregateType string         `gorm:"not null"`
	AggregateID   string         `gorm:"not null"`
	EventType     string         `gorm:"not null"`
	Payload       datatypes.JSON `gorm:"type:jsonb;not null"`
	CreatedAt     time.Time      `gorm:"autoCreateTime"`
	Processed     bool           `gorm:"default:false"`
}

func (Outbox) TableName() string {
	return "marketplace.outbox"
}
