package config

import (
	"log"
	"os"
	"sync"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var dbInstance *gorm.DB
var once sync.Once

func GetPostgres() *gorm.DB {
	once.Do(func() {
		dsn := os.Getenv("DNS")
		db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Fatal("Error al conectar a la base de datos:", err)
		}
		log.Println("Conexión exitosa a PostgreSQL con GORM")
		dbInstance = db
	})
	return dbInstance
}
