defmodule Restaurant.Kitchen.CoffeeMachine do
  @moduledoc """
  extract esspreso
  """

  alias Restaurant.Kitchen.CoffeeMachine.Worker
  alias Restaurant.Kitchen.CoffeeMachine.Stash

  def extract(menu, pid) do
    Worker.extract(menu, pid)
  end

  def state() do
    Stash.state()
  end
end
