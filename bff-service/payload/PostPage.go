package payload

import "github.com/tcero76/marketplace/bff-service/dto"

type PostsPage struct {
	Items  []dto.Posts `json:"items"`
	Limit  int         `json:"limit"`
	Offset int         `json:"offset"`
	Total  int64       `json:"total"`
}
