FROM golang:1.24.0

WORKDIR /app

COPY go.mod go.sum /app/
RUN go install github.com/air-verse/air@latest
RUN go mod download

ENTRYPOINT ["air"]
