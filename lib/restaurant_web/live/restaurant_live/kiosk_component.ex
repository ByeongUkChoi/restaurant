defmodule RestaurantWeb.RestaurantLive.KioskComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>menu</label>
      <table>
        <th>name</th>
        <th>price</th>
        <th></th>
        <%= for menu <- @menus do %>
          <tr>
            <td><%= menu.name %></td>
            <td><%= menu.price %></td>
            <td>
              <button phx-click="order" phx-value-menu_id={menu.id}>ORDER</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
