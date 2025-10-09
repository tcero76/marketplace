package services

import (
	"context"
	"log"

	bffServices "github.com/tcero76/marketplace/bff/services"
	"github.com/tcero76/marketplace/clickhouse/config"
	"github.com/tcero76/marketplace/clickhouse/model"

	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	dtoClickhouse "github.com/tcero76/marketplace/bff/dto/clickhouse"
)

type RecomendationService struct {
	Conn driver.Conn
}

func NewRecomendationService() bffServices.IRecomendationService {
	conn := config.GetClickhouse()
	return RecomendationService{Conn: conn}
}

func (s RecomendationService) GetRecomendations(ctx context.Context, userId string) []dtoClickhouse.Recommendation {
	rows, err := s.Conn.Query(ctx, "SELECT user_id, modelo, score FROM recomendaciones WHERE user_id = ?", userId)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	items := []model.Recommendation{}
	for rows.Next() {
		item := model.Recommendation{}
		if err := rows.Scan(&item.UserID, &item.Modelo, &item.Score); err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}
	return dtoClickhouse.ToRecommendationDTOs(items)
}
