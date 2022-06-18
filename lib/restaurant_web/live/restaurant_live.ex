defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  import Transformer

  alias Restaurant.Kitchen.Stove
  alias Restaurant.Kitchen.CoffeeMachine
  alias Restaurant.Kitchen.CompletedMenu
  alias Restaurant.Orders
  alias Restaurant.OrderedList
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
    """

    # <.live_component module={RestaurantWeb.RestaurantLive.StoveComponent} id="stove" burners={@burners} />
  end

  def mount(_params, _session, socket) do
    start_timer(1000)

    {:ok,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       menus: get_menus(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  def handle_info(:clock_tick, socket) do
    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("order", %{"menu_id" => menu_id_str}, socket) do
    menu_id = Transformer.to_integer_or(menu_id_str)
    order = Orders.place(menu_id)
    OrderedList.put(order)
    MoneyStorage.save(order.menu.price)

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("cancel", %{"order_id" => order_id_str}, socket) do
    order_id = Transformer.to_integer_or(order_id_str)

    with %{} = order <- OrderedList.get(order_id),
         :ok <- OrderedList.delete(order_id),
         :ok <- MoneyStorage.save(-1 * order.menu.price) do
    end

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("delivery", %{"order_id" => order_id_str}, socket) do
    order_id = Transformer.to_integer_or(order_id_str)

    with %{menu: %{id: menu_id} = menu} <- OrderedList.get(order_id),
         completed_menu when completed_menu != nil <- CompletedMenu.get(menu_id),
         :ok <- CompletedMenu.delete(menu_id),
         {:delete_ordered_list, :ok, _} <-
           {:delete_ordered_list, OrderedList.delete(order_id), menu} do
    else
      {:delete_ordered_list, :error, menu} -> CompletedMenu.put(menu)
      _ -> :ok
    end

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(30)

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("turn_off", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_off()

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("plus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.increase_timer(30)

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("minus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.decrease_timer(30)

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  def handle_event("extract_coffee", %{"id" => id_str, "menu_id" => menu_id_str}, socket) do
    id = to_integer_or(id_str)
    menu_id = to_integer_or(menu_id_str)
    menu = Orders.get_menu(menu_id)
    CoffeeMachine.extract(id, menu)

    {:noreply,
     assign(socket,
       menus: get_menus(),
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus(),
       money: get_money()
     )}
  end

  defp get_menus() do
    Orders.get_menus()
  end

  defp get_burners() do
    Stove.get_burners()
  end

  defp get_orders() do
    OrderedList.list()
  end

  defp get_coffee_machine_state() do
    CoffeeMachine.state()
  end

  defp get_completed_menus() do
    CompletedMenu.get_all()
  end

  defp get_money() do
    MoneyStorage.amount()
  end
end
