defmodule RestaurantWeb.RestaurantLive.CoffeeMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>coffee machine</label>
      <table>
        <th>id</th>
        <th>status</th>
        <th>timer</th>
        <th>extract</th>
        <%= for group <- @state.groups do %>
          <tr>
            <td><%= group.id %></td>
            <td></td>
            <td><%= group.time %></td>
            <td>
              <button phx-click="extract_coffee" phx-value-id={group.id} phx-value-menu={:coffee} disabled={group.time > 0}>extract</button>
            </td>
            <td>
              <button phx-click="extract_coffee" phx-value-id={group.id} phx-value-menu={:latte} disabled={group.time > 0}>extract</button>
            </td>
          </tr>
        <% end %>
        <tfoot>
          <tr>
              <td>results</td>
              <td><%= @state.results %></td>
          </tr>
        </tfoot>
      </table>
    </div>
    """
  end
end
