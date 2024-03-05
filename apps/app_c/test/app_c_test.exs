defmodule AppCTest do
  use ExUnit.Case
  doctest AppC

  test "greets all the worlds" do
    assert AppC.hello() == :worldz
  end
end
