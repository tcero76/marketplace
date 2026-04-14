import scrapy
import re
import time
from arsmate.items import TSItem

class PlanetaescortSpider(scrapy.Spider):
    name = "planetaescort"
    allowed_domains = ["planetaescort.cl"]
    start_urls = ["https://planetaescort.cl"]
    base_url = "https://planetaescort.cl/site/bloque{}?version={}&pag={}"

    def __init__(self, id_job=None, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.id_job = id_job

    def parse(self, response):
        script = response.text
        m = re.search(r'var\s+indexVersion\s*=\s*"(\d+)"', script)
        if not m:
            self.logger.error("No se encontró indexVersion")
            return
        version = m.group(1)
        csrf = response.css("meta[name='csrf-token']::attr(content)").get()
        self.headers = {
            "x-csrf-token": csrf,
            "Referer": "https://planetaescort.cl/",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
            "X-Requested-With": "XMLHttpRequest",
        }
        yield scrapy.Request(
            self.base_url.format(1,version,1),
            callback=self.parse_first_page,
            headers=self.headers,
            meta={"version": version, "bloque": 1}
        )
        pass
    def parse_first_page(self, response):
        data = response.json()
        html = data["datos"]
        total = data["totalPaginas"]
        for page in range(2, total + 1):
            yield scrapy.Request(
                self.base_url.format(response.meta["bloque"], response.meta["version"], page),
                callback=self.parse_page,
                headers=self.headers
            )
        sel = scrapy.Selector(text=html)
        url = sel.css("a.btnModelo::attr(href)").getall()
        for u in url:
            yield scrapy.Request(
                url="https://planetaescort.cl" + u,
                callback=self.parse_profile,
                headers=self.headers,
                meta={"id": u}
            )
    
    def parse_page(self, response):
        data = response.json()
        html = data["datos"]
        sel = scrapy.Selector(text=html)
        url = sel.css("a.btnModelo::attr(href)").getall()
        for u in url:
            yield scrapy.Request(
                url="https://planetaescort.cl" + u,
                callback=self.parse_profile,
                headers=self.headers,
                meta={"id": u}
            )

    def parse_profile(self,response):
        edad_txt = response.css('li[aria-label="Edad:"]::text').get()
        m = re.search(r"\d+", edad_txt)
        edad = int(m.group()) if m else None
        nombre = response.css("div[aria-label='Nombre modelo']::text").get().strip()
        description = response.css("div.txtDesc > p::text").get()
        item=TSItem()
        item["servicios"] = []
        item["servicios_adicionales"] = []
        [item["servicios"].append(s.strip()) for s in response.css('ul[aria-label="Servicios incluidos"]>li::text').getall()]
        [item["servicios_adicionales"].append(s.strip()) for s in response.css('ul[aria-label="Servicios adicionales"]>li::text').getall()]
        item["portal"] = "planetaescort"
        item["nombre"] = nombre
        item["id_job"] = self.id_job
        item["edad"] = edad
        item["descripcion"] = description
        item["ciudad"] = "Santiago"
        item["idpagina"] = response.meta["id"]
        yield item
