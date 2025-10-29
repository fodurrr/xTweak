# Template Initialization Guide

## Overview

xTweak is designed to be used as a template for new Elixir/Phoenix projects. This guide explains how to clone xTweak and rename it to your own project name using the built-in `mix xtweak.rename` task.

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/xTweak.git my-new-project
cd my-new-project

# 2. Remove git history (optional but recommended)
rm -rf .git
git init
git add .
git commit -m "Initial commit from xTweak template"

# 3. Install dependencies
mix deps.get

# 4. Rename the project
mix xtweak.rename

# 5. Follow prompts and next steps
```

## Detailed Walkthrough

### Step 1: Clone the Template

```bash
git clone https://github.com/yourusername/xTweak.git my-new-project
cd my-new-project
```

### Step 2: Initialize Fresh Git History

Since you're creating a new project, you'll want your own git history:

```bash
rm -rf .git
git init
git add .
git commit -m "Initial commit from xTweak template"
```

### Step 3: Install Dependencies

```bash
mix deps.get
cd apps/xtweak_web/assets && npm install && cd ../../..
```

### Step 4: Run the Rename Task

#### Interactive Mode (Recommended)

The interactive mode will prompt you for all necessary information:

```bash
mix xtweak.rename
```

You'll be asked:
- **New project name** (PascalCase, e.g., `MyProject`)
- **Update documentation?** (yes/no)
- **Rename databases?** (yes/no)

The task will show you a summary of planned changes and ask for confirmation.

#### Non-Interactive Mode

If you know exactly what you want:

```bash
mix xtweak.rename --to MyProject --yes
```

Options:
- `--to` - Target project name (required)
- `--app-prefix` - Custom app atom prefix (default: snake_case of project name)
- `--skip-docs` - Don't update documentation files
- `--skip-db` - Don't rename database names
- `--dry-run` - Preview changes without applying
- `--yes` - Skip confirmation prompts

#### Preview Changes (Dry Run)

See what will change without applying:

```bash
mix xtweak.rename --to MyProject --dry-run
```

### Step 5: Post-Rename Steps

After the rename completes, run these commands:

```bash
# Update dependencies
mix deps.get

# Clean and recompile
mix clean
mix compile

# Format code
mix format

# Run tests
mix test
```

### Step 6: Create New Databases

If you renamed databases (default behavior):

```bash
# Development environment
MIX_ENV=dev mix ash_postgres.create
MIX_ENV=dev mix ash_postgres.migrate

# Test environment
MIX_ENV=test mix ash_postgres.create
MIX_ENV=test mix ash_postgres.migrate
```

#### Drop Old Databases (Optional)

```bash
# Find old databases
psql -l | grep xtweak

# Drop them (CAREFUL!)
MIX_ENV=dev mix ash_postgres.drop
```

Or manually:
```sql
DROP DATABASE xtweak_dev;
DROP DATABASE xtweak_test;
```

### Step 7: Verify Everything Works

```bash
# Start the development server
mix phx.server

