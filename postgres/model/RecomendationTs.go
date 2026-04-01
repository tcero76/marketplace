package model

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type RecommendationTS struct {
	ID        uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	UserID    uuid.UUID `gorm:"column:user_id;type:uuid;not null;index"`
	TSID      uuid.UUID `gorm:"column:ts_id;type:uuid;not null;index"`
	Rating    float32   `gorm:"column:rating;"`
	CreatedAt time.Time `gorm:"column:created_at;autoCreateTime"`
	UpdatedAt time.Time `gorm:"column:updated_at;autoUpdateTime"`
}

func (RecommendationTS) TableName() string {
	return "marketplace.recomendationsts"
}

func (r *RecommendationTS) BeforeCreate(tx *gorm.DB) (err error) {
	if r.ID == uuid.Nil {
		r.ID = uuid.New()
	}
	return nil
}
