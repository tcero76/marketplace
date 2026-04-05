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
	log.Info("Conectado a la base de datos Postgres")

	authCacheService := redisServices.NewAuthCacheService(log)
	userServices := modelServices.NewUserService(log, dbWrite, dbRead)
	modeloService := modelServices.NewModeloService(log, dbWrite, dbRead)
	tsService := modelServices.NewTsService(log, dbWrite, dbRead)
	postService := modelServices.NewPostsService(log, dbWrite, dbRead)
	jwkService := modelServices.NewJWKService(log, dbWrite, dbRead)
	recomendationService := modelServices.NewRecomendationService(log, dbWrite, dbRead)

	cfg := hydra.NewConfiguration()
	cfg.Servers = hydra.ServerConfigurations{{URL: os.Getenv("HYDRA_ADMIN_URL")}}
	hydraAdminClient = hydra.NewAPIClient(cfg)
	googleClient := config.InitGoogleAuth()

	internalAuth := cor.NewInternalAuth(hydraAdminClient, userServices)
	googleAuth := cor.NewGoogleAuth(googleClient, userServices)
	loginHandler, consentHandler, callbackHandler := oauth2.InitOauth2Handlers(authCacheService, userServices, internalAuth, googleAuth)

	e := echo.New()

	e.Use(config.RedisSessionMiddleware(authCacheService))
	e.Use(config.LoggerMiddleware(log))

	authController := controller.NewAuthController(log)

	e.POST("/login", authController.HandleLogin(loginHandler))
	e.GET("/consent", authController.HandleConsent(consentHandler))
	e.GET("/callback", authController.HandleCallback(callbackHandler))
	e.GET("/getAuthentication", authController.AuthHandler())
	e.POST("/refresh", authController.RefreshTokenHandler(authCacheService))
	e.GET("/logout", authController.LogoutHandler(authCacheService))
	e.POST("/signup", authController.SignUpHandler(userServices))
	e.GET("/health", controller.HealthCheckHandler(log))

	protegido := e.Group("/usuario")
	protegido.Use(oauth2.JWTMiddleware())

	modeloController := controller.NewModeloController(log, modeloService)
	tsController := controller.NewTsController(log, tsService)

	postController := controller.NewPostController(log, postService)
	fileController := controller.NewFileController(log)
	jwkController := controller.NewJwksHandler(log, jwkService)
	recomendationController := controller.NewRecomendationController(log, recomendationService)

	protegido.GET("/getModelo", modeloController.GetModelo())
	protegido.GET("/getModelos", modeloController.GetModelos())
	// protegido.POST("/searchPosts", modeloController.GetSearch(log, searchService))
	protegido.GET("/getTs", tsController.GetTs())
	protegido.GET("/getTses", tsController.GetTses())
	protegido.POST("/searchTs", tsController.GetSearchTs())

	protegido.POST("/createPost", postController.CreatePosteo())
	protegido.GET("/getPosteos", postController.GetPosteos())
	e.GET("/getPosts", postController.GetPosts())

	topicService := modelServices.NewTopicsService(log, dbRead)
	topicController := controller.NewTopicsController(log, topicService)
	protegido.GET("/getTopics", topicController.GetTopics())

	protegido.GET("/getRecommendations", recomendationController.GetRecommendations())

	e.POST("/uploadImage", fileController.UploadImage())
	e.GET("/getImage/:name", fileController.GetImage())

	e.GET("/.well-known/jwks.json", jwkController.JwksHandler())
	e.POST("/token", jwkController.TokenHandler())

	e.GET("/embeded", controller.GetEmbeded(log))

	log.Info("Servidor iniciado en el puerto: ", os.Getenv("PORT"))
	e.Start(":" + os.Getenv("PORT"))
}
