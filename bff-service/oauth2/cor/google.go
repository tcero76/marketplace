package cor

import (
	"context"

	"github.com/tcero76/marketplace/postgres/model"

	"github.com/tcero76/marketplace/bff-service/services"

	log "github.com/sirupsen/logrus"
	"golang.org/x/oauth2"
)

type GoogleAuth struct {
	googleOauthConfig *oauth2.Config
	userServices      services.IUserService
}

func NewGoogleAuth(google1Client *oauth2.Config, userServices services.IUserService) *GoogleAuth {
	return &GoogleAuth{
		googleOauthConfig: google1Client,
		userServices:      userServices,
	}
}

func (b *GoogleAuth) Login(loginChallenge string, user *model.User, ctx context.Context) (string, error) {
	url := b.googleOauthConfig.AuthCodeURL(loginChallenge, oauth2.AccessTypeOffline)
	return url, nil
}

func (b *GoogleAuth) Consent(ctx context.Context, consentChallenge string) (string, error) {
	return "", nil
}

func (b *GoogleAuth) Callback(code string, ctx context.Context) (*oauth2.Token, error) {
	log.Info("Iniciando el proceso de autenticación con Google")
	token, err := b.googleOauthConfig.Exchange(ctx, code)
	if err != nil {
		log.Error("Error al intercambiar el código por un token:", err)
		return nil, err
	}
	return token, nil
}
