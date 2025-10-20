package cor

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/tcero76/marketplace/bff-service/dto"
	"github.com/tcero76/marketplace/bff-service/services"
	"github.com/tcero76/marketplace/postgres/model"

	hydra "github.com/ory/hydra-client-go/v2"
	"golang.org/x/oauth2"
)

const (
	passwordLength = 16
	charset        = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}<>?,."
)

type AuthHandler interface {
	Login(loginChallenge string, user *model.User, ctx context.Context) (string, error)
	Consent(ctx context.Context, consentChallenge string) (string, error)
	Callback(code string, ctx context.Context) (*oauth2.Token, error)
}

type InternalAuth struct {
	hydraAdminClient *hydra.APIClient
	userServices     services.IUserService
}

func NewInternalAuth(hydraAdminClient *hydra.APIClient, userServices services.IUserService) *InternalAuth {
	return &InternalAuth{
		hydraAdminClient: hydraAdminClient,
		userServices:     userServices,
	}
}

func (b *InternalAuth) Login(loginChallenge string, user *dto.UserDTO, ctx context.Context) (string, error) {
	acceptBody := hydra.AcceptOAuth2LoginRequest{
		Subject: user.UserID.String(),
	}
	resp, _, err := b.hydraAdminClient.OAuth2API.AcceptOAuth2LoginRequest(ctx).
		LoginChallenge(loginChallenge).
		AcceptOAuth2LoginRequest(acceptBody).
		Execute()
	if err != nil {
		return "", err
	}
	return resp.GetRedirectTo(), nil
}

func (b *InternalAuth) Consent(ctx context.Context, consentChallenge string) (string, error) {
	consentRequest, _, err := b.hydraAdminClient.OAuth2API.
		GetOAuth2ConsentRequest(ctx).
		ConsentChallenge(consentChallenge).
		Execute()
	if err != nil {
		fmt.Printf("Error getting consent request: %v\n", err)
		return "", err
	}
	userDTO, err := b.userServices.GetUserById(*consentRequest.Subject)
	if err != nil {
		log.Printf("Error fetching user by ID: %v\n", err)
		return "", err
	}
	acceptConsentBody := hydra.AcceptOAuth2ConsentRequest{
		GrantScope: consentRequest.GetRequestedScope(),
		Session: &hydra.AcceptOAuth2ConsentRequestSession{
			AccessToken: map[string]interface{}{
				"name":   userDTO.Nombre,
				"avatar": userDTO.Avatar,
			},
		},
		Remember:    b.boolPtr(true),
		RememberFor: b.int64Ptr(3600),
	}
	resp, _, err := b.hydraAdminClient.OAuth2API.
		AcceptOAuth2ConsentRequest(ctx).
		ConsentChallenge(consentChallenge).
		AcceptOAuth2ConsentRequest(acceptConsentBody).
		Execute()
	if err != nil {
		fmt.Printf("Error accepting consent request: %v\n", err)
		return "", err
	}

	return resp.GetRedirectTo(), nil
}

func (b *InternalAuth) Callback(code string, ctx context.Context) *oauth2.Token {
	var redirect = "http://" + os.Getenv("HOST_EXTERNAL") + ":" + os.Getenv("PORT_EXTERNAL") + os.Getenv("RedirectURL")
	conf := &oauth2.Config{
		ClientID:     os.Getenv("CLIENT_ID"),
		ClientSecret: os.Getenv("CLIENT_SECRET"),
		RedirectURL:  redirect,
		Endpoint: oauth2.Endpoint{
			AuthURL:  os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/auth",
			TokenURL: os.Getenv("HYDRA_PUBLIC_URL") + "/oauth2/token",
		},
		Scopes: []string{"openid", "offline"},
	}

	token, err := conf.Exchange(ctx, code)
	if err != nil {
		log.Fatalf("Error intercambiando código por token: %v", err)
	}
	return token
}

func (b *InternalAuth) boolPtr(boolean bool) *bool {
	return &boolean
}
func (b *InternalAuth) int64Ptr(i int64) *int64 {
	return &i
}
