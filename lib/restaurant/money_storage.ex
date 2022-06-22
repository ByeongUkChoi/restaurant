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

  def put(amount) do
    GenServer.call(__MODULE__, {:put, amount})
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

  def handle_call({:put, put_amount}, _from, amount) do
    if amount >= put_amount do
      {:reply, :ok, amount - put_amount}
    else
      {:reply, :error, amount}
    end
  end

  def handle_call(:amount, _from, amount) do
    {:reply, amount, amount}
  end
end
