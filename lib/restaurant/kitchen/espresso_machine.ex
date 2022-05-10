defmodule Restaurant.Kitchen.EspressoMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  @type state :: %{
          group_count: non_neg_integer(),
          groups: list(%{required(:id) => integer(), required(:time) => non_neg_integer()})
        }

  # API
  def start_link(group_count) do
    GenServer.start_link(__MODULE__, group_count, name: __MODULE__)
  end

  def extract() do
    GenServer.cast(__MODULE__, :extract)
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  # Server
  def init(group_count) do
    state = %{group_count: group_count, groups: Enum.map(1..group_count, &%{id: &1, time: 0})}
    {:ok, state}
  end

  def handle_cast(:extract, nil) do
    Process.send_after(self(), :timer, 1000)
    {:noreply, 30}
  end

  def handle_cast(:extract, remaining_time) do
    {:noreply, remaining_time}
  end

  def handle_call(:status, _from, remaining_time) do
    {:reply, remaining_time, remaining_time}
  end

  def handle_info({:timer, id}, state) do
    remaining_time = Enum.find_value(state, &(&1.id == id && &1.time))

    if remaining_time > 0 do
      Process.send_after(self(), {:timer, id}, 1000)
      update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
      {:noreply, update_time}
    else
      {:noreply, remaining_time}
    end
  end
end
