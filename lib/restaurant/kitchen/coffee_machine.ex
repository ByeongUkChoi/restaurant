defmodule Restaurant.Kitchen.CoffeeMachine do
  @moduledoc """
  extract esspreso
  """

  alias Restaurant.Kitchen.CoffeeMachine.WorkerSupervisor
  alias Restaurant.Kitchen.CoffeeMachine.Worker
  alias Restaurant.Kitchen.CoffeeMachine.Stash

  @recipe %{americano: %{beans: 20}, latte: %{beans: 20, milk: 160}}

  def extract(menu, id) do
    with {:ok, worker} <- get_worker_pid(id) do
      @recipe
      |> Map.get(String.to_atom(menu.name))
      |> Enum.each(fn {material, amount} -> Stash.take_out_material(material, amount) end)

      Worker.extract(menu, worker)
    end
  end

  defp get_worker_pid(id) do
    WorkerSupervisor
    |> Supervisor.which_children()
    |> Enum.find_value(&(elem(&1, 0) == id && elem(&1, 1)))
    |> case do
      nil -> {:error, :not_found_worker}
      worker -> {:ok, worker}
    end
  end

  def state() do
    Stash.state()
  end

  def add_material(material, amount) do
    Stash.add_material(material, amount)
  end
end
