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

  def subtract(amount) do
    GenServer.call(__MODULE__, {:subtract, amount})
  end

  def amount() do
    GenServer.call(__MODULE__, :amount)
  end

  def init(_) do
    {:ok, 0}
  end

  def handle_call({:save, save_amount}, _from, amount) do
    {:reply, :ok, save_amount + amount}
  end

  def handle_call({:subtract, subtraction_amount}, _from, amount) do
    if amount >= subtraction_amount do
      {:reply, :ok, amount - subtraction_amount}
    else
      {:reply, :error, amount}
    end
  end

  def handle_call(:amount, _from, amount) do
    {:reply, amount, amount}
  end
end
