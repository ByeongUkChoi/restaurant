defmodule Restaurant.Kitchen.CoffeeMachine.Consumer do
  use GenStage

  def start_link(), do: GenStage.start_link(__MODULE__, :ok)

  def init(:ok) do
    state = %{producer: Restaurant.Kitchen.CoffeeMachine.Producer}

    {:consumer, state, subscribe_to: [{state.producer, []}]}
  end

  def handle_info(_, state), do: {:noreply, [], state}

  def handle_events(events, _from, state) when is_list(events) and length(events) > 0 do
    # events handling here

    {:noreply, [], state}
  end

  def handle_events(_events, _from, state), do: {:noreply, [], state}
end
