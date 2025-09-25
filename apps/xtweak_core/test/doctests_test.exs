defmodule XTweak.Core.DoctestsTest do
  @moduledoc """
  Runs all module doctests to ensure documentation examples remain current.

  Doctests live in the source modules but need to be explicitly tested.
  This file ensures they run as part of the test suite.
  """
  use ExUnit.Case, async: true

  # Core Resources
  doctest XTweak.Core.User
  doctest XTweak.Core.Node
  doctest XTweak.Core.Knowledge
  doctest XTweak.Core.Contribution
  doctest XTweak.Core.Token

  # Domain
  doctest XTweak.Core

  # Validators
  doctest XTweak.Core.Node.ValidatePublicKey
  doctest XTweak.Core.Knowledge.ValidateContentHash
  doctest XTweak.Core.Contribution.ValidateContributionData
  doctest XTweak.Core.Node.ValidateNodeIdentity
end
