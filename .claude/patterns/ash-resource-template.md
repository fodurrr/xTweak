---
title: Ash Resource Template
tags:
  - ash
  - specialized
---

# Ash Resource Template Pattern

## Purpose
Provide a turnkey scaffold for designing Ash resources in umbrella apps. Includes attributes, relationships, actions, and policies with guidance on customization.

## Prerequisites
- `phase-zero-context`
- `placeholder-basics`
- `mcp-tool-discipline`

## Template Workflow

1. **Run Phase Zero** → capture `{detected_core_app}`, `{detected_domain}`, repo module, etc.
2. **Check Generators** → run `mcp__ash_ai__list_generators` for relevant scaffolds.
3. **Inspect Existing Resources** → use `Read`/`Glob` to mirror local conventions.

## Generic Resource Skeleton

```elixir
defmodule {YourApp}.{Domain}.{ResourceName} do
  @moduledoc """
  {ResourceName} resource.
  """

  use Ash.Resource,
    domain: {YourApp}.{Domain},
    data_layer: AshPostgres.DataLayer

  postgres do
    table "{resource_table_name}"
    repo {YourApp}.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      constraints min_length: 1, max_length: 255
    end

    timestamps()
  end

  relationships do
    # Define belongs_to / has_many etc.
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name]
    end

    update :update do
      accept [:name]
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_attribute_equals(:role, :admin)
    end
  end
end
```

## Example · XTweak Project

```elixir
defmodule XTweak.Core.User do
  use Ash.Resource,
    domain: XTweak.Core,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo XTweak.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :string do
      allow_nil? false
      constraints trim?: true
    end
    timestamps()
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end
end
```

## Implementation Reminders
- Always add policies; default to least privilege.
- Use calculations/aggregates for derived data rather than manual SQL.
- Generate migrations via `mix ash_postgres.generate_migrations` and review diffs.
- Pair with `test-builder` agent to create matching test coverage.

