package model

type PublishPost struct {
	ClientId string `json:"clientid"`
	Ip       string `json:"ip"`
	User     string `json:"user"`
	Pass     string `json:"pass"`
	Path     string `json:"path"`
	Query    string `json:"query"`
	Action   string `json:"action"`
}
