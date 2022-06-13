defmodule Restaurant.Orders do
  alias Restaurant.Orders.{Order, Menu}

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

  def place(menu_id) do
    unixtime_str = DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> Integer.to_string()
    random_str = Enum.random(0..999) |> Integer.to_string() |> String.pad_leading(3, "0")
    id = (unixtime_str <> random_str) |> String.to_integer()
    %Order{id: id, menu: get_menu(menu_id)}
  end
end
