defmodule RestaurantWeb.RestaurantLive.StoveComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>stove</label>
      <table>
        <th>index</th>
        <th>status</th>
        <th>timer</th>
        <th>control</th>
        <%= for {burner, index} <- Enum.with_index(@burners) do %>
          <tr>
            <td><%= index + 1 %></td>
            <td><%= burner.status %></td>
            <td><%= if burner.status, do: burner.timer, else: "-" %></td>
            <td>
            <%= if burner.status do %>
              <button phx-click="turn_off" phx-value-index={index}>OFF</button>
              <button phx-click="plus_timer" phx-value-index={index}>+</button>
              <button phx-click="minus_timer" phx-value-index={index}>-</button>
            <% else %>
              <button phx-click="turn_on" phx-value-index={index}>ON</button>
            <% end %>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
