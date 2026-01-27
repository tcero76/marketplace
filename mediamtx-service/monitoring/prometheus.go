package monitoring

import (
	"context"
	"fmt"
	"time"

	"github.com/prometheus/client_golang/api"
	v1 "github.com/prometheus/client_golang/api/prometheus/v1"
	"github.com/prometheus/common/model"
	logConfig "github.com/tcero76/marketplace/config"
)

func ConfigPrometheus(log *logConfig.LoggerLogstash) v1.API {
	log.Info("Configuring Prometheus client...")
	client, err := api.NewClient(api.Config{
		Address: "http://prometheus:9090",
	})
	if err != nil {
		panic(err)
	}
	return v1.NewAPI(client)
}

func GetMetrics(api v1.API,
	log *logConfig.LoggerLogstash,
	interval time.Duration,
	query string,
	out chan<- model.Vector) {
	go func() {
		ticker := time.NewTicker(interval)
		defer ticker.Stop()
		for {
			log.Info("Getting Prometheus metrics...")
			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
			defer cancel()
			result, warnings, err := api.Query(
				ctx,
				query,
				time.Now(),
			)
			if err != nil {
				panic(err)
			}
			if len(warnings) > 0 {
				fmt.Println("Warnings:", warnings)
			}
			out <- result.(model.Vector)
			<-ticker.C
		}
	}()

}
