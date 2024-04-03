defmodule Ecomm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EcommWeb.Telemetry,
      Ecomm.Repo,
      {DNSCluster, query: Application.get_env(:ecomm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ecomm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ecomm.Finch},
      # Start a worker by calling: Ecomm.Worker.start_link(arg)
      # {Ecomm.Worker, arg},
      # Start to serve requests, typically the last entry
      EcommWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ecomm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EcommWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
