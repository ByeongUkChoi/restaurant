defmodule RestaurantWeb.RestaurantLive.OrderedListComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>ordered list</label>
      <table>
        <th>no</th>
        <th>order id</th>
        <th>menu</th>
        <th>delivery</th>
        <%= for {order, no} <- Enum.with_index(@orders, 1) do %>
          <tr>
            <td><%= no %></td>
            <td><%= order.id %></td>
            <td><%= order.menu.name %></td>
            <td>
                <button phx-click="delivery" phx-value-order_id={order.id} >delivery</button>
                <button phx-click="cancel" phx-value-order_id={order.id} >cancel</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
