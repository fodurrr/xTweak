# Elixir/Ash Usage Rules

This folder contains **usage rules** - AI-optimized documentation from Elixir/Ash packages.

## What are Usage Rules?

Package-specific guidance written by library authors to help AI coding assistants:
- Understand correct usage patterns
- Avoid common mistakes
- Follow framework conventions
- Generate high-quality code

**Project**: https://github.com/ash-project/usage_rules

## How They Work

### For AI (Claude Code/Codex CLI)

**Automatic discovery** - No manual configuration needed:
- MCP server (`mcp__ash_ai__get_usage_rules`) scans `deps/` folder
- Returns list of all available usage rules with file paths
- Agents read relevant rules on-demand based on task context
- Always current with installed package versions

### For Humans

**This folder provides readable reference copies:**
- Browse framework patterns and conventions
- Learn best practices from package authors
- Reference during code reviews
- Update after dependency upgrades: `mix docs.rules`

## Available Rules

### Core Framework (in this folder)

- **ash.md** - Ash framework fundamentals
  - Resources, actions, policies, relationships
  - Querying, validations, error handling
  - Calculations, aggregates, testing patterns

- **ash_postgres.md** - Database/persistence layer
  - Table/schema configuration
  - Foreign keys, constraints, indexes
  - Migrations, multitenancy

- **ash_phoenix.md** - Phoenix/LiveView integration
  - Form integration, code interfaces
  - Nested/union forms, error handling
  - LiveView best practices

### Specialized Features (in this folder)

- **ash_ai.md** - AI/LLM integration
  - Vectorization, embeddings
  - AI tools for LLMs
  - Prompt-backed actions
  - MCP server setup

- **ash_oban.md** - Background job processing
  - Oban triggers, scheduled actions
  - Actor persistence, multitenancy
  - Error handling patterns

- **ash_authentication.md** - Authentication patterns
  - Auth strategies and configuration
  - Token handling, password management
  - Multi-tenancy auth patterns

- **igniter.md** - Code generation tools
  - Intelligent AST manipulation
  - Generator best practices
  - When to prefer Igniter vs manual config

### Additional Rules (in deps/, auto-discovered)

These are available via MCP but not yet copied to this folder:

**Phoenix ecosystem:**
- `phoenix/ecto.md` - Ecto patterns with Phoenix
- `phoenix/elixir.md` - Elixir conventions in Phoenix
- `phoenix/html.md` - HTML/HEEx patterns
- `phoenix/liveview.md` - LiveView best practices
- `phoenix/phoenix.md` - Core Phoenix patterns

**Ash ecosystem:**
- `ash_json_api.md` - JSON:API conventions

**Infrastructure:**
- `spark.md` - DSL building patterns
- `reactor.md` - Reactive workflow patterns
- `usage_rules/elixir.md` - General Elixir best practices
- `usage_rules/otp.md` - OTP patterns

To sync all rules to this folder: `mix docs.rules`

## Maintenance

### When to Update

- After upgrading Ash ecosystem packages
- When new packages with usage rules are added
- Periodically to catch upstream improvements

### How to Update

```bash
# List all available usage rules from installed packages
mix docs.rules.list

# Sync all rules to docs/elixir_rules/
mix docs.rules

# Or sync manually with full control
mix usage_rules.sync --folder-only docs/elixir_rules --all --merge-sub-rules
```

### Git Tracking

These files are version-controlled to:
- Preserve historical record of rules at each project version
- Enable searchability in IDEs
- Support code reviews and onboarding
- Show which conventions were active at specific times

After syncing new rules:
```bash
git add docs/elixir_rules/
git commit -m "docs: update usage rules from Ash packages"
```

## Integration with MCP

The Ash AI MCP server provides automatic discovery:

```elixir
# In Claude Code agents/workflows:
# 1. Discover available rules
rules = call_mcp("mcp__ash_ai__get_usage_rules")

# 2. Read relevant rule files
ash_rules = read_file(rules["ash"].file_path)
postgres_rules = read_file(rules["ash_postgres"].file_path)

# 3. Apply patterns to task
# ...
```

**No manual sync required for AI tools** - they always read from current `deps/`.

**Manual sync is for human reference** - this folder provides readable docs.

## Learn More

- [Usage Rules Project](https://github.com/ash-project/usage_rules)
- [Ash Framework Docs](https://hexdocs.pm/ash)
- [Ash AI Documentation](https://hexdocs.pm/ash_ai)
- [Research on AI Code Generation Quality](https://github.com/ash-project/evals/blob/main/reports/flagship.md)
