defmodule Restaurant.Kitchen.CoffeeMachine.Supervisor do
  @moduledoc """
  """
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    children = [
      Restaurant.Kitchen.CoffeeMachine.Stash,
      Restaurant.Kitchen.CoffeeMachine.WorkerSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
