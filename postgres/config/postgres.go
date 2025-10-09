package config

import (
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func GetPostgres() *gorm.DB {
	dsn := os.Getenv("DNS")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Error al conectar a la base de datos:", err)
	}
	log.Println("Conexión exitosa a PostgreSQL con GORM")
	return db
}
