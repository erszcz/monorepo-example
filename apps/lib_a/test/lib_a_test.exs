defmodule LibATest do
  use ExUnit.Case
  doctest LibA

  test "greets the world" do
    assert LibA.hello() == :world
  end
end
