defmodule ServiceDTest do
  use ExUnit.Case
  doctest ServiceD

  test "greets the world" do
    assert ServiceD.hello() == :world
  end
end
