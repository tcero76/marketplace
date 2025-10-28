FROM flyway/flyway:latest-alpine

RUN apk add --no-cache postgresql-client bash

COPY ./sql /flyway/sql

entrypoint ["flyway"]