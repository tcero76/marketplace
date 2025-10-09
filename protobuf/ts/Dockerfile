# Usar una imagen base de Node.js
FROM node:16

# Instalar las dependencias para protoc
RUN apt-get update && \
    apt-get install -y \
    unzip \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Descargar y configurar el plugin de protoc para TypeScript
RUN mkdir /protoc-gen-ts
WORKDIR /protoc-gen-ts
RUN npm init -y && \
    npm install protoc-gen-ts --save-dev

# Instalar protoc-gen-ts globalmente
RUN npm install -g protoc-gen-ts

# Comando para generar los archivos .js y .ts
CMD ["protoc"]