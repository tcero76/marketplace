package controller

import (
	"io"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	redis "github.com/go-redis/redis/v8"
	logConfig "github.com/tcero76/marketplace/config"
)

func selectMediaMTXNode() string {
	return "mediamtx1:8889"
}
func WhipHandler(rdb *redis.Client, log *logConfig.LoggerLogstash) gin.HandlerFunc {
	return func(c *gin.Context) {
		log.Info("Received WHIP request")

		node := selectMediaMTXNode()

		upstreamURL := "http://" + node + "/streams/whip"
		log.Infof("WHIP → node=%s from=%s", node, c.ClientIP())

		req, err := http.NewRequest(
			http.MethodPost,
			upstreamURL,
			c.Request.Body,
		)
		log.Debugf("Forwarding request to MediaMTX node: %s", upstreamURL)
		log.Debugf("Request method=%s url=%s", req.Method, req.URL)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
				"error": err.Error()})
			return
		}

		for k, v := range c.Request.Header {
			for _, vv := range v {
				req.Header.Add(k, vv)
			}
		}

		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusBadGateway, gin.H{
				"error": err.Error(),
			})
			return
		}
		defer resp.Body.Close()

		// copiar headers de respuesta
		for k, v := range resp.Header {
			if strings.EqualFold(k, "Location") {
				continue
			}
			for _, vv := range v {
				c.Writer.Header().Add(k, vv)
			}
		}

		if loc := resp.Header.Get("Location"); loc != "" {
			c.Writer.Header().Set("Location", "/whip"+loc)
		}
		log.Debugf("Response from MediaMTX node: %s", resp)

		c.Status(resp.StatusCode)

		_, err = io.Copy(c.Writer, resp.Body)
		if err != nil {
			log.Error("error copying WHIP response body: ", err)
		}
	}
}
