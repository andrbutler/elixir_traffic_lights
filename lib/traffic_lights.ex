defmodule TrafficLights do
  @moduledoc """
  Documentation for `TrafficLights`.
  """
  use GenServer

  @doc """
  """
  defmodule Light do
    def start_link(_args) do
      GenServer.start_link(__MODULE__, [])
    end

    def change(start_color) do
      case start_color do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end
    end

    def transition(pid) do
      GenServer.cast(pid, :transition)
    end

    def current_light(pid) do
      GenServer.call(pid, :get)
    end

    @impl true
    def init(_args) do
      {:ok, :green}
    end

    @impl true
    def handle_cast(:transition, state) do
      {:noreply, change(state)}
    end

    @impl true
    def handle_call(:get, _from, state) do
      {:reply, state, state}
    end
  end

  defmodule TrafficGrid do

    def start_link(_args) do
      GenServer.start_link(__MODULE__, [])
    end

    def transition(pid) do
      GenServer.cast(pid, :transition)
    end

    def current_lights(pid) do
      GenServer.call(pid, :get_light_colors)
    end

    def get_lights(pid) do
      GenServer.call(pid, :get_lights)
    end

    @impl true
    def init(_args) do
      list = Enum.map(1..6, fn _ -> 
        {:ok, pid} = Light.start_link([])
        pid
      end)
      {:ok, list}
    end

    @impl true
    def handle_cast(:transition, state) do
      Enum.map(state, fn pid -> Light.transition(pid) end)
      {:noreply, state}
    end

    @impl true
    def handle_call(:get_light_colors, _from, state) do
      colors = Enum.map(state, fn pid -> Light.current_light(pid) end)
      {:reply, colors, state}
    end

    @impl true
    def handle_call(:get_lights, _from, state) do
      {:reply, state, state}
    end

  end
end
