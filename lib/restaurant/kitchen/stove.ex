defmodule Restaurant.Kitchen.Stove do
  @moduledoc """
  have burners and control them.

  turn on burner and set timer
  """
  use GenServer

  alias Restaurant.Kitchen.Burner

  # API
  def start_link(burner_count) do
    GenServer.start_link(__MODULE__, burner_count, name: __MODULE__)
  end

  def get_burners() do
    GenServer.call(__MODULE__, :get_burners)
  end

  def turn_on(index, time) do
    GenServer.cast(__MODULE__, {:turn_on, index, time})
  end

  def turn_off(index) do
    GenServer.cast(__MODULE__, {:turn_off, index})
  end

  def increase_timer(index, time) do
    GenServer.cast(__MODULE__, {:increase_timer, index, time})
  end

  def decrease_timer(index, time) do
    GenServer.cast(__MODULE__, {:decrease_timer, index, time})
  end

  # Server
  def init(burner_count) do
    burners =
      if burner_count > 0 do
        1..burner_count
        |> Enum.map(fn _ ->
          {:ok, pid} = Burner.start_link(nil)
          %{pid: pid, status: false, timer: 0}
        end)
      else
        []
      end

    {:ok, burners}
  end

  def handle_call(:get_burners, _from, burners) do
    {:reply, burners, burners}
  end

  def handle_cast({:turn_on, index, time}, burners) do
    %{pid: pid} = Enum.at(burners, index)
    Burner.turn_on(pid)
    Process.send_after(self(), {:timer, pid}, 0)
    {:noreply, update_burners(burners, pid, %{status: true, timer: time})}
  end

  def handle_cast({:turn_off, index}, burners) do
    %{pid: pid} = Enum.at(burners, index)
    Burner.turn_on(pid)

    {:noreply, update_burners(burners, pid, %{status: false, timer: 0})}
  end

  def handle_cast({:increase_timer, index, time}, burners) do
    %{pid: pid, timer: remaining_time} = Enum.at(burners, index)

    {:noreply, update_burners(burners, pid, %{timer: remaining_time + time})}
  end

  def handle_cast({:decrease_timer, index, time}, burners) do
    %{pid: pid, timer: remaining_time} = Enum.at(burners, index)

    update_time =
      if remaining_time - time >= 0 do
        remaining_time - time
      else
        0
      end

    {:noreply, update_burners(burners, pid, %{timer: update_time})}
  end

  def handle_info({:timer, pid}, burners) do
    %{timer: remaining_time} = Enum.find(burners, &(&1.pid == pid))

    if remaining_time > 1 do
      Process.send_after(self(), {:timer, pid}, 1000)
    end

    {:noreply, update_burners(burners, pid, %{timer: remaining_time - 1})}
  end

  defp update_burners(burners, pid, params) do
    status = params[:status]
    time = params[:timer]

    put_status = fn
      burner, nil -> burner
      burner, status -> Map.put(burner, :status, status)
    end

    put_timer = fn burner, time -> Map.put(burner, :timer, time) end

    burners
    |> Enum.map(fn
      %{pid: ^pid} = burner -> burner |> put_status.(status) |> put_timer.(time)
      burner -> burner
    end)
  end
end
