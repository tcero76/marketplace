FROM golang:1.25

EXPOSE 3000

WORKDIR /app

COPY go.mod go.sum ./

RUN go install github.com/air-verse/air@latest

ENTRYPOINT ["air"]