import scrapy
import re
import time
from arsmate.items import TSItem

class RelaxchileSpider(scrapy.Spider):
    name = "relaxchile"
    allowed_domains = ["www.relaxchile.cl"]
    start_urls = ["https://www.relaxchile.cl/"]

    def __init__(self, id_job=None, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.id_job = id_job

    def parse(self, response):
        url="https://www.relaxchile.cl/ficha-escort/ficha-escort.index/{}/{}"
        categorias = ["div.elite", "div.destacadas-vip", "div.destacadas-top"]
        for cat in categorias:
            for a in response.css(cat + ">div>div>a.ficha-escort-img.minitip"):
                yield scrapy.Request(
                    url.format(a.attrib.get("data-item-id"), a.attrib.get("data-item-name")),
                    callback=self.parse_profile,
                    meta={"id": a.attrib.get("data-item-id"), "name": a.attrib.get("data-item-name")}
                )
        pass
    def parse_profile(self, response):
        edad_txt = response.css("table.tabla-medidas>tbody>tr>td::text").get().strip()
        m = re.search(r"\d+", edad_txt)
        edad = int(m.group()) if m else None
        item = TSItem()
        item["id_job"] = self.id_job
        item["servicios"]=[]
        item["descripcion"] = response.css("div#panel_descripcion>p::text").get()
        item["idpagina"] = response.meta["id"]
        item["nombre"] = response.meta["name"]
        item["ciudad"] = "Santiago"
        item["edad"] = edad
        serviciosTxt = response.xpath("//div[@class='servicios-ficha']/p/text()[normalize-space()]").getall()
        [item["servicios"].append(i) for i in serviciosTxt[0].strip().split(',')]
        item["portal"] = "relaxchile"
        yield item
