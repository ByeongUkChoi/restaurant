defmodule Restaurant.Kitchen.Stove do
  @moduledoc """
  have burners and control them.

  turn on burner and set timer
  """
  use GenServer

  alias Restaurant.Kitchen.Burner

  # API
  def start_link(burner_count) do
    GenServer.start_link(__MODULE__, burner_count, name: __MODULE__)
  end

  def get_burners() do
    GenServer.call(__MODULE__, :get_burners)
  end

  def turn_on(index, time) do
    GenServer.cast(__MODULE__, {:turn_on, index, time})
  end

  # Server
  def init(burner_count) do
    burners =
      if burner_count > 0 do
        1..burner_count
        |> Enum.map(fn _ ->
          {:ok, pid} = Burner.start_link(nil)
          %{pid: pid, status: false, timer: 0}
        end)
      else
        []
      end

    {:ok, burners}
  end

  def handle_call(:get_burners, _from, burners) do
    {:reply, burners, burners}
  end

  def handle_cast({:turn_on, index, time}, burners) do
    %{pid: pid} = Enum.at(burners, index)
    Burner.turn_on(pid)

    if time > 0 do
      Process.send_after(self(), {:timer, pid}, 0)
    end

    updated_burners =
      burners
      |> Enum.map(fn
        %{pid: ^pid} = burner -> burner |> Map.put(:status, true) |> Map.put(:timer, time)
        burner -> burner
      end)

    {:noreply, updated_burners}
  end

  def handle_continue({:timer, pid}, 0) do
    Burner.turn_off(pid)
    {:stop, :normal, nil}
  end

  def handle_continue({:timer, burner}, remaining_time) do
    Process.send_after(self(), {:timer, burner}, 1000)
    {:noreply, remaining_time - 1}
  end
end
