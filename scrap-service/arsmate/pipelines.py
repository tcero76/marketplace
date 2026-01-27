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

class ArsmatePipeline:
    def open_spider(self, spider):
        url = os.getenv("DATABASE_URL")
        up.uses_netloc.append("postgres")
        self.conn = psycopg2.connect(url)
        self.cursor = self.conn.cursor()

    def close_spider(self, spider):
        self.conn.commit()
        self.conn.close()

    def process_item(self, item, spider):
        try:
            table = item.__table__
            fields = list(item.keys())
            columns = ", ".join(fields)
            placeholders = ", ".join(["%s"] * len(fields))
            sql = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
            values = [item[field] for field in fields]
            self.cursor.execute(sql, values)
        except Exception as e:
            spider.logger.error(f"Error inserting item: {e}")
            self.conn.rollback()
            raise e
        return item