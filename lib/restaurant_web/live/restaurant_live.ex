defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  import Transformer

  alias Restaurant.Kitchen.Stove
  alias Restaurant.Kitchen.CoffeeMachine
  alias Restaurant.Kitchen.CompletedMenu
  alias Restaurant.Orders
  alias Restaurant.MoneyStorage

  def render(assigns) do
    ~H"""
    <label>money</label>
    <p><%= @money %></p>
    <.live_component module={RestaurantWeb.RestaurantLive.KioskComponent} id="kiosk" menus={@menus} />
    <.live_component module={RestaurantWeb.RestaurantLive.OrderedListComponent} id="ordered_list" orders={@orders}/>
    <.live_component module={RestaurantWeb.RestaurantLive.CoffeeMachineComponent} id="coffee_machine" state={@coffee_machine} menus={@menus} />
    <label>completed menus</label>
    <%= for menu <- @completed_menus do %>
      <p><%= menu.name %></p>
    <% end %>

    <.live_component module={RestaurantWeb.RestaurantLive.StoveComponent} id="stove" burners={@burners} />
    """
  end

  def mount(_params, _session, socket) do
    start_timer(1000)

    {:ok, assign(socket, get_state())}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  def handle_info(:clock_tick, socket) do
    {:noreply, assign(socket, get_state())}
  end

  def handle_event("order", %{"menu_id" => menu_id_str}, socket) do
    menu_id = to_integer_or(menu_id_str)
    Orders.place(menu_id, &MoneyStorage.save/1)

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("cancel", %{"order_id" => order_id_str}, socket) do
    order_id = to_integer_or(order_id_str)
    Orders.cancel_order(order_id, &MoneyStorage.put/1)

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("extract_coffee", %{"id" => id_str, "menu_id" => menu_id_str}, socket) do
    id = to_integer_or(id_str)
    menu_id = to_integer_or(menu_id_str)
    menu = Orders.get_menu(menu_id)
    CoffeeMachine.extract(id, menu)

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("delivery", %{"order_id" => order_id_str}, socket) do
    order_id = to_integer_or(order_id_str)

    with %{menu: %{id: menu_id}} <- Orders.get_order(order_id),
         completed_menu when completed_menu != nil <- CompletedMenu.get(menu_id) do
      Orders.delivery_order(order_id, &CompletedMenu.delete/1)
    end

    {:noreply, assign(socket, get_state())}
  end

  # stove

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(30)

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("turn_off", %{"index" => index, "value" => _value}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_off()

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("plus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.increase_timer(30)

    {:noreply, assign(socket, get_state())}
  end

  def handle_event("minus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.decrease_timer(30)

    {:noreply, assign(socket, get_state())}
  end

  defp get_state() do
    [
      menus: Orders.get_menus(),
      burners: Stove.get_burners(),
      orders: Orders.get_orders(),
      coffee_machine: CoffeeMachine.state(),
      completed_menus: CompletedMenu.get_all(),
      money: MoneyStorage.amount()
    ]
  end
end
