defmodule Restaurant.Orders.Menu do
  defstruct [:id, :name, :price]

  @type t :: %__MODULE__{}
  @type id :: integer()
end
