defmodule Restaurant.OrderList do
  @moduledoc """
  order queue
  """
  use GenServer

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def enqueue(item) do
    GenServer.cast(__MODULE__, {:enqueue, item})
  end

  def denqueue() do
    GenServer.cast(__MODULE__, :denqueue)
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  # Server
  def init(_) do
    {:ok, :queue.new()}
  end

  def handle_cast({:enqueue, item}, queue) do
    {:noreply, :queue.in(item, queue)}
  end

  def handle_call(:denqueue, _from, queue) do
    {{:value, item}, queue} = :queue.out(queue)
    {:reply, item, queue}
  end

  def handle_call(:list, _from, queue) do
    {:reply, :queue.to_list(queue), queue}
  end
end
