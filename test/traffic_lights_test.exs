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
end
