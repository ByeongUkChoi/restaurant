defmodule RestaurantWeb.RestaurantLive.CoffeeMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>coffee machine</label>
      <table>
        <th>id</th>
        <th>timer</th>
        <th>extract</th>
        <%= for group <- @state.groups do %>
          <tr>
            <td><%= group.id %></td>
            <td><%= group.time %></td>
            <td>
            <%= if group.time == 0 do %>
              <%= for menu <- @menus do %>
                <button phx-click="extract_coffee" phx-value-id={group.id} phx-value-menu_id={menu.id} ><%= menu.name %></button>
              <% end %>
            <% else %>
                <button disabled><%= group.menu.name %></button>
            <% end %>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
