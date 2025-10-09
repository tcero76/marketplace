import scrapy
import json
import re
import os
import urllib.parse as up
import psycopg2

class ModeloSpider(scrapy.Spider):
    name = "modelo"
    allowed_domains = ["arsmate.com"]
    start_urls = ["https://arsmate.com"]
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36",
        "X-Requested-With": "XMLHttpRequest",
    }

    def fetch_modelos(self):
        try:
            url = os.getenv("DATABASE_URL")
            if not url:
                raise ValueError("La variable de entorno DATABASE_URL no está definida.")
            conn = psycopg2.connect(url)
            cursor = conn.cursor()
            cursor.execute("""
                SELECT modelo 
                FROM scrap.modelos_instagram 
                WHERE id_job = (SELECT MAX(id_job) FROM scrap.modelos_instagram);
            """)
            datos = cursor.fetchall()
            print(f"Se encontraron {len(datos)} modelos")
        except (psycopg2.Error, ValueError) as e:
            print("❌ Error al consultar la base de datos:", e)
        finally:
            if 'cursor' in locals():
                cursor.close()
            if 'conn' in locals():
                conn.close()
        return datos

    def start_requests(self):
        with open("./arsmate_cookies.json") as f:
            self.cookies = json.load(f)
        datos = self.fetch_modelos()
        base_url="https://arsmate.com"
        for i, dato in enumerate(datos):
            print(f">>>>>>> Modelo nro {i+1}")
            modelo=dato[0].lstrip("@")
            url=f"{base_url}/{modelo}"
            yield scrapy.Request(url=url, headers=self.headers, cookies=self.cookies,
                                    callback=self.parse_data, meta={"modelo":modelo})

    def parse_data(self, response):
        modelo = response.meta["modelo"]
        match = re.search(r"var\s+totalPosts\s*=\s*(\d+)", response.text)
        if match:
            total = int(match.group(1))
        match = re.search(r"var\s+profile_id\s*=\s*(\d+)", response.text)
        if match:
            id = int(match.group(1))
        descripcion = response.css("div#navbarUserHome span.update-text::text").getall()
        yield {
            "tabla": "modelo",
            "id": id,
            "modelo": modelo,
            "descripcion": descripcion,
        }
        for skip in range(0,total,5):
            url = f"https://arsmate.com/ajax/updates?id={id}&skip={skip}&total={total}"
            yield scrapy.Request(url=url, headers=self.headers, cookies=self.cookies,
                                 callback=self.parse_posts, meta={ "id": id, "modelo": modelo })

    def parse_posts(self,response):
        id = response.meta["id"]
        modelo = response.meta["modelo"]
        for div in response.css("div.card.mb-3.card-updates.rounded-large.shadow-large.card-border-0"):
            data_value = int(div.attrib.get("data", ""))
            descripcion = " ".join(
                div.css("p.update-text::text").getall()
            ).strip()
            likes = int(" ".join(
                div.css("small.countLikes::text").getall()
            ).strip())
            fechaCreacion = response.css("small.timeAgo.text-muted").attrib.get("data","")
            yield {
                "tabla": "posts",
                "descripcion": descripcion,
                "data": data_value,
                "id": id,
                "modelo": modelo,
                "likes": likes,
                "fechaCreacion": fechaCreacion
            }


        
