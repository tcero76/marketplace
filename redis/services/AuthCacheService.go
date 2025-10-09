package services

import (
	"context"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/labstack/gommon/log"
	"github.com/tcero76/marketplace/bff/services"
	"github.com/tcero76/marketplace/redis/config"
)

type AuthCacheService struct {
	Rdb *redis.Client
}

func NewAuthCacheService() services.IAuthCacheService {
	rdb := config.InitRedis()
	return &AuthCacheService{Rdb: rdb}
}

func (h *AuthCacheService) StoreTokenInRedis(sessionID string, key string, value string, ctx context.Context) error {
	log.Info("Storing in Redis: sessionID=", sessionID, " key=", key, " value=", value)
	err := h.Rdb.HSet(
		ctx,
		"session:"+sessionID,
		key, value,
	).Err()
	if err != nil {
		return err
	}
	err = h.Rdb.Expire(ctx,
		"session:"+sessionID,
		5*time.Minute).Err()
	if err != nil {
		return err
	}
	return nil
}

func (h *AuthCacheService) LoadTokenFromRedis(sessionID string, key string, ctx context.Context) (string, error) {
	log.Info("Loading from Redis: sessionID=", sessionID, " key=", key)
	data, err := h.Rdb.HGet(ctx,
		"session:"+sessionID,
		key).Result()
	if err != nil {
		return "", err
	}

	return data, nil
}

func (h *AuthCacheService) LoadSessionAll(sessionID string, ctx context.Context) (map[string]string, error) {
	log.Info("Loading all from Redis: sessionID=", sessionID)
	data, err := h.Rdb.HGetAll(ctx,
		"session:"+sessionID).Result()
	if err != nil {
		return nil, err
	}

	return data, nil
}

func (h *AuthCacheService) SaveSessionAll(sessionID string, session map[string]string, ctx context.Context) error {
	log.Info("Saving all to Redis: sessionID=", sessionID)
	return h.Rdb.HSet(ctx,
		"session:"+sessionID,
		session).Err()
}
