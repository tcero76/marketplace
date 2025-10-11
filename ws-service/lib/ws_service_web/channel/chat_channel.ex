defmodule WsServiceWeb.Channel.ChatChannel do
  use Phoenix.Channel

  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in(_event, %{"message" => msg, "userId" => userId}, socket) do
    IO.inspect(%{userId: userId, body: msg}, label: "Received message")
    IO.inspect(socket.assigns.current_user["client_id"], label: "Socket state")
    WsServiceWeb.MQConsumer.publish(%{userId: userId, body: msg, current_user: socket.assigns.current_user["client_id"]})
    {:noreply, socket}
  end
end
