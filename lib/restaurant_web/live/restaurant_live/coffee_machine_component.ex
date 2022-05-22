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
              <%= for menu <- [:americano, :latte] do %>
                <button phx-click="extract_coffee" phx-value-id={group.id} phx-value-menu={menu} ><%= menu %></button>
              <% end %>
            <% else %>
                <button disabled><%= group.menu %></button>
            <% end %>
            </td>
          </tr>
        <% end %>
      </table>
      <label>results</label>
      <table>
        <%= for menu <- [:americano, :latte] do %>
        <tr>
          <td><%= menu %></td>
          <td><%= Enum.count(@state.results, & &1 == Atom.to_string(menu)) %></td>
        </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
