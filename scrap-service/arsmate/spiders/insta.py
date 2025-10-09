from playwright.sync_api import sync_playwright
import time, json, re, os, psycopg2

import scrapy
from scrapy.http import FormRequest

class InstaSpider(scrapy.Spider):
    name = "insta"
    allowed_domains = ["instagram.com"]
    start_urls = ["https://www.instagram.com/accounts/login/"]


    def __init__(self, target_user="arsmate.creators", *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.username = os.getenv("USERNAME_INSTA")
        self.password = os.getenv("PASSWORD_INSTA")
        self.target_user = target_user


    def parse(self, response):
        id_job = int(time.time() * 1000) 
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            context = browser.new_context()
            page = context.new_page()
            page.goto("https://www.instagram.com/accounts/login/")
            page.wait_for_selector("input[name='username']")
            page.fill("input[name='username']", self.username)
            page.fill("input[name='password']", self.password)
            page.click("button[type='submit']")
            print("✅ Formulario de login enviado")
            try:
                page.wait_for_selector("text='Ahora no'", timeout=8000)
                print("🟡 Clic en 'Ahora no' (guardar login)")
            except:
                print("✅ No apareció aviso de guardar login")
            page.goto(f"https://www.instagram.com/{self.target_user}/")
            palabras_encontradas = []
            def handle_response(response):
                if "https://www.instagram.com/graphql/query" in response.url:
                    try:
                        body_json = response.text()
                        resultados = re.findall(r'Encuéntrala como ([^\s.,;:!?"\']+)', body_json)
                        for palabra in resultados:
                            palabra = palabra.replace("\\nen", "")
                            palabra = palabra.replace("\\n", "")
                            palabra = palabra.replace("#", "")
                            self.insert_modelo(palabra, id_job)
                            print(f"🔍 Palabra encontrada: {palabra}")
                    except Exception as e:
                        print(f"⚠️ No se pudo parsear JSON de: {response.url}")
                        print(f"🔍 Error: {e}")
            page.on("response", handle_response)
            self.scroll_until_end(page)
            filename = f"./arsmate/spiders/graphql_responses/palabras_encontradas.json"
            with open(filename, "w", encoding="utf-8") as f:
                json.dump(palabras_encontradas, f, ensure_ascii=False, indent=2)
            browser.close()


    def insert_modelo(self, modelo,id_job):
        url = os.getenv("DATABASE_URL")
        conn = psycopg2.connect(url)
        try:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO scrap.modelos_instagram (modelo,id_job)
                    VALUES (%s, %s)
                    RETURNING id;
                    """,
                    (modelo,id_job)
                )
                inserted_id = cur.fetchone()[0]
                conn.commit()
                return inserted_id
        finally:
            conn.close()

    def scroll_until_end(self, page, max_retries=2):
        previous_count = 0
        retries = 0
        while retries < max_retries:
            current_count = page.eval_on_selector_all("img", "els => els.length")
            print(f"🧾 Posts visibles: {current_count}")
            if current_count == previous_count and current_count != 47:
                retries += 1
                print(f"⏳ Sin nuevos posts. Intento {retries}/{max_retries}")
            else:
                retries = 0
                previous_count = current_count
            page.mouse.wheel(0, 5000)
            page.wait_for_timeout(5000)
        print("✅ Fin del scroll: no se cargan más posteos")

