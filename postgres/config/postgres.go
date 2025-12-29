package config

import (
	"os"
	"sync"

	logger "github.com/tcero76/marketplace/config"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var dbWrite *gorm.DB
var dbRead *gorm.DB
var onceWrite sync.Once
var onceRead sync.Once

func GetPostgresWrite(log *logger.LoggerLogstash) *gorm.DB {
	onceWrite.Do(func() {
		dsn := os.Getenv("DNS_WRITE")
		db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Error("Error al conectar a la base de datos (write):", err)
		} else {
			log.Info("Conexión exitosa a PostgreSQL (write) con GORM")
		}
		dbWrite = db
	})
	return dbWrite
}

func GetPostgresRead(log *logger.LoggerLogstash) *gorm.DB {
	onceRead.Do(func() {
		dsn := os.Getenv("DNS_READ")
		db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Error("Error al conectar a la base de datos (read):", err)
		} else {
			log.Info("Conexión exitosa a PostgreSQL (read) con GORM")
		}
		dbRead = db
	})
	return dbRead
}
