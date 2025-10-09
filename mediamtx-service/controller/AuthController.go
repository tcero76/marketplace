package controller

import (
	"context"
	"fmt"
	"mediamtx-service/model"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"

	"github.com/golang-jwt/jwt/v5"
	"github.com/lestrrat-go/jwx/v2/jwk"
)

var ctx = context.Background()

func verifyToken(tokenStr string) (jwt.MapClaims, error) {
	set, err := jwk.Fetch(context.Background(), os.Getenv("HYDRA_PUBLIC_URL")+"/.well-known/jwks.json")
	if err != nil {
		return nil, fmt.Errorf("failed to fetch JWKS: %w", err)
	}
	keyfunc := func(token *jwt.Token) (interface{}, error) {
		kid, ok := token.Header["kid"].(string)
		if !ok {
			return nil, fmt.Errorf("missing kid in token header")
		}
		key, found := set.LookupKeyID(kid)
		if !found {
			return nil, fmt.Errorf("key with kid '%s' not found", kid)
		}
		var rawKey interface{}
		if err := key.Raw(&rawKey); err != nil {
			return nil, fmt.Errorf("failed to get raw key: %w", err)
		}
		fmt.Println(rawKey)
		return rawKey, nil
	}
	token, err := jwt.Parse(tokenStr, keyfunc)
	if err != nil {
		return nil, fmt.Errorf("invalid token: %w", err)
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return nil, fmt.Errorf("invalid token claims")
	}
	return claims, nil
}

func PublishHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		var post model.PublishPost
		if err := c.ShouldBindJSON(&post); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		fmt.Println(post.Action)
		if post.Action != "publish" {
			c.JSON(http.StatusOK, gin.H{
				"status":  "published",
				"message": "ok",
			})
			return
		}
		fmt.Println(post.Action)
		token := strings.TrimPrefix(post.Query, "jwt=")
		claims, err := verifyToken(token)
		if err != nil {
			fmt.Println(err)
			return
		}
		if claims["client_id"] != post.Path {
			c.JSON(http.StatusForbidden, gin.H{
				"error": "no es el Path adecuado",
			})
			return
		}
		rawSlice, ok := claims["scp"].([]interface{})
		if !ok {
			fmt.Errorf("no es un []interface{}")
		}
		result := false
		for i, val := range rawSlice {
			strVal, ok := val.(string)
			if !ok {
				fmt.Errorf("elemento %d no es string", i)
			}
			if strVal == "mediamtx:stream" {
				result = true
			}
		}
		if !result {
			c.JSON(http.StatusForbidden, gin.H{
				"error": "no tienes permiso",
			})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"status":  "published",
			"message": "ok",
		})
	}
}
