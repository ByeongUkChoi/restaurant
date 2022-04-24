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
        <th>timer</th>
        <th>control</th>
        <%= for {burner, index} <- Enum.with_index(@burners) do %>
          <tr>
            <td><%= index + 1 %></td>
            <td><%= burner.status %></td>
            <td><%= if burner.status, do: burner.timer, else: "-" %></td>
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
    {:ok, assign(socket, burners: Stove.get_burners())}
  end

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(0)

    {:noreply, socket}
  end
end
