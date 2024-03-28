defmodule ServiceCTest do
  use ExUnit.Case
  doctest ServiceC

  test "greets the world" do
    assert ServiceC.hello() == :world
  end
end
