FROM golang:latest

# Instalar Protobuf
RUN apt-get update && apt-get install -y protobuf-compiler

# Instalar el plugin de Go para Protobuf
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Agregar el plugin al PATH
ENV PATH="/go/bin:$PATH"

# Definir el punto de entrada
ENTRYPOINT ["protoc"]
