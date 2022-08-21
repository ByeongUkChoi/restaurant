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
    GenServer.call(__MODULE__, {:get_worker, id})
  end

  def add_material(material, amount) do
    GenServer.cast(__MODULE__, {:add_material, material, amount})
  end

  def take_out_material(material, amount) do
    GenServer.call(__MODULE__, {:take_out_material, material, amount})
  end

  def put_worker(id, menu, time) do
    GenServer.cast(__MODULE__, {:put_worker, id, menu, time})
  end

  def init(:no_args) do
    {:ok, %{materials: %{beans: 1000, milk: 1000}, workers: []}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_worker, id}, _from, state) do
    worker = state |> Map.get(:workers) |> Enum.find(&(&1.id == id))
    {:reply, worker, state}
  end

  def handle_call({:take_out_material, material, amount}, _from, state) do
    remain_amount = get_in(state, [:materials, material])

    with {:has_material, remain_amount} when remain_amount != nil <-
           {:has_material, remain_amount},
         {:enable_take_out, true} <- {:enable_take_out, remain_amount >= amount} do
      put_in(state, [:materials, material], remain_amount - amount)
      {:reply, :ok, state}
    else
      _ -> {:reply, :error, state}
    end
  end

  def handle_cast({:add_material, material, amount}, _from, state) do
    remain_amount = state.materials |> Map.get(material, 0)
    put_in(state, [:materials, material], remain_amount + amount)
    {:noreply, state}
  end

  def handle_cast({:put_worker, id, menu, time}, %{workers: workers} = state) do
    Phoenix.PubSub.broadcast(Restaurant.PubSub, "restaurant_live", :fetch_state)
    worker = %{id: id, menu: menu, time: time}

    workers =
      case Enum.find_index(workers, &(&1.id == id)) do
        nil -> [worker | workers]
        index -> List.update_at(workers, index, fn _ -> worker end)
      end

    {:noreply, Map.put(state, :workers, workers)}
  end
end
