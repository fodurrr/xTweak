defmodule XTweak.Core.DoctestsTest do
  @moduledoc """
  Runs all module doctests to ensure documentation examples remain current.

  Doctests live in the source modules but need to be explicitly tested.
  This file ensures they run as part of the test suite.
  """
  use ExUnit.Case, async: true

  # Core Resources
  doctest XTweak.Core.User
  doctest XTweak.Core.Newsletter

  # Domain
  doctest XTweak.Core
end
