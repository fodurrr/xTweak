# Framework Rules

This directory contains **all framework rules and xTweak-specific patterns**.

## What's Here

All framework documentation is now consolidated in this single location:
- **Root file**: `/usage-rules.md` - Overview and index of all framework rules
- **This folder**: `/usage-rules/` - Individual framework rule files

This directory includes:
1. **Framework basics** - Core patterns from Ash, Phoenix, and other dependencies
2. **xTweak-specific patterns** - Project conventions and extensions

**For AI agents**: Read files from `/usage-rules/` for complete framework guidance.

**Project**: https://github.com/ash-project/usage_rules

## How This Works

### For AI Agents

**Single-location documentation system**:

All framework rules are in `/usage-rules/` at the project root:
- Framework basics from package authors
- xTweak-specific patterns and conventions
- Project decisions and rationale
- Integration patterns

**Example workflow**:
```
Agent needs to create Ash resource:
1. Read /usage-rules/ash.md (complete guidance)
2. Apply patterns when generating code
```

### For Humans

**This folder provides complete framework guidance:**
- Framework basics from Ash, Phoenix, etc.
- xTweak project conventions and decisions
- Rationale for choosing specific approaches
- Extensions to framework defaults
- Integration patterns unique to xTweak

## Available Framework Rules

### Core Framework Files

- **ash.md** - Ash framework patterns and xTweak conventions
  - Resource organization
  - Policy patterns
  - Code organization standards
  - Testing conventions

- **ash_postgres.md** - Database patterns
  - Schema naming conventions
  - Migration patterns
  - Data modeling decisions

- **ash_phoenix.md** - Phoenix/LiveView patterns
  - LiveView organization
  - Form patterns
  - Component structure

### Specialized Framework Files

- **ash_ai.md** - AI integration patterns
  - Vectorization usage
  - MCP server configuration
  - AI action patterns

- **ash_authentication.md** - Authentication patterns
  - Authentication strategies
  - Token handling

- **igniter.md** - Code generation patterns
  - When to use generators
  - Customization patterns

- **heex.md** - HEEx template conventions
  - Template organization
  - Component patterns
  - Accessibility standards

## Complete File List

All files in `/usage-rules/` (this directory):

- `ash.md` - Ash framework patterns
- `ash_postgres.md` - Database layer
- `ash_phoenix.md` - Phoenix integration
- `ash_ai.md` - AI integration
- `ash_authentication.md` - Authentication
- `heex.md` - HEEx templates and components
- `igniter.md` - Code generation
- `README.md` - This file

See `/usage-rules.md` (root) for the complete overview and index.

## Maintenance

### When to Update

**Update this directory when**:
- After upgrading Ash/Phoenix dependencies
- When xTweak conventions evolve
- After architectural decisions
- When adding project-specific patterns
- When upstream framework patterns change

### How to Update

**For framework basics** (from dependencies):
```bash
# Run setup script to sync from deps
bash scripts/setup_usage_rules.sh

# Or manually:
mix usage_rules.sync usage-rules.md ash phoenix ash_postgres --link-to-folder usage-rules
```

**For xTweak-specific patterns**:
- Manually edit files in this folder
- Add rationale and examples
- Document project decisions
- Keep patterns aligned with codebase

**Git tracking**: Yes - always track `/usage-rules/` to preserve version history

## For AI Agents: How to Use

When working with Ash/Phoenix/Elixir:

1. **Read relevant files from /usage-rules/**:
   ```
   Read /usage-rules/ash.md
   Read /usage-rules/ash_phoenix.md
   Read /usage-rules/heex.md
   ```

2. **Apply the patterns**:
   - Follow framework conventions
   - Apply xTweak-specific patterns
   - All guidance is in one place

## Learn More

- [Usage Rules Project](https://github.com/ash-project/usage_rules)
- [Ash Framework Docs](https://hexdocs.pm/ash)
- [Ash AI Documentation](https://hexdocs.pm/ash_ai)
- [Research on AI Code Generation Quality](https://github.com/ash-project/evals/blob/main/reports/flagship.md)
