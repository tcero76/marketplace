package main

import (
	"mediamtx-service/controller"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.POST("/auth/publish", controller.PublishHandler())
	router.Run(":" + os.Getenv("PORT"))
}
