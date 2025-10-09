package model

type Modelo struct {
	Id          int     `gorm:"column:id;type:INTEGER;primaryKey;"`
	IdJob       float64 `gorm:"column:id_job;"`
	Modelo      string  `gorm:"column:modelo;type:VARCHAR(125);"`
	Descripcion string  `gorm:"column:descripcion;type:TEXT"`
	createdAt   string  `gorm:"column:created_at;type:timestamp without time zone;"`
}

func (modelo Modelo) TableName() string {
	return "marketplace.modelos"
}
