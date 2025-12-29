FROM golang:1.25 AS hook-builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o hook

ARG MEDIAMTX_VERSION

from bluenviron/mediamtx:1.15.5

COPY --from=hook-builder /app/hook /hooks/hook
