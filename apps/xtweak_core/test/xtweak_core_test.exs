defmodule XTweakCoreTest do
  use ExUnit.Case
  doctest XTweakCore

  test "hello returns :world" do
    assert XTweakCore.hello() == :world
  end
end
