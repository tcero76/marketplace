package services

import (
	"testing"

	"github.com/joho/godotenv"
	log "github.com/sirupsen/logrus"
	"github.com/tcero76/marketplace/config"
	"github.com/tcero76/marketplace/redis/model"
	"github.com/tcero76/marketplace/redis/services"
)

func TestSaveSession(t *testing.T) {
	_ = godotenv.Load("~/.environments/marketplace.env")
	authCacheService := services.NewAuthCacheService()
	var sessionData = &model.SessionData{
		SessionID:       "test_session",
		UserID:          "user_123",
		IsAuthenticated: true,
	}
	authCacheService.SaveSession("test_session", *sessionData)

}

func TestGetSession(t *testing.T) {
	log.Info("Starting TestGetSession")
	// _ = godotenv.Load("~/.environments/marketplace.env")
	authCacheService := services.NewAuthCacheService()
	config.InitDev()
	sessionData, err := authCacheService.GetSession("session:test_session")
	log.Info("Session Data: ", sessionData)
	if err != nil {
		t.Error("Error getting session: ", err)
	}
	if sessionData.SessionID != "test_session" {
		t.Error("Expected session ID 'test_session', got: ", sessionData.SessionID)
	}
}
