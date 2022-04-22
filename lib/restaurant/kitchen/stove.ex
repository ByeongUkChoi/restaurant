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

  def get_burners_status() do
    GenServer.call(__MODULE__, :get_burners_status)
  end

  def turn_on(index, time) do
    GenServer.cast(__MODULE__, {:turn_on, index, time})
  end

  # Server
  def init(burner_count) do
    burners =
      if burner_count > 0 do
        1..burner_count |> Enum.map(fn _ -> Burner.start_link(nil) |> elem(1) end)
      else
        []
      end

    {:ok, burners}
  end

  def handle_call(:get_burners_status, _from, burners) do
    {:reply, Enum.map(burners, &Burner.get_status/1), burners}
  end

  def handle_cast({:turn_on, index, _time}, burners) do
    burners
    |> Enum.at(index)
    |> Burner.turn_on()

    {:noreply, burners}
  end
end