# Visit http://localhost:4000
```

Run the full test suite:
```bash
mix test
```

### Step 8: Commit the Renamed Project

```bash
git add -A
git commit -m "Rename project from xTweak to MyProject"
```

## What Gets Renamed

### Elixir Modules

| Before | After (example: `MyProject`) |
|--------|------------------------------|
| `XTweak.Core.User` | `MyProject.Core.User` |
| `XTweakCore.Application` | `MyProjectCore.Application` |
| `XTweakWeb.Router` | `MyProjectWeb.Router` |
| `XTweakUI.Components` | `MyProjectUI.Components` |

### App Atoms

| Before | After (example: `my_project`) |
|--------|-------------------------------|
| `:xtweak_core` | `:my_project_core` |
| `:xtweak_web` | `:my_project_web` |
| `:xtweak_ui` | `:my_project_ui` |
| `:xtweak_docs` | `:my_project_docs` |

### Directory Structure

| Before | After |
|--------|-------|
| `apps/xtweak_core/` | `apps/my_project_core/` |
| `apps/xtweak_web/` | `apps/my_project_web/` |
| `apps/xtweak_ui/` | `apps/my_project_ui/` |
| `apps/xtweak_docs/` | `apps/my_project_docs/` |

### Database Names

| Before | After |
|--------|-------|
| `xtweak_dev` | `my_project_dev` |
| `xtweak_test` | `my_project_test` |
| `xtweak_prod` | `my_project_prod` |

### Config Files

All references in:
- `config/config.exs`
- `config/dev.exs`
- `config/test.exs`
- `config/runtime.exs`

### Frontend Files

- `apps/xtweak_web/assets/package.json` - package name
- `apps/xtweak_web/assets/tailwind.config.js` - content paths

### Documentation (Optional)

- `README.md`
- `apps/*/README.md`
- `docs/**/*.md`

## Troubleshooting

### Compilation Errors

#### Issue: "Module not found"

```
** (CompileError) lib/my_app.ex:5: module XTweak.Core not found
```

**Solution**: The rename missed a reference. Search and replace manually:

```bash
grep -r "XTweak" apps/ lib/ --exclude-dir=deps --exclude-dir=_build
```

Then edit the affected files.

#### Issue: "Circular dependency"

```
** (CompileError) circular dependency between modules
```

**Solution**: Check `use` and `import` statements. May need to reorganize.

### Test Failures

#### Issue: "Database does not exist"

**Solution**: Create the databases:

```bash
MIX_ENV=test mix ash_postgres.create
```

#### Issue: "Module ... is not available"

**Solution**: Check test helper files for old module imports:

```bash
# apps/my_project_core/test/support/test_helper.exs
# Update any XTweak references
```

### Git Working Directory Not Clean

#### Issue: "Git working directory is not clean"

```
❌ Configuration error: Git working directory is not clean. Please commit or stash changes first.
```

**Solution**: Commit or stash your changes:

```bash
git add -A
git commit -m "Work in progress"
# OR
git stash
```

### Existing Project Name

#### Issue: Directory already exists

If `apps/my_project_core` already exists, the rename will fail.

**Solution**: Remove or rename the conflicting directory first:

```bash
mv apps/my_project_core apps/my_project_core_old
```

## Advanced Usage

### Custom App Prefix

If you want module names different from app atoms:

```bash
# Modules: MyCompany.Project.*
# Apps: :my_proj_core, :my_proj_web
mix xtweak.rename --to MyCompany.Project --app-prefix my_proj
```

### Skipping Documentation

If you want to keep references to xTweak in docs:

```bash
mix xtweak.rename --to MyProject --skip-docs
```

### Skipping Database Rename

If you want to keep `xtweak_dev` database names:

```bash
mix xtweak.rename --to MyProject --skip-db
```

### Automated/CI Usage

For scripts or CI pipelines:

```bash
mix xtweak.rename --to MyProject --yes --skip-docs
```

## Manual Steps After Rename

### 1. Review String References

The rename task handles module names in code, but **string literals** with module names may need manual updates:

```elixir
# This gets renamed automatically:
alias XTweak.Core.User

