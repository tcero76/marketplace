FROM flyway/flyway:latest-alpine

COPY ./entrypoint.sh /entrypoint.sh

RUN apk add --no-cache postgresql-client bash

COPY ./sql /flyway/sql

entrypoint ["flyway"]