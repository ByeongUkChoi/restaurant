defmodule RestaurantWeb.RestaurantLive.CoffeeMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label><h1>coffee machine</h1></label>
      <label>material</label>
      <table>
        <th>beans</th>
        <th>milk</th>
        <tr>
          <td><%= @state.materials.beans %></td>
          <td><%= @state.materials.milk %></td>
        </tr>
        <tr>
          <td>
            <button phx-click="buy_material" phx-value-material="beans">buy</button>
          </td>
          <td>
            <button phx-click="buy_material" phx-value-material="milk">buy</button>
          </td>
        </tr>
      </table>

      <table>
        <th>id</th>
        <th>timer</th>
        <th>extract</th>
        <%= for worker <- @state.workers do %>
          <tr>
            <td><%= worker.id %></td>
            <td><%= worker.time %></td>
            <td>
            <%= if is_nil(worker.menu) do %>
              <%= for menu <- @menus do %>
                <button phx-click="extract_coffee" phx-value-id={worker.id} phx-value-menu_id={menu.id} ><%= menu.name %></button>
              <% end %>
            <% else %>
                <button disabled><%= worker.menu.name %></button>
            <% end %>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
