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
  def place(menu_id, save_money_fn) do
    unixtime_str = DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> Integer.to_string()
    random_str = Enum.random(0..999) |> Integer.to_string() |> String.pad_leading(3, "0")
    id = (unixtime_str <> random_str) |> String.to_integer()
    order = %Order{id: id, menu: get_menu(menu_id)}
    OrderedList.put(order)
    save_money_fn.(order.menu.price)
    order
  end

  def cancel_order(order_id, put_money_fn) do
    with order when order != nil <- OrderedList.get(order_id),
         :ok <- OrderedList.delete(order_id) do
      put_money_fn.(order.menu.price)
    end
  end

  def cancel_order(order_id) do
    OrderedList.delete(order_id)
  end

  def get_orders() do
    OrderedList.list()
  end

  def get_order(order_id) do
    OrderedList.get(order_id)
  end

  def delivery_order(order_id, put_completed_menu_fn) do
    order = OrderedList.get(order_id)
    OrderedList.delete(order_id)
    put_completed_menu_fn.(order.menu.id)
  end
end
