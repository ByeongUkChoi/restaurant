defmodule Restaurant.Kitchen.Stove.BurnerSupervisor do
  use Supervisor

  alias Restaurant.Kitchen.Stove.Burner

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def add_worker() do
    Supervisor.start_child(__MODULE__, Burner)
  end

  @impl true
  def init(:no_args) do
    children = [{Burne, []}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
