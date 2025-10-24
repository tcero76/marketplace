package services

import (
	"context"
	"os"
	"strings"

	bffServices "github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/clickhouse/config"
	"github.com/tcero76/marketplace/clickhouse/model"

	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	log "github.com/sirupsen/logrus"
	dtoClickhouse "github.com/tcero76/marketplace/bff-service/dto/clickhouse"
	logConfig "github.com/tcero76/marketplace/config"
)

type RecomendationService struct {
	Conn driver.Conn
}

func NewRecomendationService() bffServices.IRecomendationService {
	log.Info("Iniciando RecomendationService")
	conn := config.GetClickhouse()
	if os.Getenv("PROFILE") == "prod" {
		logConfig.InitLogrus()
	} else {
		logConfig.InitDev()
	}
	return RecomendationService{Conn: conn}
}

func (s RecomendationService) GetRecomendations(ctx context.Context, userId string) []dtoClickhouse.Recommendation {
	log.Info("Getting recommendations for user: ", userId, "hasta acá.")
	if strings.TrimSpace(userId) == "" {
		log.Warn("Intento de obtener recomendaciones con userId vacío")
		return []dtoClickhouse.Recommendation{}
	}
	rows, err := s.Conn.Query(ctx, "SELECT user_id, modelo, score FROM recomendaciones WHERE user_id = ?", userId)
	if err != nil {
		log.Error("Error al obtener las recomendaciones: ", err)
	}
	defer rows.Close()
	items := []model.Recommendation{}
	for rows.Next() {
		item := model.Recommendation{}
		if err := rows.Scan(&item.UserID, &item.Modelo, &item.Score); err != nil {
			log.Error("Error al escanear la fila: ", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		log.Error("Error después de iterar las filas: ", err)
	}
	return dtoClickhouse.ToRecommendationDTOs(items)
}
