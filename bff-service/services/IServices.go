package services

import (
	"context"
	"crypto/rsa"

	"github.com/lestrrat-go/jwx/jwk"
	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/payload"
	"github.com/tcero76/marketplace/redis/model"
)

type IUserService interface {
	GetUser(username string) (*dto.UserDTO, error)
	GetUserById(userId string) (*dto.UserDTO, error)
	CreateUser(userDTO *dto.UserDTO) error
	GetUserByEmail(email string) (*dto.UserDTO, error)
}

type IModeloService interface {
	GetModelByModelo(query string) (*dto.Modelo, error)
	GetModelos() []dto.Modelo
	GetSearch(searchRequest payload.SearchRequest) []dto.SearchDTO
}

type ITsService interface {
	GetTs(query string) (*dto.Ts, error)
	GetTses() ([]dto.Ts, error)
	GetSearchTs(searchRequest payload.SearchRequest) []dto.IdxDTO
}

type IRecomendationService interface {
	GetRecomendationsTs(ctx context.Context, userId string) []dto.IdxDTO
}

type IPostsService interface {
	GetPosts(limit int, offset int) []dto.Posts
	GetTotalPosts() int64
	CreatePosteo(posteo *dto.Posteo) error
	GetPosteos(modelo string) []dto.Posteo
}

type IAuthCacheService interface {
	LoadTokenFromRedis(sessionID string, key string, ctx context.Context) (string, error)
	GetSession(key string, ctx context.Context) (*model.SessionData, error)
	SaveSession(key string, s model.SessionData, ctx context.Context) error
}

type IJWKService interface {
	GetKeys() (*rsa.PrivateKey, *jwk.Set, error)
}
