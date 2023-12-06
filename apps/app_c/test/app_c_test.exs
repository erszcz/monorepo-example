defmodule AppCTest do
  use ExUnit.Case
  doctest AppC

  test "greets the world" do
    assert AppC.hello() == :world
  end
end
