defmodule RestaurantWeb.RestaurantLive.OrderedListComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>order list</label>
      <table>
        <th>no</th>
        <th>menu</th>
        <th>delivery</th>
        <%= for {order_menu, no} <- Enum.with_index(@orders, 1) do %>
          <tr>
            <td><%= no %></td>
            <td><%= order_menu.name %></td>
            <td>
                <button phx-click="delivery" phx-value-menu_id={order_menu.id} >delivery</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
