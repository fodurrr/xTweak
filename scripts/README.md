# xTweak Project Renamer Script

Standalone Elixir script to rename the xTweak template project to your own project name.

## Quick Start

```bash
# Run from project root
cd /path/to/xTweak

# Interactive mode (prompts for project name)
elixir scripts/rename_project.exs

# Or specify project name directly
elixir scripts/rename_project.exs --to MyProject

# Preview changes first (recommended)
elixir scripts/rename_project.exs --to MyProject --dry-run
```

## Features

✅ **Works in umbrella projects** - No Igniter limitations
✅ **No dependencies required** - Runs with just Elixir
✅ **Fast execution** - Completes in seconds
✅ **Safe and validated** - Checks git status, validates names
✅ **Dry-run mode** - Preview changes before applying
✅ **Idempotent** - Safe to run multiple times
✅ **Comprehensive** - Renames modules, atoms, directories, configs

## Usage

### Basic Commands

```bash
# Interactive mode with prompts
elixir scripts/rename_project.exs

# Specify target name
elixir scripts/rename_project.exs --to MyProject

# Dry-run to preview changes
elixir scripts/rename_project.exs --to MyProject --dry-run

# Automated mode (no prompts)
elixir scripts/rename_project.exs --to MyProject --yes
```

### Advanced Options

```bash
# Custom app prefix (different from module name)
elixir scripts/rename_project.exs --to MyCompany.MyApp --prefix myapp

# From custom source name (if already renamed once)
elixir scripts/rename_project.exs --from OldName --to NewName

# Skip documentation updates
elixir scripts/rename_project.exs --to MyProject --skip-docs

# Combine options
elixir scripts/rename_project.exs --to MyApp --prefix my_app --yes --skip-docs
```

## Command-Line Options

| Option | Alias | Description | Example |
|--------|-------|-------------|---------|
| `--to` | `-t` | Target project name (PascalCase) | `--to MyProject` |
| `--from` | `-f` | Source project name (default: XTweak) | `--from XTweak` |
| `--prefix` | `-p` | Custom app atom prefix (default: snake_case of --to) | `--prefix my_proj` |
| `--from-prefix` | | Source app prefix (default: xtweak) | `--from-prefix xtweak` |
| `--dry-run` | `-d` | Preview changes without applying | `--dry-run` |
| `--yes` | `-y` | Skip confirmation prompts | `--yes` |
| `--skip-docs` | | Don't update documentation files | `--skip-docs` |
| `--help` | `-h` | Show help message | `--help` |

## What Gets Renamed

### 1. Module Names

```elixir
# Before
defmodule XTweak.Core.User
defmodule XTweakCore.Application
defmodule XTweakWebWeb.Router

# After (--to MyProject)
defmodule MyProject.Core.User
defmodule MyProjectCore.Application
defmodule MyProjectWebWeb.Router
```

### 2. App Atoms

```elixir
# Before
:xtweak, :xtweak_core, :xtweak_web, :xtweak_ui, :xtweak_docs

# After (--to MyProject, prefix defaults to myproject)
:myproject, :myproject_core, :myproject_web, :myproject_ui, :myproject_docs
```

### 3. Directories

```
apps/xtweak_core/     → apps/myproject_core/
apps/xtweak_web/      → apps/myproject_web/
apps/xtweak_ui/       → apps/myproject_ui/
apps/xtweak_docs/     → apps/myproject_docs/

# And internal lib directories
lib/xtweak_core/      → lib/myproject_core/
lib/xtweak_web_web/   → lib/myproject_web_web/
```

### 4. Database Names

```elixir
# config/*.exs
database: "xtweak_dev"   → database: "myproject_dev"
database: "xtweak_test"  → database: "myproject_test"
database: "xtweak_prod"  → database: "myproject_prod"
```

### 5. Frontend Configs

**package.json:**
```json
{
  "name": "xtweak-web-assets" → "myproject-web-assets"
}
```

