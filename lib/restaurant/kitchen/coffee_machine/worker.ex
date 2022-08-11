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

  def extract(menu, pid, parent) do
    GenServer.cast(pid, {:extract, menu, parent})
  end

  def init(id) do
    # CoffeeMachine.regist_worker(self())
    {:ok, %{id: id, menu: nil, time: 0}}
  end

  def terminate(_reason, _state) do
    # TODO: auto restart
    :normal
  end

  def handle_cast({:extract, menu, parent}, nil) do
    Process.send_after(self(), {:timer, parent}, 1000)
    {:noreply, %{menu: menu, time: 5}}
  end

  def handle_cast({:extract, _menu, _parent}, state) do
    {:noreply, state}
  end

  def handle_info({:timer, parent}, state) do
    if Enum.random(1..2) == 1 do
      raise "worker crash test!"
    end

    Process.send_after(self(), {:broadcast, parent}, 0)

    remaining_time = state.time

    if remaining_time > 0 do
      Process.send_after(self(), {:timer, parent}, 1000)
      update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
      state = Map.put(state, :time, update_time)

      {:noreply, state}
    else
      CompletedMenu.put(state.menu)
      {:noreply, nil}
    end
  end

  def handle_info({:broadcast, parent}, state) do
    Stash.Process.send_after(parent, :fetch_state, 0)
    {:noreply, state}
  end
end
