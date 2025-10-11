defmodule WsServiceWeb.Channel.UserSocket do
  use Phoenix.Socket

  channel "room:*", WsServiceWeb.Channel.ChatChannel

  def connect(params, socket, _connect_info) do
    user = WsServiceWeb.Plugs.AuthHydra.authenticate(params, socket)
    socket = assign(socket, :current_user, user)
    {:ok, socket}
  end

  def id(_socket), do: nil

end
