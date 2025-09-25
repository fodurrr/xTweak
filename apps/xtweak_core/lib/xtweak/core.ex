defmodule XTweak.Core do
  @moduledoc """
  Core Ash Domain for the xTweak application template.

  Defines the main domain containing User and Newsletter resources
  for basic authentication and subscription management.

  ## Examples

  List all resources in the domain:

      iex> # Core domain resources
      iex> resources = [
      ...>   XTweak.Core.User,
      ...>   XTweak.Core.Newsletter
      ...> ]
      iex> length(resources)
      2

  Domain operation examples:

      iex> # Standard domain operations available
      iex> operations = [:create, :read, :update, :destroy]
      iex> :read in operations
      true

  """

  use Ash.Domain

  resources do
    resource(XTweak.Core.User)
    resource(XTweak.Core.Newsletter)
  end
end
