package services

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/tcero76/marketplace/bff/dto"
	"github.com/tcero76/marketplace/bff/services"

	"github.com/tcero76/marketplace/postgres/config"
	"github.com/tcero76/marketplace/postgres/model"
	"github.com/tcero76/marketplace/rabbitmq/events"

	"github.com/labstack/gommon/log"
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

type UserService struct {
	DB *gorm.DB
}

func NewUserService() services.IUserService {
	db := config.GetPostgres()
	return &UserService{DB: db}
}

func (s *UserService) GetUser(username string) (*dto.UserDTO, error) {
	var user *model.User
	log.Info("GetUser called with username: ", username)
	err := s.DB.Where("nombre = ?", username).First(&user).Error
	userDTO := dto.ToUserDTO(*user)
	return &userDTO, err
}

func (s *UserService) GetUserById(userId string) (*dto.UserDTO, error) {
	log.Info("GetUserById called with userId: ", userId)
	var user *model.User
	err := s.DB.Where("user_id = ?", userId).First(&user).Error
	userDTO := dto.ToUserDTO(*user)
	return &userDTO, err
}

func (s *UserService) CreateUser(userDTO *dto.UserDTO) error {
	log.Info("CreateUser called with user: ", userDTO)
	user := dto.ToUser(*userDTO)
	return s.DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(user).Error; err != nil {
			log.Error("Error creating user: ", err)
			return err
		}

		payloadStruct := events.EmailEvent{
			To:      user.Email,
			Subject: "Welcome to our service",
			Body:    fmt.Sprintf("Hello %s, welcome to our service!", user.Nombre),
		}
		payloadBytes, err := json.Marshal(payloadStruct)
		if err != nil {
			log.Error("Error marshalling payload: ", err)
			return err
		}
		outbox := model.Outbox{
			AggregateType: "user",
			AggregateID:   fmt.Sprintf("%d", user.UserID),
			EventType:     "UserCreated",
			Payload:       datatypes.JSON(payloadBytes),
			CreatedAt:     time.Now(),
			Processed:     false,
		}
		if err := tx.Create(&outbox).Error; err != nil {
			log.Error("Error creating outbox entry: ", err)
			return err
		}
		return nil
	})
}

func (s *UserService) GetUserByEmail(email string) (*dto.UserDTO, error) {
	var user model.User
	err := s.DB.Where("email = ?", email).First(&user).Error
	userDTO := dto.ToUserDTO(user)
	return &userDTO, err
}
