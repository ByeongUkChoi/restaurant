defmodule Restaurant.Orders do
  alias Restaurant.Orders.{Order, Menu}
  alias Restaurant.OrderedList

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

  @spec place(integer(), function()) :: Order.t()
  def place(menu_id, fn_save_money) do
    unixtime_str = DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> Integer.to_string()
    random_str = Enum.random(0..999) |> Integer.to_string() |> String.pad_leading(3, "0")
    id = (unixtime_str <> random_str) |> String.to_integer()
    order = %Order{id: id, menu: get_menu(menu_id)}
    OrderedList.put(order)
    fn_save_money.(order.menu.price)
    order
  end

  def get_orders() do
    OrderedList.list()
  end

  def get_order(order_id) do
    OrderedList.get(order_id)
  end

  def delivery_order(order_id) do
    OrderedList.delete(order_id)
  end

  def cancel_order(order_id) do
    OrderedList.delete(order_id)
  end
end
