defmodule OctoconfTest do
  use ExUnit.Case
  doctest Octoconf

  test "greets the world" do
    assert Octoconf.hello() == :world
  end
end
