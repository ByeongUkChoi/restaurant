defmodule Restaurant.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Restaurant.Repo,
      # Start the Telemetry supervisor
      RestaurantWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Restaurant.PubSub},
      # Start the Endpoint (http/https)
      RestaurantWeb.Endpoint,
      # Start a worker by calling: Restaurant.Worker.start_link(arg)
      # {Restaurant.Worker, arg}
      {Restaurant.Kitchen.Stove.Supervisor, 4},
      # New CoffeeMachineSupervisor
      Restaurant.Kitchen.CoffeeMachine.Supervisor,
      Restaurant.OrderedList,
      Restaurant.Kitchen.CompletedMenu,
      Restaurant.MoneyStorage
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Restaurant.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RestaurantWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
