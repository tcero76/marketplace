import scrapy
import os
import re
import json

class ModelosSpider(scrapy.Spider):
    name = "modelos"
    allowed_domains = ["arsmate.com"]
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36",
        "X-Requested-With": "XMLHttpRequest",
    }

    def start_requests(self):
        url = "https://arsmate.com"
        with open("./arsmate_cookies.json") as f:
            self.cookies = json.load(f)
        print(self.cookies)
        yield scrapy.Request(url=url, headers=self.headers, cookies=self.cookies, callback=self.parseTotalPosts)

    def parseTotalPosts(self, response):
        base_url = "https://arsmate.com/ajax/explore"
        print(base_url)
        match = re.search(r"var\s+totalPosts\s*=\s*(\d+)", response.text)
        print(f"El match es: {match}")
        if match:
            total = int(match.group(1))
        print(f"El total es: {total}")
        total = int(os.getenv("TOTAL_POSTS", total))
        step = 5
        for skip in range(0, total, step):
            url = f"{base_url}?skip={skip}&total={total}"
            request = response.follow(url=url, headers=self.headers, callback=self.parse)
            yield request

    def parse(self, response):
        for div in response.css("div.card.mb-3.card-updates"):
            fechaCreacion = div.css("small.timeAgo.text-muted").attrib.get("data","")
            yield {
                "tabla": "modelos",
                "id": div.attrib.get("data", ""),
                "fechaCreacion": fechaCreacion,
                "modelo": div.css("small.text-muted.font-14::text").get(default="").strip()
            }