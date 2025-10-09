# Etapa 1: Build
FROM golang:1.25 AS builder
WORKDIR /app

# Copiamos solo los archivos de módulos para aprovechar cache
COPY go.mod go.sum ./
RUN go mod download

# Copiamos el resto del código
COPY . .

# Compilamos la app en modo estático
RUN CGO_ENABLED=0 GOOS=linux go build -o app ./cmd/main.go

# Etapa 2: Imagen de producción
FROM alpine:latest
WORKDIR /app

# Copiamos el binario compilado desde la etapa builder
COPY --from=builder /app/app .

# Puerto que va a exponer tu servicio (si aplica)
EXPOSE 8080

# Comando que ejecuta tu microservicio
ENTRYPOINT ["./app"]
