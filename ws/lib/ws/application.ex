defmodule Ws.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WsWeb.Telemetry,
      {WsWeb.MQConsumer, []},
      {DNSCluster, query: Application.get_env(:ws, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ws.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ws.Finch},
      # Start a worker by calling: Ws.Worker.start_link(arg)
      # {Ws.Worker, arg},
      # Start to serve requests, typically the last entry
      WsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ws.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
