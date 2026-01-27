package main

import (
	"context"
	"mediamtx-service/controller"
	"mediamtx-service/monitoring"
	"mediamtx-service/rds"
	"net"
	"os"
	"time"

	cache "github.com/envoyproxy/go-control-plane/pkg/cache/v3"
	"github.com/envoyproxy/go-control-plane/pkg/server/v3"
	"github.com/gin-gonic/gin"
	"github.com/prometheus/common/model"
	logConfig "github.com/tcero76/marketplace/config"
	config "github.com/tcero76/marketplace/redis/config"
	"google.golang.org/grpc"
)

func main() {
	log := logConfig.NewLoggerLogstash("🧠 Control Plane")
	log.Info("Starting MediaMTX Service...")
	rdb := config.InitRedis()
	defer rdb.Close()

	metricsCh := make(chan model.Vector, 1)
	api := monitoring.ConfigPrometheus(log)
	monitoring.GetMetrics(api,
		log,
		15*time.Second,
		`{__name__=~"node_memory_MemAvailable_bytes|paths"}`,
		metricsCh)
	go func() {
		for samples := range metricsCh {
			for _, s := range samples {
				log.Info(
					"Name: ", s.Metric["name"],
					" - instance: ", s.Metric["instance"],
					" - value: ", s.Value,
				)
			}
		}
	}()

	// xDS cache
	snapshotCache := cache.NewSnapshotCache(
		false,
		cache.IDHash{},
		nil,
	)
	xdsServer := server.NewServer(context.Background(), snapshotCache, nil)
	grpcServer := grpc.NewServer()
	rds.RegisterXDSServices(grpcServer, xdsServer)

	go func() {
		lis, err := net.Listen("tcp", ":18000")
		if err != nil {
			log.Error(err)
		}
		log.Info("📡 xDS gRPC listening on :18000")
		grpcServer.Serve(lis)
	}()

	router := gin.Default()
	router.POST("/auth/publish", controller.PublishHandler())
	router.POST("/streamready", controller.StreamReadyHandler(rdb, snapshotCache, log))
	router.POST("/whip", controller.WhipHandler(rdb, log))
	router.POST("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})
	router.Run(":" + os.Getenv("PORT"))
}
