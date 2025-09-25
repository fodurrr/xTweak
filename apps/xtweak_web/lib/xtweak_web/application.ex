defmodule XTweakWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      XTweakWebWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:xtweak_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: XTweakWeb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: XTweakWeb.Finch},
      # Start a worker by calling: XTweakWeb.Worker.start_link(arg)
      # {XTweakWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      XTweakWebWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XTweakWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XTweakWebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
