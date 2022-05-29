defmodule Restaurant.OrderList do
  @moduledoc """
  order queue
  """
  use GenServer

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(item) do
    GenServer.cast(__MODULE__, {:put, item})
  end

  # TODO: delete
  def get(item) do
    GenServer.cast(__MODULE__, {:get, item})
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  # Server
  def init(_) do
    {:ok, []}
  end

  def handle_cast({:put, item}, list) do
    {:noreply, list ++ [item]}
  end

  def handle_call({:get, item}, _from, list) do
    if Enum.member?(list, item) do
      {:reply, item, list -- [item]}
    else
      {:reply, nil, list}
    end
  end

  def handle_call(:list, _from, list) do
    {:reply, list, list}
  end
end
