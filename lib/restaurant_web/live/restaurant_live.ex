defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  def render(assigns) do
    ~H"""
    <p>Hello world</p>
    <div>
      <label>stove</label>
      <table>
        <th>name</th>
        <th>status</th>
        <tr>
          <td>burner 1</td>
          <td>idle</td>
        </tr>
        <tr>
          <td>burner 2</td>
          <td>heating</td>
        </tr>
      </table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end
end
