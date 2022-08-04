defmodule Restaurant.Kitchen.CoffeeMachine.Worker do
  use GenServer, restart: :transient

  alias Restaurant.Orders.Menu
  alias Restaurant.Kitchen.CompletedMenu

  @type state :: %{
          required(:menu) => Menu.t() | nil,
          required(:time) => non_neg_integer()
        }

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def extract(menu, pid \\ __MODULE__) do
    GenServer.cast(pid, {:extract, menu})
  end

  def state(pid \\ __MODULE__) do
    GenServer.call(pid, :state)
  end

  def init(:no_args) do
    {:ok, nil}
  end

  def terminate(_reason, _state) do
    # TODO: auto restart
    :normal
  end

  def handle_cast({:extract, menu}, nil) do
    Process.send_after(self(), :timer, 0)
    {:noreply, %{menu: menu, time: 5}}
  end

  def handle_cast({:extract, _menu}, state) do
    {:noreply, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:timer, state) do
    if Enum.random(1..100) == 1 do
      raise "worker crash!"
    end

    remaining_time = state.time

    if remaining_time > 0 do
      Process.send_after(self(), :timer, 1000)
      update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
      state = Map.put(state, :time, update_time)

      {:noreply, state}
    else
      CompletedMenu.put(state.menu)
      {:noreply, nil}
    end
  end
end
