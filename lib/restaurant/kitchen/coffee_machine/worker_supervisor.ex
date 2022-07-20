defmodule Restaurant.Kitchen.CoffeeMachine.WorkerSupervisor do
  use Supervisor

  alias Restaurant.Kitchen.CoffeeMachine.Worker

  def start_link(workers_count) do
    Supervisor.start_link(__MODULE__, workers_count, name: __MODULE__)
  end

  @impl true
  def init(workers_count) do
    children = 1..workers_count |> Enum.map(&Supervisor.child_spec({Worker, []}, id: &1))

    Supervisor.init(children, strategy: :one_for_one)
  end
end
