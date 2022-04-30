defmodule RestaurantWeb.RestaurantLive do
  use RestaurantWeb, :live_view

  import Transformer

  alias Restaurant.Kitchen.Stove

  def render(assigns) do
    ~H"""
    <.live_component module={RestaurantWeb.RestaurantLive.KioskComponent} id="kiosk" />
    <.live_component module={RestaurantWeb.RestaurantLive.StoveComponent} id="stove" burners={@burners} />
    """
  end

  def mount(_params, _session, socket) do
    start_timer(1000)
    {:ok, assign(socket, burners: get_burners())}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  def handle_info(:clock_tick, socket) do
    {:noreply, assign(socket, burners: get_burners())}
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
