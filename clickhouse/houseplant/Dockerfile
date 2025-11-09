FROM python:3.12-slim

RUN apt update && apt-get install -y curl

RUN pip install houseplant clickhouse-driver

COPY ./ch /ch

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
