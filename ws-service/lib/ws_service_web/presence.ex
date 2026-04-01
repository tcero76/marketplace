defmodule WsServiceWeb.Presence do
  use Phoenix.Presence,
    otp_app: :ws_service,
    pubsub_server: WsService.PubSub
end
