defmodule WsService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WsServiceWeb.Telemetry,
      {WsServiceWeb.MQConsumer, []},
      {DNSCluster, query: Application.get_env(:ws_service, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WsService.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WsService.Finch},
      # Start a worker by calling: WsService.Worker.start_link(arg)
      # {WsService.Worker, arg},
      # Start to serve requests, typically the last entry
      WsServiceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WsService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WsServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
