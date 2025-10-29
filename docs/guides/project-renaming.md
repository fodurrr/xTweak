# Project Renaming Guide

## Overview

xTweak provides a standalone `rename_project.exs` script that allows you to rename the entire xTweak umbrella project when using it as a template. This script works perfectly with umbrella projects and requires no dependencies.

## Automated Renaming (Recommended)

### Quick Start

```bash
# Interactive mode
elixir scripts/rename_project.exs

# With project name
elixir scripts/rename_project.exs --to MyProject

# Preview changes first (dry-run)
elixir scripts/rename_project.exs --to MyProject --dry-run
```

See [`scripts/README.md`](../../scripts/README.md) for complete script documentation.

## Manual Renaming Approach (Alternative)

If you prefer to rename manually or need fine-grained control, here's the step-by-step process:

### 1. Search and Replace Module Names

```bash
# Find all occurrences of XTweak
rg "XTweak" -l

# Replace XTweak with your project name (e.g., MyProject)
# Use your editor's find-and-replace across all files
```

### 2. Rename App Atoms

Replace `:xtweak_` with `:yourproject_` in:
- All `mix.exs` files
- All `config/*.exs` files

### 3. Rename Directories

```bash
cd apps
mv xtweak_core yourproject_core
mv xtweak_web yourproject_web
mv xtweak_ui yourproject_ui
mv xtweak_docs yourproject_docs

# Rename internal lib directories
cd yourproject_core
mv lib/xtweak_core lib/yourproject_core

cd ../yourproject_web
mv lib/xtweak_web lib/yourproject_web
mv lib/xtweak_web_web lib/yourproject_web_web

# Repeat for ui and docs...
```

### 4. Update Database Names

In `config/dev.exs`, `config/test.exs`, and `config/runtime.exs`:

```elixir
# Change
database: "xtweak_dev"

# To
database: "yourproject_dev"
```

### 5. Update Frontend Configs

In `apps/yourproject_web/assets/`:

**package.json:**
```json
{
  "name": "yourproject_web"
}
```

**tailwind.config.js:**
```javascript
content: [
  "../lib/yourproject_web_web.ex",
  "../lib/yourproject_web_web/**/*.*ex"
]
```

### 6. Recompile and Test

```bash
# Update dependencies
mix deps.get

# Clean and recompile
mix clean
mix compile

# Run tests
mix test

# Create new databases
MIX_ENV=dev mix ash_postgres.create
MIX_ENV=dev mix ash_postgres.migrate
MIX_ENV=test mix ash_postgres.create
MIX_ENV=test mix ash_postgres.migrate
```

### 7. Commit Changes

```bash
git add -A
git commit -m "Rename project from XTweak to YourProject"
```

## Future Improvements

The automated `mix xtweak.rename` task is ready and waiting for umbrella support in Igniter. Once that's available, you'll be able to use:

```bash
# Interactive mode
mix xtweak.rename

# Automated mode
mix xtweak.rename --to MyProject --yes

# Preview changes
mix xtweak.rename --to MyProject --dry-run
```

See the task's built-in help for all options:

```bash
mix help xtweak.rename
```

## Checklist

After renaming (manual or automated), verify:

- [ ] All `defmodule` statements use new name
- [ ] All `alias`, `use`, `import` statements updated
- [ ] All app atoms in mix.exs files changed
- [ ] All config atoms in config files changed
- [ ] Database names updated in configs
- [ ] Directory names match new prefix
- [ ] Frontend configs updated
- [ ] Project compiles without errors
- [ ] All tests pass
- [ ] New databases created and migrated
- [ ] Changes committed to git

## Getting Help

If you encounter issues:

1. Check `mix compile` output for errors
2. Run `mix credo --strict` to find references
3. Search codebase for old project name: `rg "XTweak"`
4. Check GitHub issues for similar problems
