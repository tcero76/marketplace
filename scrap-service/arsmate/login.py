# scripts/get_arsmate_cookies.py

import asyncio
from playwright.async_api import async_playwright
import json


LOGIN_URL = "https://arsmate.com/login"
COOKIES_FILE = "arsmate_cookies.json"
USERNAME = "arodnazs@gmail.com"
PASSWORD = "Reaktor6_"

async def get_cookies():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        page = await context.new_page()
        await page.goto(LOGIN_URL)
        await page.fill("input[name='username_email']", USERNAME)
        await page.fill("input[name='password']", PASSWORD)
        await page.click("#btnLoginRegister")
        await page.wait_for_load_state("networkidle")
        cookies = await context.cookies()
        filtered = {
            cookie["name"]: cookie["value"]
            for cookie in cookies
            if cookie["name"] in ["XSRF-TOKEN", "arsmate_session"]
        }
        with open(COOKIES_FILE, "w") as f:
            json.dump(filtered, f)
        print(f"Cookies guardadas en {COOKIES_FILE}")
        await browser.close()

asyncio.run(get_cookies())
