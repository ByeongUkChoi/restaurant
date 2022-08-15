defmodule Restaurant.Kitchen.CoffeeMachine.Stash do
  use GenServer

  @type state :: %{
          materials: %{beans: non_neg_integer(), milk: non_neg_integer()},
          workers:
            list(%{
              required(:id) => integer(),
              required(:menu) => map() | nil,
              required(:time) => non_neg_integer()
            })
        }

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def get_worker(id) do
    GenServer.call(__MODULE__, {:get_state, id})
  end

  def put_worker(id, menu, time) do
    GenServer.cast(__MODULE__, {:put_worker, id, menu, time})
  end

  def init(:no_args) do
    {:ok, []}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_worker, id}, _from, state) do
    worker = state |> Map.get(:workers) |> Enum.find(&(&1.id == id))
    {:reply, worker, state}
  end

  def put_worker({:put_worker, id, menu, time}, %{workers: workers} = state) do
    worker = %{id: id, menu: menu, time: time}

    workers =
      case Enum.find_index(workers, &(&1.id == id)) do
        nil -> [worker | workers]
        index -> List.update_at(workers, index, fn _ -> worker end)
      end

    {:noreply, Map.put(state, :workers, workers)}
  end
end