# These might need manual updates:
Logger.info("Starting XTweak application")  # ← Check these
error_msg = "XTweak.Core.User not found"     # ← Check these
```

Search for string references:
```bash
grep -r "xtweak\|XTweak" apps/ lib/ config/ --include="*.ex" --include="*.exs"
```

### 2. Update External References

If your project references xTweak externally:

- **CI/CD configs**: `.github/workflows/*.yml`
- **Docker files**: `Dockerfile`, `docker-compose.yml`
- **Deployment configs**: `rel/env.sh.eex`, Kubernetes manifests
- **Third-party integrations**: API keys, webhooks, etc.

### 3. Update Environment Variables

Check `.env` files or environment-specific configs:

```bash
# Old
DATABASE_URL=postgres://localhost/xtweak_dev

# New
DATABASE_URL=postgres://localhost/my_project_dev
```

### 4. Rebuild Frontend Assets

```bash
cd apps/my_project_web/assets
npm install  # Reinstall in case package.json changed
npm run build
```

### 5. Clear Build Artifacts

```bash
mix clean
rm -rf _build deps
mix deps.get
mix compile
```

## Validation Checklist

After rename, verify:

- [ ] `mix compile` succeeds with no warnings
- [ ] `mix test` passes (or expected failures documented)
- [ ] `mix format --check-formatted` passes
- [ ] All 4 umbrella apps compile independently:
  - [ ] `mix compile --app my_project_core`
  - [ ] `mix compile --app my_project_web`
  - [ ] `mix compile --app my_project_ui`
  - [ ] `mix compile --app my_project_docs`
- [ ] Development server starts: `mix phx.server`
- [ ] Database migrations work: `mix ash_postgres.migrate`
- [ ] Frontend builds: `cd apps/my_project_web/assets && npm run build`
- [ ] No references to `xtweak` in critical files:
  ```bash
  grep -ri "xtweak" config/ mix.exs apps/*/mix.exs --color
  ```

## Reverting/Rollback

If the rename goes wrong and you need to revert:

### If Git is Clean (Before Rename)

```bash
# Restore all files
git restore .

# Remove any new directories
git clean -fd
```

### If Git Has Uncommitted Changes

```bash
# Stash the broken changes
git stash

# Or create a backup branch
git checkout -b backup-before-revert
git add -A && git commit -m "Backup before revert"
git checkout main
git restore .
```

### Nuclear Option

If everything is broken:

```bash
# Delete the directory and re-clone
cd ..
rm -rf my-new-project
git clone https://github.com/yourusername/xTweak.git my-new-project
```

## Getting Help

If you encounter issues during rename:

1. **Check this guide**: Most common issues are documented above
2. **Run with dry-run**: `mix xtweak.rename --to MyProject --dry-run`
3. **Check logs**: Look for error messages in the rename output
4. **Search for references**: `grep -ri "xtweak" apps/ lib/ config/`
5. **Use the agent**: Run Claude Code with the `project-renamer` agent
6. **Open an issue**: https://github.com/yourusername/xTweak/issues

## Pro Tips

1. **Always use dry-run first** to preview changes
2. **Ensure git is clean** before renaming
3. **Rename immediately after cloning** before making changes
4. **Test after rename** with `mix test` to catch issues early
5. **Keep database names consistent** with app names for clarity
6. **Document your rename** in commit message for future reference

## Example: Complete Rename Flow

Here's a real example of renaming xTweak to "Acme":

```bash
# Clone
git clone https://github.com/yourusername/xTweak.git acme
cd acme

# Fresh git
rm -rf .git && git init

# Install deps
mix deps.get
cd apps/xtweak_web/assets && npm install && cd ../../..

# Dry run to preview
mix xtweak.rename --to Acme --dry-run

# Looks good! Apply it
mix xtweak.rename --to Acme

# Post-rename cleanup
mix deps.get
mix clean
mix compile
mix format

# Create databases
MIX_ENV=dev mix ash_postgres.create
MIX_ENV=dev mix ash_postgres.migrate
MIX_ENV=test mix ash_postgres.create

# Run tests
mix test

# Start server
mix phx.server

# Commit
git add -A
git commit -m "Initialize Acme project from xTweak template"
```

Done! You now have a fully renamed project ready for development.

## Next Steps

After successfully renaming:

1. **Read the main README**: `README.md`
2. **Configure your environment**: Update `.env` files
3. **Set up your database**: Run seeds if needed
4. **Start developing**: Create your first resource
5. **Deploy**: Set up your hosting/deployment

Happy coding! 🚀