**tailwind.config.js:**
```javascript
"../lib/xtweak_web_web.ex" → "../lib/myproject_web_web.ex"
```

### 6. Documentation (unless `--skip-docs`)

- README.md
- apps/*/README.md
- docs/**/*.md
- .claude/**/*.md

## Examples

### Example 1: Simple Rename

```bash
$ elixir scripts/rename_project.exs --to Acme

📋 xTweak Project Renamer

🔍 Validating...

📋 Planned Transformations:

Module Names:
  XTweak         → Acme
  XTweakCore     → AcmeCore
  XTweakWeb      → AcmeWeb
  ...

⚠️  This will modify your files.

Continue with rename? [y/N] y

🔄 Applying transformations...
  → Renaming module names...
  → Updating frontend configs...
  → Renaming directories...
    apps/xtweak_core → apps/acme_core
    apps/xtweak_web → apps/acme_web
    ...

✅ Rename complete!
```

### Example 2: Dry-Run Preview

```bash
$ elixir scripts/rename_project.exs --to MyCompany.MyApp --dry-run

📋 xTweak Project Renamer

🔍 Validating...

📋 Planned Transformations:

Module Names:
  XTweak              → MyCompany.MyApp
  XTweakCore          → MyCompany.MyAppCore
  XTweak.Core         → MyCompany.MyApp.Core
  ...

App Atoms:
  :xtweak_core        → :mycompany_myapp_core
  ...

🔍 DRY RUN MODE - No changes will be applied
```

### Example 3: Custom Prefix

```bash
# Module names: MyCompany.MyApp.*
# App atoms: :myapp_core, :myapp_web, etc.
$ elixir scripts/rename_project.exs --to MyCompany.MyApp --prefix myapp --yes
```

### Example 4: Already Renamed Once

```bash
# If you already renamed XTweak → TempName, now rename TempName → FinalName
$ elixir scripts/rename_project.exs --from TempName --to FinalName
```

## Validation & Safety

### Before Execution

The script validates:

✓ **Project name format** - Must be PascalCase (e.g., MyProject, My.Project)
✓ **No underscores** - Module names shouldn't contain underscores
✓ **App prefix format** - Must be snake_case (e.g., my_project)
✓ **Git status** - Working directory should be clean
✓ **No conflicts** - Target directories shouldn't already exist

### During Execution

- Shows progress for each operation
- Applies replacements in correct order (most specific first)
- Handles file access errors gracefully
- Preserves file permissions

### After Execution

The script provides clear next steps:
- Run `mix deps.get`
- Recompile the project
- Run tests
- Create new databases
- Commit changes

## Rollback

If something goes wrong, rollback is simple:

```bash
# If git working directory was clean before rename
git restore .
git clean -fd

# Or use stash if you had uncommitted changes
git stash
git restore .
```

The script is **idempotent** - it's safe to run multiple times. If a rename partially completes, you can run it again.

## Troubleshooting

### Error: "Project name must be PascalCase"

**Problem:** Invalid project name format

**Solution:** Use PascalCase (capitalize first letter of each word):
```bash
# ✅ Correct
--to MyProject
--to MyCompany.MyApp

# ❌ Wrong
--to my_project      # snake_case
--to My_Project      # underscores
--to myproject       # lowercase
```

### Error: "Git working directory is not clean"

**Problem:** Uncommitted changes in git

**Solution:** Commit or stash changes first:
```bash
git add -A
git commit -m "Prepare for rename"
# OR
git stash
```

### Error: "Target directory already exists"

**Problem:** The target directory name conflicts with existing directory

**Solution:** Remove or rename the conflicting directory:
```bash
mv apps/myproject_core apps/myproject_core_old
# Then run rename again
```

### Compilation Errors After Rename

**Problem:** Project doesn't compile after rename

**Solution:** Clean and reinstall dependencies:
```bash
mix clean
rm -rf _build deps
mix deps.get
mix compile
```

### Some References Not Renamed

**Problem:** Finding old project name in strings/comments

