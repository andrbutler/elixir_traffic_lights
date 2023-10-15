defmodule TrafficLights do
  @moduledoc """
  Documentation for `TrafficLights`.
  Genserver based implementation of a simple traffic light and a collection of traffic lights.
  """
  defmodule Light do

    use GenServer

    @moduledoc """
    Documentation for 'Light' when started represents a single traffic light with a persistant state containing its current color.
    """

    #Client Functions

    @doc """
    starts the server and initalizes the lights color as green.
    """
    def start_link(_args) do
      GenServer.start_link(__MODULE__, [])
    end

    @doc """
    helper function that changes the color of the light in sequence green -> yellow -> red -> green...

    ## Examples
    iex> change(:green)
    :yellow
    iex> change(:yellow)
    :red
    iex> change(:red)
    :green
    """
    def change(start_color) do
      case start_color do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end
    end

    @doc """
    calls server and update state using change function.
    """
    def transition(pid) do
      GenServer.cast(pid, :transition)
    end

    @doc """
    calls server and retrives current light color.

    ##Examples 
    iex> {:ok, pid} = Light.start_link([])
    iex> Light.current_light(pid)
    :green
    """
    def current_light(pid) do
      GenServer.call(pid, :get)
    end

    #Server Functions

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

    use GenServer

    @moduledoc """
    Documentation for 'TrafficGrid' when started represents a grid of 5 traffic lights with a persistant state containing their current colors.
    """

    #Client Functions

    @doc """
    starts the server and initalizes a list of 5 lights.
    """
    def start_link(_args) do
      GenServer.start_link(__MODULE__, [])
    end

    @doc """
    calls server and transitions all lights using logic in Light module.
    """
    def transition(pid) do
      GenServer.cast(pid, :transition)
    end

    @doc """
    calls server and returns current color of all lights as a list
    ##Examples
    iex> {:ok, pid} = TrafficGrid.start_link([])
    iex> TrafficGrid.current_lights(pid)
    [:green, :green, :green, :green, :green]
    """
    def current_lights(pid) do
      GenServer.call(pid, :get_light_colors)
    end

    @doc """
    calls server and returns a list of the pids of all lights(can be used to individually call or transition a light in the grid using the Light module.)
    """
    def get_lights(pid) do
      GenServer.call(pid, :get_lights)
    end

    #Server Functions

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
