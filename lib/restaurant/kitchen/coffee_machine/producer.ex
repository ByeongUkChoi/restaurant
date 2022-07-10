defmodule Restaurant.Kitchen.CoffeeMachine.Producer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, []}
  end

  def handle_info(_, state), do: {:noreply, [], state}

  # public endpoint for events adding
  def add(events), do: GenServer.cast(__MODULE__, {:add, events})

  # just push events to consumers on adding
  def handle_cast({:add, events}, state) when is_list(events) do
    {:noreply, events, state}
  end

  def handle_cast({:add, events}, state), do: {:noreply, [events], state}

  # ignore any demand
  def handle_demand(_, state), do: {:noreply, [], state}
end
