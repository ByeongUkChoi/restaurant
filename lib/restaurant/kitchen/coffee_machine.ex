defmodule Restaurant.Kitchen.CoffeeMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  alias Restaurant.Kitchen.CompletedMenu
  alias Restaurant.Orders.Menu

  @type state :: %{
          materials: %{beans: non_neg_integer(), milk: non_neg_integer()},
          groups_count: non_neg_integer(),
          groups:
            list(%{
              required(:id) => integer(),
              required(:menu) => Menu.t() | nil,
              required(:time) => non_neg_integer()
            })
        }

  @recipe %{americano: %{beans: 20}, latte: %{beans: 20, milk: 160}}
  @extract_time 5

  # API
  def start_link(worker_supervisor) do
    GenServer.start_link(__MODULE__, worker_supervisor, name: __MODULE__)
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
  def init(worker_supervisor) do
    Process.send_after(self(), {:regist_workers, worker_supervisor}, 0)

    {:ok, nil}
  end

  def handle_info({:regist_workers, worker_supervisor}, _) do
    workers =
      worker_supervisor
      |> Supervisor.which_children()
      |> Enum.map(fn {id, pid, _, _} ->
        %{id: id, pid: pid, menu: nil, time: 0}
      end)

    state = %{
      groups_count: length(workers),
      materials: %{beans: 1000, milk: 1000},
      groups: workers
    }

    {:noreply, state}
  end

  def handle_cast({:extract, group_id, menu}, state) do
    if remaining_time(state, group_id) == 0 do
      Process.send_after(self(), {:timer, group_id}, 0)

      state =
        state
        |> set_menu(group_id, menu)
        |> pop_materials(menu)
        |> update_timer(group_id, @extract_time)

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:put_material, material, amount}, state) do
    {:noreply, state |> update_in([:materials, material], &(&1 + amount))}
  end

  def handle_info({:timer, group_id}, state) do
    remaining_time = remaining_time(state, group_id)

    if remaining_time > 0 do
      Process.send_after(self(), {:timer, group_id}, 1000)
      update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
      state = update_timer(state, group_id, update_time)

      {:noreply, state}
    else
      menu = get_menu(state, group_id)
      CompletedMenu.put(menu)
      state = state |> set_menu(group_id, nil)
      {:noreply, state}
    end
  end

  defp remaining_time(state, group_id) do
    Enum.find_value(state.groups, &(&1.id == group_id && &1.time))
  end

  defp get_menu(state, group_id) do
    state.groups |> Enum.find_value(&(&1.id == group_id && &1.menu))
  end

  defp set_menu(state, group_id, menu) do
    state
    |> Map.update!(:groups, fn groups ->
      groups
      |> Enum.map(fn
        %{id: ^group_id} = group -> Map.put(group, :menu, menu)
        group -> group
      end)
    end)
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

  defp update_timer(state, group_id, time) do
    state
    |> Map.update!(:groups, fn groups ->
      groups
      |> Enum.map(fn
        %{id: ^group_id} = group -> Map.put(group, :time, time)
        group -> group
      end)
    end)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
