package model

type SessionData struct {
	AccessToken  string `redis:"access_token"`
	RefreshToken string `redis:"refresh_token"`
	UserID       string `redis:"user_id"`
	UserAgent    string `redis:"user_agent"`
	IP           string `redis:"ip"`
}
