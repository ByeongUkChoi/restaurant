defmodule Restaurant.Order.Orders do
  alias Restaurant.Order.Menu

  @spec get_menus :: list(Menu.t())
  def get_menus() do
    [
      %Menu{id: 1, name: "tea", price: 1000},
      %Menu{id: 2, name: "coffee", price: 1500},
      %Menu{id: 3, name: "juice", price: 2000}
    ]
  end
end
