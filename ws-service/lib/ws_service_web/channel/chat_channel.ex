defmodule WsServiceWeb.Channel.ChatChannel do
  use Phoenix.Channel
  alias WsServiceWeb.Presence

  def join("room:"<> room_name, _payload, socket) do
    IO.puts("User joined room: #{room_name}")
    socket = assign(socket, :room_name, room_name)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    user_key = socket.assigns.current_user["ext"]["id"]
    meta = %{
      userId: user_key,
      username: socket.assigns.current_user["ext"]["name"],
      online_at: inspect(System.system_time(:second)),
    }
    {:ok, _} = Presence.track(socket, user_key, meta)
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in(_event, %{"message" => msg, "userId" => userId}, socket) do
    WsServiceWeb.MQConsumer.publish(%{
      userId: userId,
      body: msg,
      ext_name: socket.assigns.current_user["ext"]["name"],
      room: socket.assigns[:room_name]})
    {:noreply, socket}
  end
  intercept ["disconnect"]

  def handle_out("disconnect", _msg, socket) do
    {:noreply, socket}
  end
end
