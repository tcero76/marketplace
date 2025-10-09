# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
from datetime import datetime
import psycopg2
import os
import urllib.parse as up
import time

class ArsmatePipeline:
    def open_spider(self, spider):
        url = os.getenv("DATABASE_URL")
        up.uses_netloc.append("postgres")
        self.conn = psycopg2.connect(url)
        self.cursor = self.conn.cursor()
        self.id_job = time.time()

    def close_spider(self, spider):
        self.conn.commit()
        self.conn.close()

    def process_item(self, item, spider):
        try:
            insert = ""
            if item.get("tabla") == "modelo":
                insert = (
                    "INSERT INTO scrap.modelos("
                    "id,"
                    "modelo,"
                    "descripcion,"
                    "created_at,"
                    "id_job"
                    ") VALUES (%s, %s, %s, %s, %s)"
                )
                self.cursor.execute(insert,
                                    (item["id"],
                                    item["modelo"],
                                    item["descripcion"],
                                    datetime.now(),
                                    self.id_job)
                                    )
            if item.get("tabla") == "posts":
                insert = (
                    "INSERT INTO scrap.posts ("
                    "id_modelos,"
                    "modelo,"
                    "descripcion,"
                    "id,"
                    "likes,"
                    "fechaRegistro,"
                    "created_at,"
                    "id_job"
                    ") VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
                )
                self.cursor.execute(
                    insert,
                    (item["id"],
                    item["modelo"],
                    item["descripcion"],
                    item["data"],
                    0 if item["likes"] == "" else item["likes"],
                    datetime.now(),
                    datetime.fromisoformat(item["fechaCreacion"]),
                    self.id_job
                    )
                )
            if item.get("tabla") == "modelos":
                insert = (
                    "INSERT INTO scrap.explore("
                    "id,"
                    "modelo,"
                    "created_at,"
	                "fechaRegistro,"
                    "id_job"
                    ") VALUES (%s, %s, %s, %s, %s)"
                )
                self.cursor.execute(insert,
                                    (item["id"],
                                    item["modelo"],
                                    datetime.now(),
                                    datetime.fromisoformat(item["fechaCreacion"]),
                                    self.id_job)
                                    )
            self.conn.commit()
        except Exception as e:
            spider.logger.error(f"Error inserting item: {e}")
            self.conn.rollback()
            raise e
        return item