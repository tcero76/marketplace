package config

import (
	"os"
	"sync"

	logger "github.com/tcero76/marketplace/config"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var dbInstance *gorm.DB
var once sync.Once

func GetPostgres(log *logger.LoggerLogstash) *gorm.DB {
	once.Do(func() {
		dsn := os.Getenv("DNS")
		db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Error("Error al conectar a la base de datos:", err)
		}
		log.Info("Conexión exitosa a PostgreSQL con GORM")
		dbInstance = db
	})
	return dbInstance
}
