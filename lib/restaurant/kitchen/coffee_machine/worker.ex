defmodule Restaurant.Kitchen.CoffeeMachine.Worker do
  use GenServer, restart: :transient

  alias Restaurant.Orders.Menu
  alias Restaurant.Kitchen.CompletedMenu
  alias Restaurant.Kitchen.CoffeeMachine.Stash

  @type state :: %{
          required(:id) => pos_integer(),
          required(:menu) => Menu.t() | nil,
          required(:time) => non_neg_integer()
        }

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def extract(menu, pid) do
    GenServer.cast(pid, {:extract, menu})
  end

  def init(id) do
    Process.send_after(self(), :init_state, 1000)
    {:ok, %{id: id, menu: nil, time: 0}}
  end

  def terminate(_reason, state) do
    Stash.put_worker(state.id, state.menu, state.time)
    :normal
  end

  def handle_info(:init_state, state) do
    Process.send_after(self(), :put_stash, 0)

    if worker = Stash.get_worker(state.id) do
      Process.send_after(self(), :timer, 0)
      {:noreply, state |> Map.put(:menu, worker.menu) |> Map.put(:time, worker.time)}
    else
      {:noreply, state}
    end
  end

  def handle_info(:timer, %{menu: nil} = state) do
    {:noreply, Map.put(state, :time, 0)}
  end

  def handle_info(:timer, %{time: 0} = state) do
    Process.send_after(self(), :put_stash, 0)
    CompletedMenu.put(state.menu)
    Stash.put_worker(state.id, nil, state.time)
    {:noreply, state |> Map.put(:menu, nil)}
  end

  def handle_info(:timer, state) do
    if Enum.random(1..10) == 10 do
      raise "worker crash test!"
    end

    Stash.put_worker(state.id, state.menu, state.time)

    remaining_time = state.time
    update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0

    Process.send_after(self(), :timer, 1000)
    {:noreply, Map.put(state, :time, update_time)}
  end

  def handle_info(:put_stash, state) do
    Stash.put_worker(state.id, state.menu, state.time)
    {:noreply, state}
  end

  def handle_cast({:extract, menu}, %{menu: nil} = state) do
    Process.send_after(self(), :timer, 0)
    {:noreply, state |> Map.put(:menu, menu) |> Map.put(:time, 5)}
  end

  def handle_cast({:extract, _menu, _parent}, state) do
    {:noreply, state}
  end
end
