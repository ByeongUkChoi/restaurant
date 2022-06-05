defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  import Transformer

  alias Restaurant.Kitchen.Stove
  alias Restaurant.Kitchen.CoffeeMachine
  alias Restaurant.Kitchen.CompletedMenu
  alias Restaurant.Orders
  alias Restaurant.OrderList

  def render(assigns) do
    ~H"""
    <.live_component module={RestaurantWeb.RestaurantLive.KioskComponent} id="kiosk" menus={@menus} />
    <.live_component module={RestaurantWeb.RestaurantLive.OrderListComponent} id="order_list" orders={@orders}/>
    <.live_component module={RestaurantWeb.RestaurantLive.CoffeeMachineComponent} id="coffee_machine" state={@coffee_machine} />
    <label>completed menus</label>
    <%= for menu <- @completed_menus do %>
      <p><%= menu %></p>
    <% end %>
    """

    # <.live_component module={RestaurantWeb.RestaurantLive.StoveComponent} id="stove" burners={@burners} />
  end

  def mount(_params, _session, socket) do
    start_timer(1000)

    {:ok,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       menus: get_menus(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  def handle_info(:clock_tick, socket) do
    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("order", %{"menu_id" => menu_id_str}, socket) do
    menu_id = Transformer.to_integer_or(menu_id_str)
    OrderList.put(menu_id)

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("delivery", %{"menu_id" => menu_id_str}, socket) do
    menu_id = Transformer.to_integer_or(menu_id_str)
    %{name: menu} = Orders.get_menu(menu_id)

    with :ok <- CompletedMenu.delete(menu),
         {:delete_order_list, :ok} <- {:delete_order_list, OrderList.delete(menu_id)} do
    else
      {:delete_order_list, :error} -> CompletedMenu.put(menu)
      _ -> :ok
    end

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(30)

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("turn_off", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_off()

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("plus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.increase_timer(30)

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("minus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.decrease_timer(30)

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  def handle_event("extract_coffee", %{"id" => id_str, "menu" => menu}, socket) do
    id = to_integer_or(id_str)
    CoffeeMachine.extract(id, menu)

    {:noreply,
     assign(socket,
       burners: get_burners(),
       orders: get_orders(),
       coffee_machine: get_coffee_machine_state(),
       completed_menus: get_completed_menus()
     )}
  end

  defp get_menus() do
    Orders.get_menus()
  end

  defp get_burners() do
    Stove.get_burners()
  end

  defp get_orders() do
    OrderList.list()
  end

  defp get_coffee_machine_state() do
    CoffeeMachine.state()
  end

  defp get_completed_menus() do
    CompletedMenu.get_all()
  end
end
