FROM golang:1.24.3

EXPOSE 3000

WORKDIR /app

COPY go.mod go.sum .air.toml ./

RUN go mod download

RUN go install github.com/air-verse/air@latest
RUN go install github.com/swaggo/swag/cmd/swag@latest


ENTRYPOINT [ "air" ]