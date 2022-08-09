defmodule Restaurant.Kitchen.CoffeeMachineSupervisor do
  @moduledoc """
  """
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    children = [Restaurant.Kitchen.CoffeeMachine.Stash]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
