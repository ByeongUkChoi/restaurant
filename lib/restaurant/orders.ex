defmodule Restaurant.Orders do
  alias Restaurant.Orders.Menu

  @spec get_menus :: list(Menu.t())
  def get_menus() do
    [
      %Menu{id: 1, name: "americano", price: 1500},
      %Menu{id: 2, name: "latte", price: 2000}
    ]
  end

  @spec get_menu(integer()) :: Menu.t() | nil
  def get_menu(id) do
    get_menus() |> Enum.find(&(&1.id == id))
  end
end
