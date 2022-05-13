defmodule Restaurant.Kitchen.EspressoMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  @type state :: %{
          group_count: non_neg_integer(),
          groups: list(%{required(:id) => integer(), required(:time) => non_neg_integer()})
        }
  @extract_time 15

  # API
  def start_link(group_count) do
    GenServer.start_link(__MODULE__, group_count, name: __MODULE__)
  end

  def extract(group_id) do
    GenServer.cast(__MODULE__, {:extract, group_id})
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  # Server
  def init(group_count) do
    state = %{group_count: group_count, groups: Enum.map(1..group_count, &%{id: &1, time: 0})}
    {:ok, state}
  end

  def handle_cast({:extract, group_id}, state) do
    state =
      state
      |> Map.update!(:groups, fn groups ->
        groups
        |> Enum.map(fn
          %{id: ^group_id, time: 0} = group ->
            Process.send_after(self(), :timer, 1000)
            Map.put(group, :time, @extract_time)

          group ->
            group
        end)
      end)

    {:noreply, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
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
