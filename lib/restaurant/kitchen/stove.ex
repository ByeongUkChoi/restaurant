defmodule Restaurant.Kitchen.Stove do
  @moduledoc """
  have burners and control them.

  TODO: turn on burner
  """
  use GenServer

  def start_link(burner_count) do
    GenServer.start_link(__MODULE__, burner_count, name: __MODULE__)
  end

  def init(burner_count) do
    {:ok, burner_count}
  end
end
