defmodule RestaurantWeb.RestaurantLive.EspressoMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>espresso machine</label>
      <table>
        <th>extract</th>
        <th>status</th>
        <tr>
          <td>
            <button phx-click="extract_espresso">extract</button>
          </td>
          <td>
            <%= @status %>
          </td>
        </tr>
      </table>
    </div>
    """
  end
end
