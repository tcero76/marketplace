package main

import (
	"context"
	"os"

	"github.com/tcero76/marketplace/bff-service/config"
	"github.com/tcero76/marketplace/bff-service/controller"
	logConfig "github.com/tcero76/marketplace/config"

	"github.com/tcero76/marketplace/bff-service/oauth2"
	"github.com/tcero76/marketplace/bff-service/oauth2/cor"
	postgresConfig "github.com/tcero76/marketplace/postgres/config"
	modelServices "github.com/tcero76/marketplace/postgres/services"
	redisServices "github.com/tcero76/marketplace/redis/services"

	"github.com/labstack/echo/v4"
	hydra "github.com/ory/hydra-client-go/v2"
)

var hydraAdminClient *hydra.APIClient

var ctx = context.Background()

func main() {
	log := logConfig.NewLoggerLogstash("🗄️  BFF")
	log.Info("Iniciando servidor...")

	dbRead := postgresConfig.GetPostgresRead(log)
	dbWrite := postgresConfig.GetPostgresWrite(log)

	authCacheService := redisServices.NewAuthCacheService(log)
	userServices := modelServices.NewUserService(log, dbWrite, dbRead)
	modeloService := modelServices.NewModeloService(log, dbWrite, dbRead)
	postService := modelServices.NewPostsService(log, dbWrite, dbRead)
	searchService := modelServices.NewSearchService(log, dbRead)

	cfg := hydra.NewConfiguration()
	cfg.Servers = hydra.ServerConfigurations{{URL: os.Getenv("HYDRA_ADMIN_URL")}}
	hydraAdminClient = hydra.NewAPIClient(cfg)
	googleClient := config.InitGoogleAuth()

	internalAuth := cor.NewInternalAuth(hydraAdminClient, userServices)
	googleAuth := cor.NewGoogleAuth(googleClient, userServices)
	loginHandler, consentHandler, callbackHandler := oauth2.InitOauth2Handlers(authCacheService, userServices, internalAuth, googleAuth)

	// recomendationService := clickServices.NewRecomendationService()
	e := echo.New()

	e.Use(config.RedisSessionMiddleware(authCacheService))
	e.Use(config.LoggerMiddleware(log))

	e.POST("/login", controller.HandleLogin(loginHandler))
	e.GET("/consent", controller.HandleConsent(consentHandler))
	e.GET("/callback", controller.HandleCallback(callbackHandler))
	e.GET("/getAuthentication", controller.AuthHandler)
	e.POST("/refresh", controller.RefreshTokenHandler(authCacheService))
	e.GET("/logout", controller.LogoutHandler(authCacheService))
	e.POST("/signup", controller.SignUpHandler(userServices))
	e.GET("/health", controller.HealthCheckHandler(log))

	protegido := e.Group("/usuario")
	protegido.Use(oauth2.JWTMiddleware())
	// protegido.GET("/getRecommendations", controller.GetRecommendations(recomendationService))
	protegido.GET("/getModelo", controller.GetModelo(modeloService))
	protegido.GET("/getModelos", controller.GetModelos(modeloService))
	protegido.POST("/searchPosts", controller.GetSearch(searchService))
	protegido.POST("/createPost", controller.CreatePosteo(postService))
	protegido.GET("/getPosteos", controller.GetPosteos(postService))
	e.GET("/getPosts", controller.GetPosts(postService))

	log.Info("Servidor iniciado en el puerto: ", os.Getenv("PORT"))
	e.Start(":" + os.Getenv("PORT"))
}
