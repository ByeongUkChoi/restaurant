defmodule Restaurant.Kitchen.Burner do
  @moduledoc """
  turn on/off
  """
  use GenServer, restart: :transient

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def turn_on() do
    GenServer.cast(__MODULE__, :turn_on)
  end

  def turn_off() do
    GenServer.cast(__MODULE__, :turn_off)
  end

  # Server
  def init(:no_args) do
    {:ok, false}
  end

  def handle_cast(:turn_on, _status) do
    {:noreply, true}
  end

  def handle_cast(:turn_off, _status) do
    {:noreply, false}
  end
end
