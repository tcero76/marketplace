package model

import "time"

type RecomendationsModels struct {
	ID         string    `gorm:"id;type:uuid;default:gen_random_uuid();primaryKey"`
	User_id    int       `gorm:"column:user_id;type:INTEGER;"`
	Model_id   int       `gorm:"column:model_id;type:INTEGER;"`
	Rating     float32   `gorm:"column:rating;type:INTEGER;"`
	Created_at time.Time `gorm:"column:created_at;type:timestamp without time zone;"`
	Updated_at time.Time `gorm:"column:updated_at;type:timestamp without time zone;"`
}

func (posts RecomendationsModels) TableName() string {
	return "marketplace.recomendationsmodels"
}
