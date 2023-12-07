defmodule Chat1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Chat1Web.Telemetry,
      # Start the Ecto repository
      Chat1.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Chat1.PubSub},
      # Start Finch
      {Finch, name: Chat1.Finch},
      Chat1Web.Presence,
      # Start the Endpoint (http/https)
      Chat1Web.Endpoint
      # Start a worker by calling: Chat1.Worker.start_link(arg)
      # {Chat1.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chat1.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Chat1Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
