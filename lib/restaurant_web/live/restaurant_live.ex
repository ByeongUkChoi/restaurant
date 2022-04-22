defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  alias Restaurant.Kitchen.Stove

  def render(assigns) do
    ~H"""
    <p>Hello world</p>
    <div>
      <label>stove</label>
      <table>
        <th>index</th>
        <th>status</th>
        <%= for {status, index} <- Enum.with_index(@burners_status, 1) do %>
          <tr>
            <td><%= index %></td>
            <td><%= status %></td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, burners_status: Stove.get_burners_status())}
  end
end
