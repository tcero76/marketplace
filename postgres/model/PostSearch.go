package model

type PostSearch struct {
	ID             uint    `gorm:"column:id"`
	Descripcion    string  `gorm:"column:descripcion"`
	DescripcionTSV string  `gorm:"column:descripcion_tsv"`
	Rank           float64 `gorm:"-:all"`
}
