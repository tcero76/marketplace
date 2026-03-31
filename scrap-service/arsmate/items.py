# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class ModeloItem(scrapy.Item):
    __table__ = "scrap.modelos"
    id = scrapy.Field()
    modelo = scrapy.Field()
    descripcion = scrapy.Field()
    fecharegistro = scrapy.Field()
    id_job = scrapy.Field()

class PostItem(scrapy.Item):
    __table__ = "scrap.posts"
    id = scrapy.Field()
    id_modelos = scrapy.Field()
    id_job = scrapy.Field()
    descripcion = scrapy.Field()
    modelo = scrapy.Field()
    fecharegistro = scrapy.Field()
    created_at = scrapy.Field()
    likes = scrapy.Field()

class ModelosItem(scrapy.Item):
    __table__ = "scrap.explore"
    id = scrapy.Field()
    id_job = scrapy.Field()
    modelo = scrapy.Field()
    fechaRegistro = scrapy.Field()
    created_at = scrapy.Field()
    likes = scrapy.Field()

class TSItem(scrapy.Item):
    __table__ = "scrap.ts"
    id = scrapy.Field()
    id_job = scrapy.Field()
    portal = scrapy.Field()
    idpagina = scrapy.Field()
    nombre = scrapy.Field()
    edad = scrapy.Field()
    ciudad = scrapy.Field()
    servicios = scrapy.Field()
    servicios_adicionales  = scrapy.Field()
    descripcion = scrapy.Field()
    scraped_at = scrapy.Field()