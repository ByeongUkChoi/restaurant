defmodule Restaurant.Orders.Order do
  defstruct [:id, :menu]

  @type t :: %__MODULE__{}
  @type id :: integer()
end
