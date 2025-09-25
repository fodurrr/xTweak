defmodule XTweakUITest do
  use ExUnit.Case
  doctest XTweakUI

  test "version returns the current version" do
    assert XTweakUI.version() == "0.1.0"
  end
end
