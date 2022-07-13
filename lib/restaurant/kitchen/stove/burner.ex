defmodule Restaurant.Kitchen.Stove.Burner do
  @moduledoc """
  on/off
  """
  use GenServer, restart: :transient

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def turn_on(pid) do
    GenServer.call(pid, :turn_on)
  end

  def turn_off(pid) do
    GenServer.call(pid, :turn_off)
  end

  # Server
  def init(:no_args) do
    {:ok, false}
  end

  def handle_call(:get_status, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:turn_on, _from, _state) do
    {:reply, :ok, true}
  end

  def handle_call(:turn_off, _from, _state) do
    {:reply, :ok, false}
  end
end
