defmodule WsWeb.Events.Message do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :user, 1, type: :string
  field :text, 2, type: :string
end
