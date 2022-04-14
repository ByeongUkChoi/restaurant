defmodule Restaurant.Kitchen.Stove do
  @moduledoc """
  have burners and control them.

  TODO: turn on burner
  """
  use GenServer

  alias Restaurant.Kitchen.Burner

  # API
  def start_link(burner_count) do
    GenServer.start_link(__MODULE__, burner_count, name: __MODULE__)
  end

  def turn_on(time) do
    GenServer.cast(__MODULE__, {:turn_on, time})
  end

  # Server
  def init(burner_count) do
    {:ok, %{max_count: burner_count, burners: MapSet.new()}}
  end

  def handle_cast({:turn_on}, %{max_count: max_count, burners: burners}) do
    if MapSet.size(burners) < max_count do
      {:ok, pid} = Burner.start_link(nil)
      {:noreply, %{max_count: max_count, burners: MapSet.put(burners, pid)}}
    end
  end
end
