defmodule Restaurant.Kitchen.EspressoMachine do
  @moduledoc """
  extract esspreso
  """
  use GenServer

  # API
  def start_link(_group_count) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def extract() do
    GenServer.cast(__MODULE__, :extract)
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  # Server
  def init(_) do
    {:ok, nil}
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

  def handle_info(:timer, nil) do
    {:noreply, nil}
  end

  def handle_info(:timer, remaining_time) when remaining_time <= 0 do
    {:noreply, remaining_time}
  end

  def handle_info(:timer, remaining_time) do
    Process.send_after(self(), :timer, 1000)
    update_time = if remaining_time - 1 > 0, do: remaining_time - 1, else: 0
    {:noreply, update_time}
  end
end
