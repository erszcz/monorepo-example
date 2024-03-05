defmodule AppDTest do
  use ExUnit.Case
  doctest AppD

  test "greets the world" do
    assert AppD.hello() == :world
  end

  test "always passes" do
    :ok
  end
end
