defmodule EnanoTest do
  use ExUnit.Case
  doctest Enano

  test "greets the world" do
    assert Enano.hello() == :world
  end
end
