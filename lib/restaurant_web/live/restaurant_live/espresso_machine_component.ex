defmodule RestaurantWeb.RestaurantLive.EspressoMachineComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>espresso machine</label>
      <table>
        <th>extract</th>
      </table>
      <tr>
        <td>
          <button phx-click="extract_espresso">extract</button>
        </td>
      </tr>
    </div>
    """
  end
end