**Solution:** These are typically string literals (logs, error messages). Find and replace manually:
```bash
# Find remaining references
grep -r "XTweak" apps/ lib/ config/ --exclude-dir=deps --exclude-dir=_build

# Or use rg (ripgrep)
rg "XTweak" apps/ lib/ config/
```

## Known Limitations

### 1. String Literals in Code

Module names in string literals (logs, error messages) won't be renamed:

```elixir
# This gets renamed automatically
alias XTweak.Core.User

# These won't be renamed (string literals)
Logger.info("Starting XTweak application")
error = "XTweak.Core.User not found"
```

**Impact:** Cosmetic only (logs/error messages)
**Solution:** Search and replace manually if needed

### 2. Historical Migrations

Migration files keep old module names - this is by design:

```elixir
# Migration file - stays unchanged
defmodule XTweak.Repo.Migrations.CreateUsers do
  # ...
end
```

**Impact:** None - migrations are historical records
**Solution:** Don't rename migrations

### 3. Frontend Theme Names

DaisyUI theme CSS classes may still reference old names:

```javascript
// May still say "xpando-light-sophisticated"
themes: ["light", "dark", "xpando-light-sophisticated"]
```

**Impact:** Theme names in CSS
**Solution:** Customize themes manually in Tailwind config

## Performance

**Typical execution time:**
- Content replacement: ~2-3 seconds
- Directory renaming: ~1 second
- Total: **<5 seconds** for complete rename

**Files processed:**
- ~100-150 Elixir files (.ex, .exs)
- ~10-20 config files
- ~5-10 frontend files
- ~10-20 documentation files (if not skipped)

## Integration with Other Tools

### Use with GitHub Template

```bash
# Create new repo from template
gh repo create my-new-project --template yourusername/xTweak --private
cd my-new-project

# Rename immediately
elixir scripts/rename_project.exs --to MyProject --yes

# Setup and commit
mix deps.get
mix compile
git add -A
git commit -m "Initialize MyProject from xTweak template"
git push
```

### Use in CI/Automation

```bash
#!/bin/bash
# setup-from-template.sh

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./setup-from-template.sh ProjectName"
  exit 1
fi

# Clone template
git clone https://github.com/yourusername/xTweak.git "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Rename (automated mode)
elixir scripts/rename_project.exs --to "$PROJECT_NAME" --yes

# Setup
mix deps.get
mix compile
mix test

echo "✅ $PROJECT_NAME setup complete!"
```

## Comparison with Mix Task

| Feature | Script (`rename_project.exs`) | Mix Task (`mix xtweak.rename`) |
|---------|-------------------------------|--------------------------------|
| Works in umbrella | ✅ YES | ❌ NO (Igniter limitation) |
| Requires deps | ❌ NO | ✅ YES (needs mix deps.get) |
| Execution speed | ⚡ <5 seconds | ⚡ ~15 seconds |
| Maintainability | ✅ Single file | ⚠️ Multiple modules |
| AST manipulation | ❌ NO (string replace) | ✅ YES (precise) |
| Handles 95%+ cases | ✅ YES | ✅ YES |
| User-friendly | ✅ YES | ✅ YES |

**Recommendation:** Use the script (`rename_project.exs`) as the primary method until Igniter supports umbrella projects.

## Getting Help

If you encounter issues:

1. **Check this README** - Most common issues documented above
2. **Run with --help** - Shows built-in usage information
3. **Use --dry-run** - Preview changes before applying
4. **Check git status** - Ensure clean working directory
5. **Search for references** - Use grep/rg to find remaining old names
6. **Open an issue** - Report bugs or request features

## Contributing

Found a bug or want to improve the script? Contributions welcome!

1. Test your changes with `--dry-run` first
2. Ensure script remains a single file (no external deps)
3. Add examples for new features
4. Update this README

## License

Same as xTweak project license.

---

**Happy renaming! 🎉**

For complete template usage guide, see [`docs/guides/template-initialization.md`](../docs/guides/template-initialization.md).
