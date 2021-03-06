defmodule Restaurant.Kitchen.CoffeeMachine.ConsumersSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Want to spawn any consumer module via the single ConsumersSupervisor
  def start_consumer(consumer_module) do
    spec = {consumer_module, []}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def any_consumer?, do: consumers_count() > 0

  def consumers_count do
    %{active: count} = Supervisor.count_children(__MODULE__)
    count
  end
end
