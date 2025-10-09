package dto

type SearchDTO struct {
	ID             int     `json:"id"`
	Descripcion    string  `json:"descripcion"`
	DescripcionTSV string  `json:"descripcionTSV"`
	Modelo         string  `json:"modelo"`
	Rank           float64 `json:"rank"`
}
