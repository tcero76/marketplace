package services

import (
	"context"
	"fmt"
	"time"

	"github.com/fatih/structs"
	"github.com/go-redis/redis/v8"
	logger "github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/redis/config"
	"github.com/tcero76/marketplace/redis/model"
)

type AuthCacheService struct {
	Rdb *redis.Client
	log *logger.LoggerLogstash
}

func NewAuthCacheService(log *logger.LoggerLogstash) *AuthCacheService {
	log.Info("Initializing AuthCacheService")
	rdb := config.InitRedis()
	return &AuthCacheService{Rdb: rdb, log: log}
}

func (h *AuthCacheService) SaveSession(key string, s model.SessionData, ctx context.Context) error {
	h.log.FromContext(ctx).Info("Saving session to Redis")
	h.log.FromContext(ctx).Info("SaveSession arg Key =", key)
	if key == "" {
		h.log.FromContext(ctx).Error("Error: key is empty")
		return nil
	}
	st := structs.New(s)
	st.TagName = "redis"
	data := st.Map()
	err := h.Rdb.HSet(context.Background(), "session:"+key, data).Err()
	if err != nil {
		h.log.FromContext(ctx).Error("Error saving session to Redis: ", err)
	}
	return err
}

func (h *AuthCacheService) GetSession(key string, ctx context.Context) (*model.SessionData, error) {
	h.log.FromContext(ctx).Info("Getting session from Redis")
	h.log.FromContext(ctx).Info("GetSession arg Key =", key)
	m, err := h.Rdb.HGetAll(context.Background(), "session:"+key).Result()
	if err != nil {
		h.log.FromContext(ctx).Error("Error getting session from Redis: ", err)
		return nil, err
	}
	if len(m) == 0 {
		return nil, fmt.Errorf("no session found for key: %s", key)
	}
	s := &model.SessionData{
		AccessToken:     m["access_token"],
		RefreshToken:    m["refresh_token"],
		UserID:          m["user_id"],
		Idp:             m["idp"],
		SessionID:       m["session_id"],
		LoginChallenge:  m["login_challenge"],
		IsAuthenticated: m["is_authenticated"] == "true",
	}
	return s, nil
}

func (h *AuthCacheService) StoreTokenInRedis(sessionID string, key string, value string, ctx context.Context) error {
	h.log.Info("Storing in Redis")
	h.log.Debug("sessionID=", sessionID, " key=", key, " value=", value)
	err := h.Rdb.HSet(
		ctx,
		"session:"+sessionID,
		key, value,
	).Err()
	if err != nil {
		h.log.Error("Error storing in Redis: ", err)
		return err
	}
	err = h.Rdb.Expire(ctx,
		"session:"+sessionID,
		720*time.Hour).Err()
	if err != nil {
		h.log.Error("Error setting expiration in Redis: ", err)
		return err
	}
	return nil
}

func (h *AuthCacheService) LoadTokenFromRedis(sessionID string, key string, ctx context.Context) (string, error) {
	h.log.Info("Loading from Redis: sessionID=", sessionID, " key=", key)
	data, err := h.Rdb.HGet(ctx,
		"session:"+sessionID,
		key).Result()
	if err != nil {
		h.log.Error("Error loading from Redis: ", err)
		return "", err
	}

	return data, nil
}

func (h *AuthCacheService) LoadSessionAll(sessionID string, ctx context.Context) (map[string]string, error) {
	h.log.Info("Loading all from Redis: sessionID=", sessionID)
	data, err := h.Rdb.HGetAll(ctx, "session:"+sessionID).Result()
	if err != nil {
		h.log.Error("Error loading all from Redis: ", err)
		return nil, err
	}
	return data, nil
}

func (h *AuthCacheService) SaveSessionAll(sessionID string, session map[string]string, ctx context.Context) error {
	h.log.Info("Saving all to Redis: sessionID=", sessionID)
	err := h.Rdb.HSet(ctx,
		"session:"+sessionID,
		session).Err()
	if err != nil {
		h.log.Error("Error saving all to Redis: ", err)
	}
	return err
}
