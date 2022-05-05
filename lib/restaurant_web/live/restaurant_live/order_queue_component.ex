defmodule RestaurantWeb.RestaurantLive.OrderQueueComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>order queue</label>
      <table>
        <th>id</th>
        <th>name</th>
        <%= for order <- @orders do %>
          <tr>
            <td><%= order.id %></td>
            <td><%= order.name %></td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
