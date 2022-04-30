defmodule RestaurantWeb.RestaurantLive.KioskComponent do
  use RestaurantWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <label>menu</label>
      <table>
        <th>name</th>
        <th></th>
          <tr>
            <td>test1</td>
            <td>
              <button>order</button>
            </td>
          </tr>
          <tr>
            <td>test2</td>
            <td>
              <button>order</button>
            </td>
          </tr>
      </table>
    </div>
    """
  end
end
