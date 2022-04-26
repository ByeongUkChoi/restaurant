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
            <%= if burner.status do %>
              <button phx-click="plus_timer" phx-value-index={index}>+</button>
              <button phx-click="minus_timer" phx-value-index={index}>-</button>
              <button phx-click="turn_off" phx-value-index={index}>OFF</button>
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

  def mount(_params, _session, socket) do
    {:ok, assign(socket, burners: get_burners())}
  end

  def handle_event("turn_on", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_on(30)

    {:noreply, assign(socket, burners: get_burners())}
  end

  def handle_event("turn_off", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.turn_off()

    {:noreply, assign(socket, burners: get_burners())}
  end

  def handle_event("plus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.increase_timer(30)

    {:noreply, assign(socket, burners: get_burners())}
  end

  def handle_event("minus_timer", %{"index" => index}, socket) do
    index
    |> to_integer_or()
    |> Stove.decrease_timer(30)

    {:noreply, assign(socket, burners: get_burners())}
  end

  defp get_burners() do
    Stove.get_burners()
  end
end
