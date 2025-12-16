FROM golang:1.25 AS dev
WORKDIR /app

RUN go install github.com/air-verse/air@latest
RUN go install github.com/swaggo/swag/cmd/swag@latest

FROM golang:1.25 AS builder 
WORKDIR /app

COPY ./mediamtx-service/ ./

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

FROM alpine:3.20 AS prod
RUN adduser -D appuser

WORKDIR /app
COPY --from=builder /app/ .

USER root

RUN mv /app/deploy/entrypoint.sh /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

USER appuser

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
