package controller

import (
	"mediamtx-service/rds"
	"net/http"

	cache "github.com/envoyproxy/go-control-plane/pkg/cache/v3"
	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
	logConfig "github.com/tcero76/marketplace/config"
)

type StreamEvent struct {
	Path string `json:"path"`
	Node string `json:"node"`
}

func StreamReadyHandler(rdb *redis.Client, snapshotCache cache.SnapshotCache, log *logConfig.LoggerLogstash) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()

		var evt StreamEvent

		if err := c.ShouldBindJSON(&evt); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"error": err.Error(),
			})
			return
		}
		log.Debug("Stream READY path=%s node=%s\n", evt.Path, evt.Node)

		snapshot, err := rds.BuildSnapshot(evt.Path, "mediamtx_hls_cluster")

		if err := snapshot.Consistent(); err != nil {
			log.Error(err)
			return
		}
		log.Info(" 📡 Setting new xDS snapshot for node 'envoy-media-1' ")
		err = snapshotCache.SetSnapshot(c.Request.Context(), "envoy-media-1", snapshot)
		if err != nil {
			log.Error(err)
		}
		c.JSON(http.StatusOK, gin.H{
			"status": "ok",
		})

		rdb.Set(ctx, "stream:"+evt.Path, evt.Node, 0)

		c.JSON(http.StatusOK, gin.H{"status": "stream ready received"})
	}
}
