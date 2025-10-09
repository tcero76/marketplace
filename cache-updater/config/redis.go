package config

import (
	"github.com/redis/go-redis/v9"
	log "github.com/sirupsen/logrus"
)

func InitRedis() *redis.Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     "cache:6379",
		Password: "",
		DB:       0,
	})
	log.Info("Conectado a Redis en cache:6379")
	return rdb
}
