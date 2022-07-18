defmodule Restaurant.Kitchen.Stove.Supervisor do
  use Supervisor

  alias Restaurant.Kitchen.Stove.Burner
  alias Restaurant.Kitchen.Stove.Controller

  def start_link(burners_count) do
    Supervisor.start_link(__MODULE__, burners_count, name: __MODULE__)
  end

  @impl true
  def init(burners_count) do
    burners = 1..burners_count |> Enum.map(&Supervisor.child_spec({Burner, []}, id: &1))
    children = burners ++ [{Controller, []}]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
