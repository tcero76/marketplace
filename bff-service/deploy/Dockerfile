FROM golang:1.25 AS dev
WORKDIR /app

RUN go install github.com/air-verse/air@latest

FROM golang:1.25 AS builder 
WORKDIR /app

COPY ./bff-service ./bff-service
COPY ./postgres ./postgres
COPY ./clickhouse ./clickhouse
COPY ./redis ./redis
COPY ./rabbitmq ./rabbitmq
COPY ./config ./config

WORKDIR /app/bff-service
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

FROM alpine:3.20 AS prod
RUN adduser -D appuser

WORKDIR /app
COPY --from=builder /app/bff-service .

USER root

RUN mv /app/deploy/entrypoint.sh /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

USER appuser

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
