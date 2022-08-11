defmodule Restaurant.Kitchen.CoffeeMachine.Stash do
  use GenServer

  @type state ::
          list(%{
            required(:id) => integer(),
            required(:menu) => map() | nil,
            required(:time) => non_neg_integer()
          })

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def put_state(id, menu, time) do
    GenServer.cast(__MODULE__, {:state, id, menu, time})
  end

  def init(:no_args) do
    {:ok, []}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:state, id, menu, time}, list) do
    item = %{id: id, menu: menu, time: time}

    state =
      case Enum.find_index(list, &(&1.id == id)) do
        nil -> [item | list]
        index -> List.update_at(list, index, fn _ -> item end)
      end

    {:noreply, state}
  end
end
