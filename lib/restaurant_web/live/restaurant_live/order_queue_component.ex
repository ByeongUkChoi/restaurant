defmodule RestaurantWeb.RestaurantLive.OrderQueueComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>order queue</label>
      <table>
        <th>no</th>
        <th>menu</th>
        <th>delivery</th>
        <%= for {order, no} <- Enum.with_index(@orders, 1) do %>
          <tr>
            <td><%= no %></td>
            <td><%= order.name %></td>
            <td>
                <button phx-click="delivery" phx-value-menu={order.name} >delivery</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
