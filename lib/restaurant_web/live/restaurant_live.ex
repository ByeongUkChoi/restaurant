defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  import Transformer

  alias Restaurant.Kitchen.Stove

  def render(assigns) do
    ~H"""
    <p>Hello world</p>
    <div>
      <label>stove</label>
      <table>
        <th>index</th>
        <th>status</th>
        <th>control</th>
        <%= for {status, index} <- Enum.with_index(@burners_status) do %>
          <tr>
            <td><%= index + 1 %></td>
            <td><%= status %></td>
            <td>
              <button phx-click="turn_on" phx-value-index={index}>ON</button>
            </td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, burners_status: Stove.get_burners_status())}
  end

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(0)

    {:noreply, socket}
  end
end
