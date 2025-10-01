# Claude Code Guidelines for xTweak Project

## 🎯 CRITICAL: Understanding Placeholders

**ALL examples use PLACEHOLDER SYNTAX** to be project-agnostic:
- `{YourApp}` → Your actual project name (e.g., XTweak, Blog, Shop)
- `{YourApp}Web` → Your web module (e.g., XTweakWeb, BlogWeb)
- `{YourApp}.Domain` or `{YourApp}.Core` → Your domain module
- `MyApp` in examples → Generic placeholder, **NEVER** use literally

**When working on THIS project (xTweak)**:
- Agents detect via Phase 0: Core app = `xtweak_core`, Domain = `XTweak.Core`, Web = `XTweakWeb`
- All `{YourApp}` placeholders become `XTweak` automatically
- Pattern: `{YourApp}.Core.User` → Becomes: `XTweak.Core.User`

**This file uses placeholders where possible** to serve as a template for other projects.

## 🚨 CRITICAL: Must Follow These 5 Core Principles

### 1. **MCP Server Tools FIRST - Never Assume, Always Research**
**This is non-negotiable.** Use MCP tools as your primary interface:
- `mcp__tidewave__project_eval` - Execute and test Elixir code in the running app
- Use `h Module.function` to get documentation for any module or function
- `mcp__tidewave__get_docs` - Get documentation directly
- `mcp__tidewave__search_package_docs` - Search Ash/Phoenix/dependency docs before starting work
- `mcp__tidewave__execute_sql_query` - Query database (for debugging only)
- `mcp__ash_ai__list_generators` - List available Ash generators
- `mcp__tidewave__get_ecto_schemas` - Find all Ash resources quickly
- `mcp__tidewave__get_logs` - Check for runtime errors

**NEVER** start/stop Phoenix server - it breaks some of the MCP connections!

### 2. **Ash Framework Exclusively - Zero Direct Ecto**
This project uses **Ash Framework** for ALL data operations:
- Resources are in `apps/{yourapp}_core/lib/{yourapp}/core/`
  - For xTweak: `apps/xtweak_core/lib/xtweak/core/`
- **NEVER** use Ecto schemas, changesets, or Repo directly
- **ALWAYS** use Ash resources, actions, queries, and changes
- Resources must include: `use Ash.Resource`, domain, data_layer, extensions
- Follow existing patterns in your project's resources (User, etc.)

### 3. **Elixir Umbrella Boundaries are Sacred**
Respect the umbrella architecture:
```
apps/
├── {yourapp}_core/   # Ash resources, business logic, domain
├── {yourapp}_web/    # Phoenix, LiveView, channels, web interface
└── {yourapp}_node/   # Optional: Additional apps (P2P, background jobs, etc.)

# For xTweak specifically:
apps/
├── xtweak_core/   # Ash resources, business logic, domain
└── xtweak_web/    # Phoenix, LiveView, channels, web interface
```
- **NEVER** cross boundaries incorrectly
- Core app has NO web dependencies
- Web/Node apps depend on Core, not on each other
- Use proper umbrella inter-app dependencies

### 4. **Generator-First, Then Customize**
Development workflow:
1. **ALWAYS** check for generators first: `mcp__ash_ai__list_generators` or `mix help`
2. Use generators with `--yes` flag to avoid interactive prompts
3. Generate the base code as starting point
4. Customize generated code to fit requirements
5. Follow patterns from generated code in manual implementations

### 5. **Quality Gates Before ANY Completion**
**Mandatory** before marking any task complete:
```bash
mix format                              # Format code
mix credo --strict                      # Code quality
mix compile --warnings-as-errors        # Compilation check
mix test apps/{yourapp}_core/test/...   # Run relevant tests

# For xTweak:
mix test apps/xtweak_core/test/...
```
After executing code:
- Check compilation: `mix compile`
- Check logs: `mcp__tidewave__get_logs level: "error"`
- Run applicable tests to verify changes work correctly

## Additional Critical Rules

### Resource Naming and Structure
- Ash resources: `{YourApp}.Core.{ResourceName}` (User, Post, Product, etc.)
  - For xTweak: `XTweak.Core.User`, `XTweak.Core.Post`, etc.
