defmodule Restaurant.Kitchen.Burner do
  @moduledoc """
  on/off
  """
  use GenServer, restart: :transient

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def turn_off() do
    GenServer.cast(__MODULE__, :turn_off)
  end

  # Server
  def init(:no_args) do
    {:ok, nil}
  end

  def handle_cast(:turn_off, _state) do
    {:stop, :normal, nil}
  end
end
