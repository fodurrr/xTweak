defmodule XTweak.Core.Newsletter do
  @moduledoc """
  Newsletter subscription resource for XTweak AI.

  Manages newsletter subscriptions for the distributed AI network,
  allowing users to subscribe and manage their newsletter preferences.
  """

  use Ash.Resource,
    domain: XTweak.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key(:id)

    attribute :email, :ci_string do
      allow_nil?(false)
      public?(true)

      constraints(
        min_length: 1,
        max_length: 160,
        match: ~r/^[^\s]+@[^\s]+$/
      )
    end

    attribute :status, :atom do
      allow_nil?(false)
      default(:subscribed)
      public?(true)
      constraints(one_of: [:subscribed, :unsubscribed, :pending_confirmation])
    end

    attribute :preferences, :map do
      allow_nil?(true)
      public?(true)
      default(%{})
    end

    attribute :subscribed_at, :utc_datetime_usec do
      allow_nil?(false)
      default(&DateTime.utc_now/0)
      public?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  actions do
    defaults([:read])

    create :create do
      description("Subscribe to newsletter")
      accept([:email, :preferences])
      primary?(true)

      change(set_attribute(:status, :subscribed))
      change(set_attribute(:subscribed_at, &DateTime.utc_now/0))
    end

    update :update do
      description("Update newsletter subscription")
      accept([:status, :preferences])
      require_atomic?(false)
    end

    update :unsubscribe do
      description("Unsubscribe from newsletter")
      change(set_attribute(:status, :unsubscribed))
    end

    read :by_email do
      description("Look up a subscription by email")
      argument(:email, :ci_string, allow_nil?: false)
      get?(true)
      filter(expr(email == ^arg(:email)))
    end
  end

  postgres do
    table("newsletter_subscriptions")
    repo(XTweak.Repo)
  end

  identities do
    identity(:unique_email, [:email])
  end

  validations do
    validate(match(:email, ~r/^[^\s]+@[^\s]+$/), message: "must be a valid email")
  end

  policies do
    # Allow public newsletter subscription (no authentication required)
    policy action(:create) do
      authorize_if(always())
    end

    # Users can read their own subscription; admins can read all
    policy action_type(:read) do
      authorize_if(expr(email == ^actor(:email)))
      authorize_if(actor_attribute_equals(:role, :admin))
    end

    # Users can update/unsubscribe their own subscription; admins can modify any
    policy action_type(:update) do
      authorize_if(expr(email == ^actor(:email)))
      authorize_if(actor_attribute_equals(:role, :admin))
    end
  end
end
