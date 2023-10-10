defmodule TrafficLights do
  @moduledoc """
  Documentation for `TrafficLights`.
  """
  use GenServer

  @doc """
  """
  defmodule Light do
    def start_link(_args) do
      GenServer.start_link(__Module__, [])
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
      GenServer.call(pid, _from, :get)
    end

    @impl true
    def init(_args) do
      {:ok, :green}
    end

    @impl true
    def handle_call(:transition, state) do
      {:noreply, change(state)}
    end

    @impl true
    def handle_cast(:get, _from, state) do
      {:reply, state, state}
    end
  end

  defmodule Traffic_grid do
  end
end
