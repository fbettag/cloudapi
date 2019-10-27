defmodule CloudAPITest do
  use ExUnit.Case
  doctest CloudAPI

  test "greets the world" do
    assert CloudAPI.hello() == :world
  end
end
