defmodule WsServiceWeb.ProtectedController do
  use WsServiceWeb, :controller

  plug WsServiceWeb.Plugs.AuthHydra when action in [:index]

  def index(conn, _params) do
    json(conn, %{message: "Acceso permitido. Token válido.", user: conn.assigns.user})
  end
end
