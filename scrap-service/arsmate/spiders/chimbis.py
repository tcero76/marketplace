import scrapy
import re


class ChimbisSpider(scrapy.Spider):
    name = "chimbis"
    allowed_domains = ["chimbis.com"]
    start_urls = ["https://chimbis.com/escorts/chile"]

    def parse(self, response):
        script = response.xpath("//script[contains(., 'status_busqueda')]//text()").get()
        status = re.search(r"status_busqueda='([^']+)'", script).group(1)
        last_res = re.search(r"last_res=([0-9]+)", script).group(1)
        fin_busqueda = "false"
        print(f"Status: {status}, Last Res: {last_res}")
        yield from self.parse_results_landing(response)
        yield scrapy.FormRequest(
            url="https://www.chimbis.com/resultados",
            formdata={
                "status": status,
                "last_res": last_res,
                "no_phone": "0"
            },
            headers={
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "Referer": response.url
            },
            callback=self.parse_ajax,
            meta={
                "status": status,
                "last_res": last_res
            }
        )

    def parse_ajax(self, response):
        json = response.json()
        html = json["html_resultados"]
        yield from self.parse_results(html)
        print(f"Fin busqueda: {json['fin']}")
        print(f"Total resultados: {len(json['html_resultados'])}")
        if json["fin"]:
            self.logger.info("FIN DE LA BÚSQUEDA")
            return
        status = json["status"]
        last_res = json["last_res"]
        yield scrapy.FormRequest(
            url="https://www.chimbis.com/resultados",
            formdata={
                "status": status,
                "last_res": last_res,
                "no_phone": "0"
            },
            headers={
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "Referer": "https://www.chimbis.com/"
            },
            callback=self.parse_ajax
        )

    def parse_results_landing(self, response):
        if "fin_busqueda=true" in response.text:
            self.logger.info("FIN DE LA BÚSQUEDA")
            return
        ts = response.css("div.pin.masonry.top_off").getall()
        print(f"Encontrados {len(ts)} resultados en esta página")
        yield None


    def parse_results(self, html):
        for h in html:
            if "fin_busqueda=true" in h:
                self.logger.info("FIN DE LA BÚSQUEDA")
                return
            sel = scrapy.Selector(text=h)
            ts = sel.css("div.pin.masonry.top_off").getall()
            # print(f"Encontrados {len(ts)} resultados en esta página")
        yield None