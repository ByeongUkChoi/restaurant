defmodule Restaurant.OrderQueue do
  @moduledoc """
  order queue
  """
  use GenServer

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def enqueue(item) do
    GenServer.call(__MODULE__, {:enqueue, item})
  end

  # Server
  def init(_) do
    {:ok, :queue.new()}
  end

  def handle_cast({:enqueue, item}, queue) do
    {:noreply, :queue.in(item, queue)}
  end
end
