FROM flyway/flyway:latest-alpine as prod

COPY ./deploy/entrypoint.sh /entrypoint.sh

RUN apk add --no-cache postgresql-client bash

COPY ./sql /flyway/sql

entrypoint ["/entrypoint.sh"]