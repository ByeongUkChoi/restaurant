defmodule Restaurant.Kitchen.CoffeeMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  @type state :: %{
          groups_count: non_neg_integer(),
          groups:
            list(%{
              required(:id) => integer(),
              required(:menu) => menu() | nil,
              required(:time) => non_neg_integer()
            }),
          results: []
        }
  @type menu :: :americano | :latte

  @extract_time 15

  # API
  def start_link(groups_count) do
    GenServer.start_link(__MODULE__, groups_count, name: __MODULE__)
  end

  @spec extract(integer(), menu()) :: :ok
  def extract(group_id, menu) do
    GenServer.cast(__MODULE__, {:extract, group_id, menu})
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  @spec put(menu()) :: menu() | nil
  def put(menu) do
    GenServer.call(__MODULE__, {:put, menu})
  end

  # Server
  def init(groups_count) do
    state = %{
      groups_count: groups_count,
      groups: Enum.map(1..groups_count, &%{id: &1, menu: nil, time: 0}),
      results: []
    }

    {:ok, state}
  end

  def handle_cast({:extract, group_id, menu}, state) do
    if remaining_time(state, group_id) == 0 do
      Process.send_after(self(), {:timer, group_id}, 0)

      state =
        state
        |> set_menu(group_id, menu)
        |> update_timer(group_id, @extract_time)

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_info({:timer, group_id}, state) do
    remaining_time = remaining_time(state, group_id)

    if remaining_time > 0 do
      Process.send_after(self(), {:timer, group_id}, 1000)
      update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
      state = update_timer(state, group_id, update_time)

      {:noreply, state}
    else
      menu = get_menu(state, group_id)

      state =
        state
        |> set_menu(group_id, nil)
        |> Map.update!(:results, &(&1 ++ [menu]))

      {:noreply, state}
    end
  end

  defp remaining_time(state, group_id) do
    Enum.find_value(state.groups, &(&1.id == group_id && &1.time))
  end

  defp get_menu(state, group_id) do
    state.groups |> Enum.find_value(&(&1.id == group_id && &1.menu))
  end

  defp set_menu(state, group_id, menu) do
    state
    |> Map.update!(:groups, fn groups ->
      groups
      |> Enum.map(fn
        %{id: ^group_id, menu: nil} = group -> Map.put(group, :menu, menu)
        group -> group
      end)
    end)
  end

  defp update_timer(state, group_id, time) do
    state
    |> Map.update!(:groups, fn groups ->
      groups
      |> Enum.map(fn
        %{id: ^group_id} = group -> Map.put(group, :time, time)
        group -> group
      end)
    end)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:put, menu}, _from, state) do
    if Enum.member?(state.results, menu) do
      state =
        state
        |> Map.update!(:results, &(&1 -- [menu]))

      {:reply, menu, state}
    else
      {:reply, nil, state}
    end
  end
end
