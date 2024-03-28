defmodule LibBTest do
  use ExUnit.Case
  doctest LibB

  test "greets the world" do
    assert LibB.hello() == :world
  end
end
