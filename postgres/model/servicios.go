package model

type Servicios struct {
	ID     int32  `gorm:"column:id;primaryKey" json:"id"`
	Nombre string `gorm:"column:nombre;not null" json:"nombre"`
}

func (Servicios) TableName() string {
	return "marketplace.servicios"
}
