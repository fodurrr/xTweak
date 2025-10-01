# XTweakCore

Core business logic and data layer for the xTweak infrastructure template.

## Description

This is the core app in the xTweak umbrella application. It contains:
- Ash Framework resources and domains
- Business logic
- Data layer (AshPostgres)
- Domain-specific code with no web dependencies

## Architecture

```
xtweak_core/
├── lib/
│   ├── xtweak/
│   │   ├── core/          # Ash resources (User, etc.)
│   │   └── repo.ex        # Database repo
│   └── xtweak_core.ex     # Application module
├── priv/
│   └── resource_snapshots/ # Ash migration snapshots
└── test/
    └── support/           # Test helpers (DataCase, etc.)
```

## Key Patterns

### Ash Resources
All data models use Ash Framework:
```elixir
defmodule XTweak.Core.User do
  use Ash.Resource,
    domain: XTweak.Core,
    data_layer: AshPostgres.DataLayer
end
```

### Domain API
Interact with resources through the domain:
```elixir
XTweak.Core.create(XTweak.Core.User, %{email: "user@example.com"})
XTweak.Core.read!(XTweak.Core.User)
```

## Dependencies

- **Ash** - Resource-based framework for declarative APIs
- **AshPostgres** - PostgreSQL data layer for Ash
- **Ecto** - Database wrapper (via Ash)

## Installation

For use in other umbrellas apps, add to `mix.exs`:

```elixir
def deps do
  [
    {:xtweak_core, in_umbrella: true}
  ]
end
```

## Development

### Database Commands
```bash
# Setup database
mix ash.setup

# Generate migrations
mix ash_postgres.generate_migrations

# Run migrations
mix ash_postgres.migrate
```

### Testing
```bash
# Run all core tests
mix test apps/xtweak_core/test

# Run specific test file
mix test apps/xtweak_core/test/xtweak/core/user_test.exs
```

## Configuration

See `config/config.exs` and `config/runtime.exs` for database and environment configuration.

## Documentation

Generate docs with:
```bash
mix docs
```

---

**Note**: This is part of the xTweak infrastructure template. When copying to your own project, replace "XTweak" with your project name.
