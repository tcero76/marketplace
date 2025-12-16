FROM golang:1.25

EXPOSE 3001

WORKDIR /app

RUN go install github.com/air-verse/air@latest

ENTRYPOINT ["air"]