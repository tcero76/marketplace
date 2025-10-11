package services

import (
	"context"

	"github.com/tcero76/marketplace/bff/dto"
	dtoClickhouse "github.com/tcero76/marketplace/bff/dto/clickhouse"
	"github.com/tcero76/marketplace/bff/payload"
)

type IUserService interface {
	GetUser(username string) (*dto.UserDTO, error)
	GetUserById(userId string) (*dto.UserDTO, error)
	CreateUser(userDTO *dto.UserDTO) error
	GetUserByEmail(email string) (*dto.UserDTO, error)
}

type IModeloService interface {
	GetModelByModelo(query string) (*dto.Modelo, error)
	GetSearch(text []string) (*[]dto.Modelo, error)
	GetModelos() []dto.Modelo
}

type IPostsService interface {
	GetPosts(limit int, offset int) []dto.Posts
	GetTotalPosts() int64
	CreatePosteo(posteo *dto.Posteo) error
	GetPosteos(modelo string) []dto.Posteo
}

type ISearchService interface {
	GetSearch(searchRequest payload.SearchRequest) []dto.SearchDTO
}

type IRecomendationService interface {
	GetRecomendations(ctx context.Context, userId string) []dtoClickhouse.Recommendation
}

type IAuthCacheService interface {
	StoreTokenInRedis(sessionID string, key string, value string, ctx context.Context) error
	LoadTokenFromRedis(sessionID string, key string, ctx context.Context) (string, error)
	LoadSessionAll(sessionID string, ctx context.Context) (map[string]string, error)
	SaveSessionAll(sessionID string, session map[string]string, ctx context.Context) error
}
