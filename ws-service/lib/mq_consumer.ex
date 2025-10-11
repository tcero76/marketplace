defmodule WsServiceWeb.MQConsumer do
  use GenServer
  use AMQP

  @queue System.get_env("RABBITMQ_QUEUE") || "default_queue"
  @rabbitmq_host System.get_env("RABBITMQ_HOST") || "localhost"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def publish(message_map) do
    IO.puts("Publicando mensaje: #{inspect(message_map)}")
    GenServer.cast(__MODULE__, {:publish, message_map})
  end

  @impl true
  def handle_cast({:publish, message_map}, %{channel: chan} = state) do
    IO.puts("→ Publicando mensaje en la cola #{@queue}")
    payload = Jason.encode!(message_map)
    Basic.publish(chan, "logs", "", payload,
      persistent: true,
      content_type: "application/json"
    )
    {:noreply, state}
  end

  @impl true
  def init(state) do
    case Connection.open("amqp://guest:guest@#{@rabbitmq_host}:5672") do
      {:ok, conn} ->
        {:ok, chan} = Channel.open(conn)
        # Queue.declare(chan, @queue, durable: true)
        # Exchange.declare(chan, "logs", :fanout, durable: true)
        # AMQP.Queue.bind(chan, @queue, "logs")
        Basic.consume(chan, @queue, nil, no_ack: false)
        IO.puts("AMQP: Crea cola #{@queue} en el canal #{inspect(chan)}")
        {:ok, %{channel: chan}}
      {:error, _} ->
        Process.send_after(self(), :retry_connect, 5000)
        IO.puts("AMQP: error al conectar al canal")
        {:ok, state}
    end
  end

  @impl true
  def handle_info({:basic_deliver, payload, meta}, state) do
    IO.puts("Confirmación de consumo recibido: #{inspect(payload)}")
    case Jason.decode(payload) do
      {:ok, %{"userId" => user_id, "body" => body}} ->
        IO.puts("Mensaje procesado de #{user_id}: #{body}")
        WsServiceWeb.Endpoint.broadcast("room:lobby", "message:new", %{tipo: "notificacion", body: body})
      {:error, reason} ->
        IO.puts("Error al decodificar el mensaje: #{inspect(reason)}")
    end
    Basic.ack(state.channel, meta.delivery_tag)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("Mensaje inesperado: #{inspect(msg)}")
    {:noreply, state}
  end
end
