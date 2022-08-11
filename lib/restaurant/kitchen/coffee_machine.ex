defmodule Restaurant.Kitchen.CoffeeMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  alias Restaurant.Orders.Menu
  alias Restaurant.Kitchen.CoffeeMachine.Worker
  alias Restaurant.Kitchen.CoffeeMachine.Stash

  @type state :: %{
          materials: %{beans: non_neg_integer(), milk: non_neg_integer()},
          groups:
            list(%{
              required(:id) => integer(),
              required(:menu) => Menu.t() | nil,
              required(:time) => non_neg_integer()
            })
        }

  @recipe %{americano: %{beans: 20}, latte: %{beans: 20, milk: 160}}

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  @spec extract(integer(), Menu.t()) :: :ok
  def extract(group_id, menu) do
    GenServer.cast(__MODULE__, {:extract, group_id, menu})
  end

  def put_material(material, amount) do
    GenServer.cast(__MODULE__, {:put_material, material, amount})
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  # Server
  def init(:no_args) do
    state = %{materials: %{beans: 1000, milk: 1000}, groups: []}

    {:ok, state}
  end

  def handle_info(:fetch_state, state) do
    state = state |> Map.update!(:groups, fn _groups -> Stash.state() end)

    Phoenix.PubSub.broadcast(Restaurant.PubSub, "restaurant_live", :fetch_state)

    {:noreply, state}
  end

  def handle_cast({:extract, group_id, menu}, state) do
    pid = get_pid(group_id, state)

    if remaining_time(state, group_id) == 0 do
      Worker.extract(menu, pid)
      state = pop_materials(state, menu)

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:put_material, material, amount}, state) do
    {:noreply, state |> update_in([:materials, material], &(&1 + amount))}
  end

  defp get_pid(group_id, state) do
    state |> Map.get(:groups) |> Enum.find_value(&(&1.id == group_id && &1.pid))
  end

  defp remaining_time(state, group_id) do
    Enum.find_value(state.groups, &(&1.id == group_id && &1.time))
  end

  defp pop_materials(state, menu) do
    @recipe
    |> Map.get(String.to_atom(menu.name))
    |> Enum.map(fn {material, amount} ->
      if get_in(state, [:materials, :material]) < amount do
        raise "Need material=#{material}"
      end

      {material, amount}
    end)
    |> Enum.reduce(state, fn {material, amount}, state ->
      state
      |> update_in([:materials, material], &(&1 - amount))
    end)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
