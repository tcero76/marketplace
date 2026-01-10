package model

import "github.com/google/uuid"

type InternalUser struct {
	ID            uuid.UUID `json:"id"`
	Email         string    `json:"email"`
	VerifiedEmail bool      `json:"verified_email"`
	Name          string    `json:"name"`
	GivenName     string    `json:"given_name"`
	FamilyName    string    `json:"family_name"`
	Picture       string    `json:"picture"`
}
