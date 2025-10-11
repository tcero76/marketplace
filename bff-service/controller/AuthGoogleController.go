package controller

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/go-redis/redis/v8"
	hydra "github.com/ory/hydra-client-go/v2"
	log "github.com/sirupsen/logrus"
	"gorm.io/gorm"

	"github.com/labstack/echo/v4"
	"golang.org/x/oauth2"
)

func AuthGoogleHandler(googleOauthConfig *oauth2.Config) echo.HandlerFunc {
	return func(c echo.Context) error {
		return nil
	}
}

func AuthGoogleCallbackHandler(googleOauthConfig *oauth2.Config, rdb *redis.Client, hydraAdminClient *hydra.APIClient) echo.HandlerFunc {
	return func(c echo.Context) error {
		return nil
	}
}

func AuthGoogleConsentHandler(hydraAdminClient *hydra.APIClient, db *gorm.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		getExchangeToken(token.Extra("id_token").(string))
		return nil
	}
}

func getExchangeToken(subjectToken string) {
	data := url.Values{}
	data.Set("grant_type", "authorization_code")
	data.Set("client_id", os.Getenv("CLIENT_ID"))
	data.Set("client_secret", os.Getenv("CLIENT_SECRET"))
	data.Set("scope", "openid offline")
	data.Set("redirect_uri", "http://bff:3000/callback")

	log.Printf("BODY: %s", data.Encode())

	req, err := http.NewRequest("GET", os.Getenv("HYDRA_PUBLIC_URL")+"/oauth2/auth", strings.NewReader(data.Encode()))
	if err != nil {
		panic(err)
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	fmt.Printf("Status Code: %d\n", resp.StatusCode)

	body, _ := io.ReadAll(resp.Body)

	log.Info("Token de intercambio recibido:", string(body))
}
