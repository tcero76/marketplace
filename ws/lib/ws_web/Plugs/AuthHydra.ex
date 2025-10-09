defmodule WsWeb.Plugs.AuthHydra do
  import Plug.Conn
  require Logger
  alias HTTPoison

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- extract_token(conn),
         {:ok, jwt} <- verify_token(token) do
      assign(conn, :user, jwt)
    else
      {:error, reason} ->
        Logger.warning("Authentication failed: #{reason}")
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(WsWeb.ErrorView)
        |> Phoenix.Controller.render("401.json")
        |> halt()
    end
  end

  def authenticate(params, _socket) do
    with {:ok, jwt} <- verify_token(params) do
      jwt
    # else
    #   {:error, reason} ->
        # Logger.warning("Authentication failed: #{reason}")
        # conn
        # |> put_status(:unauthorized)
        # |> Phoenix.Controller.put_view(WsWeb.ErrorView)
        # |> Phoenix.Controller.render("401.json")
    end
  end

  defp extract_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        IO.inspect(token, label: "Token extraído")
        {:ok, token}
      _ ->
        {:error, :missing_token}
    end
  end

  defp verify_token(params) do
    with {:ok, jwks} <- fetch_jwks(),
         {:ok, token} <- Map.fetch(params, "token"),
         {:ok, jwk} <- find_jwk(jwks, token),
         {:ok, jwt} <- verify_signature(jwk, token) do
      {:ok, jwt}
    end
  end

  defp fetch_jwks do
    case HTTPoison.get("http://hydra:4444/.well-known/jwks.json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)
        {:ok, Jason.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: status }} ->
        {:error, "Failed to fetch JWKS: HTTP #{status}"}
      {:error, reason} ->
        {:error, "Failed to fetch JWKS: #{inspect(reason)}"}
    end
  end

  defp find_jwk(jwks, token) do
    peek_result = JOSE.JWT.peek_protected(token)
    IO.inspect(peek_result, label: "Resultado de JOSE.JWT.peek_protected")
    case peek_result do
      %JOSE.JWS{fields: %{"kid" => kid}} ->
        case Enum.find(jwks["keys"], &(&1["kid"] == kid)) do
          nil -> {:error, :key_not_found}
          jwk -> {:ok, JOSE.JWK.from_map(jwk)}
        end
      %JOSE.JWS{fields: fields} ->
        IO.inspect(fields, label: "Campos del header del token")
        {:error, :missing_kid}
      _ ->
        {:error, :invalid_token_header}
    end
  end

  defp verify_signature(jwk, token) do
    case JOSE.JWT.verify(jwk, token) do
      {true, jwt, _jws} ->
        {:ok, jwt.fields}
      {false, _, _} ->
        {:error, :invalid_signature}
    end
  end
end
