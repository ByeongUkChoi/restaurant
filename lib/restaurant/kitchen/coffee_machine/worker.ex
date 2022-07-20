defmodule Restaurant.Kitchen.CoffeeMachine.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    {:ok, nil}
  end
end
