defmodule Restaurant.Kitchen.Burner do
  @moduledoc """
  on/off
  """
  use GenServer, restart: :transient

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def turn_on() do
    GenServer.call(__MODULE__, :turn_on)
  end

  def turn_off() do
    GenServer.call(__MODULE__, :turn_off)
  end

  # Server
  def init(:no_args) do
    {:ok, false}
  end

  def handle_call(:turn_on, _from, _state) do
    {:reply, :ok, true}
  end

  def handle_call(:turn_off, _from, _state) do
    {:reply, :ok, false}
  end
end
