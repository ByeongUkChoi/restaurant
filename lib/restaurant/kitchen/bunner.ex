defmodule Restaurant.Kitchen.Burner do
  @moduledoc """
  Heat for a period of time(second)
  """
  use GenServer, restart: :transient

  # API

  def start_link(operating_time) do
    GenServer.start_link(__MODULE__, operating_time)
  end

  def show_remaining_time(pid) do
    GenServer.call(pid, :operating_time)
  end

  # Server
  def init(operating_time) do
    {:ok, operating_time, {:continue, :heat}}
  end

  def handle_continue(:heat, 0) do
    {:stop, :normal, nil}
  end

  def handle_continue(:heat, remaining_time) do
    Process.send_after(self(), :heat, 1000)
    {:noreply, remaining_time - 1}
  end

  def handle_call(:operating_time, _from, operating_time) do
    {:reply, operating_time, operating_time}
  end
end
