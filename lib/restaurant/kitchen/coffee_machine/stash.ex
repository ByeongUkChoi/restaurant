defmodule Restaurant.Kitchen.CoffeeMachine.Stash do
  use GenServer

  @type state :: %{
          groups:
            list(%{
              required(:id) => integer(),
              required(:menu) => map() | nil,
              required(:time) => non_neg_integer()
            })
        }

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def init(:no_args) do
    {:ok, %{groups: []}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
