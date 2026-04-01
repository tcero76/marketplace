package searchspecifications

import "gorm.io/gorm"

type Specification interface {
	Apply(db *gorm.DB) *gorm.DB
}

func ApplySpecifications(db *gorm.DB, specs ...Specification) *gorm.DB {
	for _, spec := range specs {
		db = spec.Apply(db.Debug())
	}
	return db
}
