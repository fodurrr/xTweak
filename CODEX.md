# Codex Code Guidelines · xTweak

## How to Use This Playbook
- Treat this document as the high-level contract; detailed instructions live in the pattern library (`.codex/patterns/README.md`).
- Load the **Core Pattern Stack** (`placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`) before implementing anything.
- Use agents documented in `.codex/AGENT_USAGE_GUIDE.md` for focused tasks. Each agent lists the patterns it consumes via `pattern-stack`.

## Project Snapshot (October 27, 2025)
- **Umbrella apps**: `xtweak_core` (Ash domain logic), `xtweak_web` (Phoenix + LiveView), `xtweak_docs` (documentation), `xtweak_ui` (component library).
- **Domain module**: `XTweak.Core`.
- **Web namespace**: `XTweakWeb`.
- **Frontend stack**: Tailwind CSS + DaisyUI, validated with Playwright MCP tools.
- **Data layer**: Ash Framework 3.7.6+ over Postgres—no direct Ecto schemas or Repo calls.
- **Recent updates**: Dependency upgrade completed (30 packages), Newsletter resource added with authorization policies, Dialyzer cleanup completed, CVE-2025-48043 security fix applied.

## 5 Critical Principles (Read Before Every Session)
1. **MCP first** – Verification beats assumption. Use Tidewave/Ash/Context7 MCP tools before writing or editing code.
2. **Ash everywhere** – Model data with Ash resources/actions/policies. Generators + `ash-resource-template` pattern are mandatory starting points.
3. **Respect umbrella boundaries** – Core has no web deps; web depends on core only. Keep interfaces clean.
4. **Generator-first, customize second** – Check `mcp__ash_ai__list_generators`, run scaffold with `--yes`, then extend safely.
5. **Quality gates** – Run `mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, and targeted `mix test` before declaring success.

## Placeholder Discipline
- All shared examples use `{Placeholder}` tokens. See `placeholder-basics.md` for the canonical explanation and wrong/right examples.
- Always perform `phase-zero-context` to detect real module names, then replace every token before responding.

## Recommended Workflow (per task)
- **Implementation**: `mcp-verify-first` → domain-specific agent (e.g., `ash-resource-architect`, `frontend-design-enforcer`) → `code-reviewer`/`code-review-implement` for validation.
- **Reviews**: `mcp-verify-first` → `code-reviewer` (analysis) → `code-review-implement` (fixes) → rerun `code-reviewer`.
- **Testing**: `mcp-verify-first` → `test-builder` → targeted `mix test` commands → document with `collaboration-handoff`.
- **Security**: `mcp-verify-first` → `security-reviewer` → follow up with owners.

## Codex Launch Syntax

All agents are launched using the xTweak repo-local Codex configuration:

```bash
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-[agent-name] "PLAN"
```

**Quick Setup:**
```bash
make codex-setup    # One-time local configuration
make codex-validate # Verify configuration is valid
```

**Example Agent Launches:**
```bash
# Verify project state before starting work
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first "List all Ash resources and domains"

# Design a new Ash resource
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-ash-resource-architect "Add Comment resource with user relationship and policies"

# Build frontend feature
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-frontend-design-enforcer "Implement user profile LiveView page with form validation"

# Write tests
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-test-builder "Write comprehensive tests for Newsletter resource"

# Review code quality
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-code-reviewer "Review apps/xtweak_core/lib/xtweak/core/user.ex"
```

## Tooling Cheat Sheet
- **Tidewave MCP**: `project_eval`, `get_docs`, `get_logs`, `search_package_docs`, `get_ecto_schemas`, `execute_sql_query` (debug only).
- **Ash AI MCP**: `list_ash_resources`, `list_generators`, `get_usage_rules`.
- **Context7 MCP**: `resolve-library-id`, `get-library-docs` (DaisyUI, Cytoscape, etc.).
- **Playwright MCP**: browser navigation, screenshots, console capture for UI verification.

## Quality Gates & Commands
```bash
mix format
mix credo --strict
mix compile --warnings-as-errors
mix test --only <tag>
mix test apps/xtweak_core/test/xtweak/core/<resource>_test.exs
mix ash_postgres.generate_migrations
```

## Git & Change Control
- Never commit/push without explicit direction.
- Use `TodoWrite` to manage multi-step edits; clear tasks before handing off.
- Summaries for handoffs should follow `collaboration-handoff` pattern (summary, artifacts, outstanding items, validation, next steps).

## Reference Material
- `.codex/patterns/README.md` – index of reusable patterns with version metadata.
- `.codex/AGENT_USAGE_GUIDE.md` – agent matrix and selection guide.
- `.codex/agent-workflows.md` – recommended multi-agent sequences.
- `.codex/CHANGELOG.md` – pattern library and agent change log.
- `.codex/agent-reports/` – detailed reports from agent executions (dependency audits, reviews, etc.).
- `dev_docs/claude_agent_workflow.md` – developer guide to working with AI agents (applicable to Codex).
- `scripts/codex/docs/codex_profiles.md` – comprehensive Codex profile documentation.

Stay pattern-first, cite MCP evidence, and keep responses sharp and scannable.
