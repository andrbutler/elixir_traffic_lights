defmodule TrafficLightsTest do
  use ExUnit.Case
  doctest TrafficLights

  test "verify light sequence-inital" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    assert TrafficLights.Light.current_light(pid) == :green
  end

  test "verify light sequence-first transition" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :yellow
  end

  test "verify light sequence-second transition" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :red
  end

  test "verify light sequence-cycle repeats" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :green
  end

  test "verify inital grid" do
    {:ok, pid} = TrafficLights.TrafficGrid.start_link([])
    assert TrafficLights.TrafficGrid.current_lights(pid) == [:green, :green, :green, :green, :green]
  end

  test "verify grid transition" do
    {:ok, pid} = TrafficLights.TrafficGrid.start_link([])
    TrafficLights.TrafficGrid.transition(pid)
    assert TrafficLights.TrafficGrid.current_lights(pid) == [:yellow, :yellow, :yellow, :yellow, :yellow]
  end

  test "verify single light transition in grid" do
    {:ok, pid} = TrafficLights.TrafficGrid.start_link([])
    lights = TrafficLights.TrafficGrid.get_lights(pid)
    TrafficLights.Light.transition(Enum.at(lights, 3))
    TrafficLights.TrafficGrid.transition(pid)
    assert TrafficLights.TrafficGrid.current_lights(pid) == [:yellow, :yellow, :yellow, :red, :yellow]
  end
end
