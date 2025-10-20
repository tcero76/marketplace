package payload

import "github.com/tcero76/marketplace/bff-service/dto"

type ModeloSearchPage struct {
	Items  []dto.SearchDTO `json:"items"`
	Limit  int             `json:"limit"`
	Offset int             `json:"offset"`
	Total  int64           `json:"total"`
}

type SearchRequest struct {
	Mention string   `json:"mention"`
	Text    []string `json:"text"`
}
