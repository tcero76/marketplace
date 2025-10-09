FROM elixir:1.17.3

WORKDIR /app

RUN apt-get update && apt-get install -y inotify-tools

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./

RUN mix deps.get 

CMD ["mix", "phx.server"]
