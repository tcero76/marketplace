package dto

import (
	"github.com/google/uuid"
	"github.com/labstack/gommon/log"
	"github.com/tcero76/marketplace/postgres/model"
)

type UserDTO struct {
	UserID     uuid.UUID `json:"user_id"`
	Password   string    `json:"password"`
	Provider   string    `json:"provider"`
	Email      string    `json:"email"`
	Avatar     string    `json:"avatar"`
	Nombre     string    `json:"nombre"`
	IDProvider string    `json:"id_provider"`
	Roles      string    `json:"roles"`
}

func ToUserDTO(user model.User) UserDTO {
	var provider string
	switch user.Provider {
	case model.ProviderGoogle:
		provider = "google"
	case model.ProviderInternal:
		provider = "internal"
	default:
		log.Info("provider inválido: %s", user.Provider)
	}
	return UserDTO{
		UserID:     user.UserID,
		Nombre:     user.Nombre,
		Email:      user.Email,
		Password:   user.Password,
		Roles:      user.Roles,
		Avatar:     user.Avatar,
		Provider:   provider,
		IDProvider: user.IDProvider,
	}
}

func ToUser(userDTO UserDTO) model.User {
	var provider model.Provider
	switch userDTO.Provider {
	case "google":
		provider = model.ProviderGoogle
	case "internal":
		provider = model.ProviderInternal
	default:
		log.Info("provider inválido: %s", userDTO.Provider)
	}
	return model.User{
		UserID:     userDTO.UserID,
		Nombre:     userDTO.Nombre,
		Email:      userDTO.Email,
		Password:   userDTO.Password,
		Roles:      userDTO.Roles,
		Avatar:     userDTO.Avatar,
		Provider:   provider,
		IDProvider: userDTO.IDProvider,
	}
}
