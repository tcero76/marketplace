package services

import (
	"crypto/rand"
	"crypto/rsa"
	"encoding/json"
	"errors"
	"time"

	"github.com/lestrrat-go/jwx/jwk"
	logger "github.com/tcero76/marketplace/config"
	"gorm.io/gorm"
)

type JWSService struct {
	dbWrite *gorm.DB
	dbRead  *gorm.DB
	log     *logger.LoggerLogstash
}

type JWK struct {
	Kid            string    `gorm:"primaryKey;column:kid"`
	Kty            string    `gorm:"column:kty;not null"`
	Alg            string    `gorm:"column:alg;not null"`
	Use            string    `gorm:"column:use;not null"`
	PrivateJWKJSON []byte    `gorm:"column:private_jwk;type:jsonb;not null"`
	PublicJWKJSON  []byte    `gorm:"column:public_jwk;type:jsonb;not null"`
	CreatedAt      time.Time `gorm:"column:created_at;not null"`
	ExpiresAt      time.Time `gorm:"column:expires_at"`
}

func (JWK) TableName() string {
	return "marketplace.jwk_keys"
}

func NewJWKService(log *logger.LoggerLogstash, dbWrite *gorm.DB, dbRead *gorm.DB) *JWSService {
	return &JWSService{
		dbWrite: dbWrite,
		dbRead:  dbRead,
		log:     log}
}

func (j *JWSService) createJWK() (JWK, error) {
	j.log.Info("Creando nueva JWK...")
	var privateJWKJSON, publicJWKJSON = createJWKSet(j.log)
	now := time.Now()
	var jwk = JWK{
		Kid:            "mediamtx-demo-key",
		Kty:            "RSA",
		Alg:            "RS256",
		Use:            "sig",
		PrivateJWKJSON: privateJWKJSON,
		PublicJWKJSON:  publicJWKJSON,
		CreatedAt:      now,
		ExpiresAt:      now.Add(365 * 24 * time.Hour),
	}

	if err := j.dbWrite.Create(&jwk).Error; err != nil {
		return JWK{}, err
	}
	return jwk, nil
}

func (j *JWSService) GetKeys() (*rsa.PrivateKey, *jwk.Set, error) {
	var jwkDB JWK

	err := j.dbRead.First(&jwkDB, "kid = ?", "mediamtx-demo-key").Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		jwkDB, err = j.createJWK()
	}
	if err != nil {
		return nil, nil, err
	}

	if len(jwkDB.PrivateJWKJSON) == 0 {
		return nil, nil, errors.New("private JWK is empty")
	}

	// Parse JWK
	key, err := jwk.ParseKey(jwkDB.PrivateJWKJSON)
	if err != nil {
		return nil, nil, err
	}

	var rsaPrivateKey rsa.PrivateKey
	if err := key.Raw(&rsaPrivateKey); err != nil {
		return nil, nil, err
	}

	// Crear JWK público
	publicKey, err := jwk.New(&rsaPrivateKey.PublicKey)
	if err != nil {
		return nil, nil, err
	}

	publicKey.Set(jwk.KeyIDKey, jwkDB.Kid)
	publicKey.Set(jwk.AlgorithmKey, jwkDB.Alg)
	publicKey.Set(jwk.KeyUsageKey, jwkDB.Use)

	jwkSet := jwk.NewSet()
	jwkSet.Add(publicKey)

	return &rsaPrivateKey, &jwkSet, nil
}

func createJWKSet(log *logger.LoggerLogstash) ([]byte, []byte) {
	// Genera una llave RSA de 2048 bits
	rsaPrivateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		log.Error("Error generando RSA key: %v", err)
	}

	// Convierte a JWK y crea un JWKS
	key, err := jwk.New(&rsaPrivateKey.PublicKey)
	if err != nil {
		log.Error("Error creando JWK: %v", err)
	}

	// Asignamos un kid (identificador)
	key.Set(jwk.KeyIDKey, "mediamtx-demo-key")
	jwkSet := jwk.NewSet()
	jwkSet.Add(key)

	// Convertir la llave privada a JWK
	privateJWK, err := jwk.New(rsaPrivateKey)
	if err != nil {
		log.Error("Error creando private JWK: %v", err)
	}
	privateJWK.Set(jwk.KeyIDKey, "mediamtx-demo-key")
	privateJWKJSON, _ := json.Marshal(privateJWK)

	// Convertir la llave pública a JWK
	publicJWK, err := jwk.New(&rsaPrivateKey.PublicKey)
	if err != nil {
		log.Error("Error creando public JWK: %v", err)
	}
	publicJWK.Set(jwk.KeyIDKey, "mediamtx-demo-key")
	publicJWKJSON, _ := json.Marshal(publicJWK)

	return privateJWKJSON, publicJWKJSON

}
