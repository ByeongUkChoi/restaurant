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
            Process.send_after(self(), {:timer, group_id}, 0)
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

  def handle_info({:timer, group_id}, state) do
    state =
      state
      |> Map.update!(:groups, fn groups ->
        groups
        |> Enum.map(fn
          %{id: ^group_id, time: 0} = group ->
            group

          %{id: ^group_id, time: time} = group ->
            Process.send_after(self(), {:timer, group_id}, 1000)
            update_time = if time - 1 > 0, do: time - 1, else: 0
            Map.put(group, :time, update_time)

          group ->
            group
        end)
      end)

    {:noreply, state}
  end
end
