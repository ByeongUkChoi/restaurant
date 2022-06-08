defmodule Restaurant.Kitchen.CompletedMenu do
  @moduledoc """
  completed menus
  """
  use GenServer

  alias Restaurant.Orders.Menu

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  @spec delete(Menu.id()) :: :ok | :error
  def delete(menu_id) do
    GenServer.call(__MODULE__, {:delete, menu_id})
  end

  @spec put(Menu.t()) :: :ok
  def put(menu) do
    GenServer.cast(__MODULE__, {:put, menu})
  end

  # Server
  def init(nil) do
    {:ok, []}
  end

  def handle_call(:get_all, _from, menus) do
    {:reply, menus, menus}
  end

  def handle_call({:delete, menu_id}, _from, menus) do
    if index = Enum.find_index(menus, &(&1.id == menu_id)) do
      {:reply, :ok, List.delete_at(menus, index)}
    else
      {:reply, :error, menus}
    end
  end

  def handle_cast({:put, menu}, menus) do
    {:noreply, List.insert_at(menus, -1, menu)}
  end
end
