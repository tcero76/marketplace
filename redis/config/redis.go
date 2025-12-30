package config

import (
	"context"
	"os"
	"time"

	"github.com/go-redis/redis/v8"
	logConfig "github.com/tcero76/marketplace/config"
)

func InitRedis() *redis.Client {
	log := logConfig.NewLoggerLogstash("🗄️ Redis")
	addr := os.Getenv("REDIS_HOST") + ":6379"
	log.Info("Connecting to Redis at " + addr)
	rdb := redis.NewClient(&redis.Options{
		Addr: addr,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := rdb.Ping(ctx).Err(); err != nil {
		log.Error("❌ Redis connection failed: " + err.Error())
		return nil
	}

	log.Info("✅ Redis connected successfully at " + addr)
	return rdb
}
