defmodule Restaurant.OrderedList do
  @moduledoc """
  order queue
  """
  use GenServer

  alias Restaurant.Orders.Order

  @type state :: list(Order.t())

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec get(Order.id()) :: Order.t() | nil
  def get(order_id) do
    GenServer.call(__MODULE__, {:get, order_id})
  end

  def put(item) do
    GenServer.cast(__MODULE__, {:put, item})
  end

  @spec delete(integer()) :: :ok | :error
  def delete(menu_id) do
    GenServer.call(__MODULE__, {:delete, menu_id})
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

  def handle_call({:get, order_id}, _from, list) do
    {:reply, Enum.find(list, &(&1.id == order_id)), list}
  end

  def handle_call({:delete, menu_id}, _from, list) do
    if index = Enum.find_index(list, &(&1 == menu_id)) do
      {:reply, :ok, List.delete_at(list, index)}
    else
      {:reply, :error, list}
    end
  end

  def handle_call(:list, _from, list) do
    {:reply, list, list}
  end
end
