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

  @spec delete(any) :: :ok | :error
  def delete(item) do
    GenServer.call(__MODULE__, {:delete, item})
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

  def handle_call({:delete, item}, _from, list) do
    if index = Enum.find_index(list, &(&1.name == item)) do
      {:reply, :ok, List.delete_at(list, index)}
    else
      {:reply, :error, list}
    end
  end

  def handle_call(:list, _from, list) do
    {:reply, list, list}
  end
end
