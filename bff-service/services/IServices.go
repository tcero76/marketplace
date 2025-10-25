package services

import (
	"context"

	"github.com/tcero76/marketplace/bff-service/dto"
	dtoClickhouse "github.com/tcero76/marketplace/bff-service/dto/clickhouse"
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
	LoadTokenFromRedis(sessionID string, key string, ctx context.Context) (string, error)
	LoadSessionAll(sessionID string, ctx context.Context) (map[string]string, error)
	SaveSessionAll(sessionID string, session map[string]string, ctx context.Context) error
	GetSession(key string) (*model.SessionData, error)
	SaveSession(key string, s model.SessionData) error
}
