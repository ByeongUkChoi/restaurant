defmodule Restaurant.Kitchen.CompletedMenu do
  @moduledoc """
  completed menus
  """
  use GenServer

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  @spec delete(integer()) :: :ok | :error
  def delete(menu) do
    GenServer.call(__MODULE__, {:delete, menu})
  end

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

  def handle_call({:delete, menu}, _from, menus) do
    if Enum.member?(menus, menu) do
      {:reply, :ok, menus -- [menu]}
    else
      {:reply, :error, menus}
    end
  end

  def handle_cast({:put, menu}, menus) do
    {:noreply, menus ++ [menu]}
  end
end
