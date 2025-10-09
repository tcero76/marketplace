defmodule WsWeb.Channel.UserSocket do
  use Phoenix.Socket

  channel "room:*", WsWeb.Channel.ChatChannel

  def connect(params, socket, _connect_info) do
    user = WsWeb.Plugs.AuthHydra.authenticate(params, socket)
    socket = assign(socket, :current_user, user)
    {:ok, socket}
  end

  def id(_socket), do: nil

end
