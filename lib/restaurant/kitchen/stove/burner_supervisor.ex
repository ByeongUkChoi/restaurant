defmodule Restaurant.Kitchen.Stove.BurnerSupervisor do
  use Supervisor

  alias Restaurant.Kitchen.Stove.Burner

  def start_link(burners_count) do
    Supervisor.start_link(__MODULE__, burners_count, name: __MODULE__)
  end

  @impl true
  def init(burners_count) do
    children = 1..burners_count |> Enum.map(&Supervisor.child_spec({Burner, []}, id: &1))
    Supervisor.init(children, strategy: :one_for_one)
  end
end
