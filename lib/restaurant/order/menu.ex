defmodule Restaurant.Order.Menu do
  defstruct [:id, :name, :price]

  @type t :: %__MODULE__{}
end
