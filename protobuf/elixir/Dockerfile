FROM elixir:latest

# Instalar Protobuf
RUN apt-get update && apt-get install -y protobuf-compiler

# Instalar el plugin de Elixir
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix escript.install hex protobuf --force

# Agregar el plugin al PATH
ENV PATH="/root/.mix/escripts:$PATH"

# Definir el punto de entrada
ENTRYPOINT ["protoc"]
