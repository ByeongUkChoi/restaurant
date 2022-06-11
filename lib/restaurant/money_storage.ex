defmodule Restaurant.MoneyStorage do
  @moduledoc """
  money storage
  """
  use GenServer

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def save(amount) do
    GenServer.call(__MODULE__, {:save, amount})
  end

  def init(_) do
    {:ok, 0}
  end

  def handle_call({:save, amount}, _from, state) do
    {:reply, :ok, state + amount}
  end
end
