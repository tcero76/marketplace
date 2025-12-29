package main

import (
	"context"
	"mediamtx-service/controller"
	"mediamtx-service/rds"
	"net"
	"os"

	cache "github.com/envoyproxy/go-control-plane/pkg/cache/v3"
	"github.com/envoyproxy/go-control-plane/pkg/server/v3"
	"github.com/gin-gonic/gin"
	logConfig "github.com/tcero76/marketplace/config"
	config "github.com/tcero76/marketplace/redis/config"
	"google.golang.org/grpc"
)

func main() {
	log := logConfig.NewLoggerLogstash("🧠 Control Plane")
	log.Info("Starting MediaMTX Service...")
	rdb := config.InitRedis()
	defer rdb.Close()

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
	router.Run(":" + os.Getenv("PORT"))
}
