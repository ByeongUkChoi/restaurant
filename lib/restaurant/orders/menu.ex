defmodule Restaurant.Orders.Menu do
  defstruct [:id, :name, :price]

  @type t :: %__MODULE__{}
end