- Test files mirror source structure: `test/{app_name}/core/{resource}_test.exs`
  - For xTweak: `test/xtweak/core/user_test.exs`
- Use DataCase for tests requiring database: `use {YourApp}.DataCase`
  - For xTweak: `use XTweak.DataCase`
- Validators go in subdirectories: `core/resource/validate_something.ex`

### Testing Best Practices
```bash
# Test specific app
mix test apps/{yourapp}_core/test
# For xTweak: mix test apps/xtweak_core/test

# Test with timeout for long-running tests
timeout 30 mix test apps/{yourapp}_core/test/{app_name}/core/{resource}_test.exs
# For xTweak: timeout 30 mix test apps/xtweak_core/test/xtweak/core/user_test.exs

# Run with seed for reproducible tests
mix test --seed 0
```

### Database and Migrations
- **ONLY** use Ash migrations: `mix ash_postgres.generate_migrations`
- Database setup: `mix ash.setup` (NOT ecto commands)
- Check migration snapshots in `priv/resource_snapshots/`
- Test environment: `MIX_ENV=test mix ash_postgres.migrate`

## Required Documentation to Follow

1. **`docs/frontend_design_principles/frontend-design-principles.md`** - Tailwind/DaisyUI component-first approach
2. **`docs/architecture/`** - System design and patterns
3. **`docs/stories/`** - User stories and implementation details
4. **`docs/qa/`** - Quality gates and testing requirements

## Project Owner Context - Peter

- **Background**: Computer geek since 1984, experienced programmer in multiple languages
- **Learning**: Just starting with Elixir, Phoenix, and Ash Framework
- **Working Style**: Has creative, sometimes breakthrough ideas that may need exploration
- **Communication**: Help improve terminology and explain Elixir/Ash concepts along the way
- **First Resource**: Ask Peter when you don't know something or where to look

## Non-Negotiable Git & GitHub Rules

- **NEVER** commit, push, or create PRs/issues without explicit permission
- **ALWAYS** when you asked to commit **AWLWAYS** commit all files in the project use `git add -A`.
- **ALWAYS** use `gh` CLI for ALL GitHub interactions
- **NO** autonomous git operations - wait for explicit instructions
- This is an **Elixir umbrella project** - all decisions must respect this architecture

## Project Architecture

- **Type**: Elixir/Phoenix/Ash umbrella application infrastructure template
- **Purpose**: Refactored basic infrastructure for building production-ready applications
- **Frontend**: Tailwind CSS + DaisyUI component-first approach
- **Resources**: Define based on your application needs (User, Post, Product, etc.)

## Common Commands Reference

```bash
# Ash/Database
mix ash.setup                    # Setup database
mix ash_postgres.generate_migrations  # Generate migrations
mix ash_postgres.migrate         # Run migrations

# Quality & Testing  
mix format                       # Format code
mix credo --strict              # Code quality
mix compile --warnings-as-errors # Strict compilation
mix test                        # Run all tests
mix dialyzer                    # Type checking

# Development
mix phx.server                  # Start Phoenix (DON'T use in MCP)
iex -S mix                      # Interactive shell (DON'T use in MCP)
```

---

## 📝 Note on This File

**CLAUDE.md as a Template**:
- This file uses **placeholder syntax** (`{YourApp}`) where possible to be reusable
- Specific xTweak examples show how placeholders are applied
- When you see `{YourApp}` → Replace with YOUR project name
- When you see "For xTweak:" → That's the example for THIS infrastructure project

**If copying to your own project**:
- Replace all `{YourApp}` → Your project name (e.g., Blog, Shop)
- Replace `{yourapp}` → Your app prefix (e.g., blog, shop)
- Update domain pattern if different (e.g., `Blog.Domain` instead of `XTweak.Core`)

**Agents reading this file**:
- Will use Phase 0 detection to find actual project structure
- Will adapt all `{YourApp}` placeholders to detected values
- For xTweak specifically: `{YourApp}` → `XTweak`, `{yourapp}` → `xtweak`

---

**Remember**: This is an Ash-first project. When in doubt, use MCP tools to research. Never make assumptions. Always verify with `mcp__tidewave__project_eval` before implementing.

