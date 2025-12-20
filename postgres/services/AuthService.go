package services

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/tcero76/marketplace/bff-service/dto"
	logger "github.com/tcero76/marketplace/config"

	"github.com/tcero76/marketplace/postgres/model"
	"github.com/tcero76/marketplace/rabbitmq/events"

	"gorm.io/datatypes"
	"gorm.io/gorm"
)

type UserService struct {
	dbWrite *gorm.DB
	dbRead  *gorm.DB
	log     *logger.LoggerLogstash
}

func NewUserService(log *logger.LoggerLogstash, dbWrite *gorm.DB, dbRead *gorm.DB) *UserService {
	log.Info("Initializing UserService")
	return &UserService{dbWrite: dbWrite, dbRead: dbRead, log: log}
}

func (s *UserService) GetUser(username string) (*dto.UserDTO, error) {
	var user *model.User
	s.log.Info("GetUser called with username: ", username)
	err := s.dbRead.Where("nombre = ?", username).First(&user).Error
	userDTO := dto.ToUserDTO(*user)
	return &userDTO, err
}

func (s *UserService) GetUserById(userId string) (*dto.UserDTO, error) {
	s.log.Info("GetUserById called with userId: ", userId)
	var user *model.User
	err := s.dbRead.Where("user_id = ?", userId).First(&user).Error
	userDTO := dto.ToUserDTO(*user)
	return &userDTO, err
}

func (s *UserService) CreateUser(userDTO *dto.UserDTO) error {
	s.log.Info("CreateUser called with user: ", userDTO)
	user := dto.ToUser(*userDTO)
	return s.dbWrite.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(user).Error; err != nil {
			s.log.Error("Error creating user: ", err)
			return err
		}

		payloadStruct := events.EmailEvent{
			To:      user.Email,
			Subject: "Welcome to our service",
			Body:    fmt.Sprintf("Hello %s, welcome to our service!", user.Nombre),
		}
		payloadBytes, err := json.Marshal(payloadStruct)
		if err != nil {
			s.log.Error("Error marshalling payload: ", err)
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
			s.log.Error("Error creating outbox entry: ", err)
			return err
		}
		return nil
	})
}

func (s *UserService) GetUserByEmail(email string) (*dto.UserDTO, error) {
	var user model.User
	err := s.dbRead.Where("email = ?", email).First(&user).Error
	userDTO := dto.ToUserDTO(user)
	return &userDTO, err
}
