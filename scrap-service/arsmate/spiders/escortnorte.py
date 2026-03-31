import scrapy
import re
from datetime import datetime
import time
from arsmate.items import TSItem

class EscortnorteSpider(scrapy.Spider):
    name = "escortnorte"
    allowed_domains = ["escortnorte.cl"]
    start_urls = ["https://escortnorte.cl/desktop/ajax/ip.php"]


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.id_job = time.time()

    def parse(self, response):
        cards = response.json()
        for card in cards:
            id = card["id"]
            url = f"https://escortnorte.cl/_html/ficha.php?fichaID={id}"
            yield scrapy.Request(
                url=url,
                callback=self.parse_profile,
                meta={"id": id}
            )
        pass

    def parse_profile(self, response):
        nombre = response.css("h1#nombre::text").get().strip()
        ciudad = response.css("h2#fichaseccion::text").get().strip()
        edad_txt =response.css("dl#datos1 > dd:nth-of-type(2)::text").get().strip()
        m = re.search(r"\d+", edad_txt)
        edad = int(m.group()) if m else None
        id = response.meta["id"]
        descripcion = response.css("div#texto::text").get().strip()
        item=TSItem()
        item["id_job"] = self.id_job
        item["servicios"] = []
        item["servicios_adicionales"] = []
        [item["servicios"].append(s.strip()) for s in response.css("ul#serinc>li::text").getall()]
        [item["servicios_adicionales"].append(s.strip()) for s in response.css("ul#servad>li::text").getall()]
        item["nombre"] = nombre
        item["idpagina"] = id
        item["portal"] = "escortnorte"
        item["ciudad"] = ciudad
        item["edad"] = edad
        item["descripcion"] = descripcion
        item["scraped_at"] = datetime.now()
        yield item
