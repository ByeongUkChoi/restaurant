defmodule RestaurantWeb.RestaurantLive.EspressoMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>espresso machine</label>
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
              <button phx-click="extract_espresso" phx-value-id={group.id}>extract</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
