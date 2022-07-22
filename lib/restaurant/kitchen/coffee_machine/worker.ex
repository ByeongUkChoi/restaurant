defmodule Restaurant.Kitchen.CoffeeMachine.Worker do
  use GenServer

  alias Restaurant.Orders.Menu
  alias Restaurant.Kitchen.CompletedMenu

  @type state :: Menu.t() | nil

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def extract(menu) do
    GenServer.call(__MODULE__, {:extract, menu})
  end

  def init(:no_args) do
    {:ok, nil}
  end

  def handle_call({:extract, menu}, _from, nil) do
    Process.send_after(self(), :finish, 5000)
    {:noreply, menu}
  end

  def handle_call({:extract, _menu}, _from, _state) do
    raise "already extracting"
  end

  def handle_info(:finish, menu) do
    CompletedMenu.put(menu)
    {:noreply, nil}
  end
end
