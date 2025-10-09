package model

import "github.com/google/uuid"

type User struct {
	UserID     uuid.UUID `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()"`
	Nombre     string    `gorm:"type:text"`
	Password   string    `gorm:"type:text"`
	Roles      string    `gorm:"type:text"`
	Avatar     string    `gorm:"type:text"`
	Provider   Provider  `gorm:"type:marketplace.oauthprovider"`
	Email      string    `gorm:"type:text"`
	IDProvider string    `gorm:"type:text"`
}

type Provider string

const (
	ProviderGoogle   Provider = "google"
	ProviderInternal Provider = "internal"
)
