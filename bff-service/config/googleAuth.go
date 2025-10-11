package config

import (
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

func InitGoogleAuth() *oauth2.Config {
	var googleOauthConfig = &oauth2.Config{
		RedirectURL:  os.Getenv("GOOGLE_OAUTH2_REDIRECT_URI"),
		ClientID:     os.Getenv("GOOGLE_OAUTH2_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_OAUTH2_CLIENT_SECRET"),
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
	return googleOauthConfig
}
