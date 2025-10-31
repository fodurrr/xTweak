# Claude Code Guidelines · xTweak

> **📋 MANDATORY**: Read [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) first – These rules override all instructions below.

## Essential Reading (in order)

1. [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) – Mandatory rules that override everything
2. [.claude/README.md](./.claude/README.md) – Agent matrix, workflows, model strategy, patterns
3. [AI_docs/README.md](./AI_docs/README.md) – Complete AI documentation index
4. [AI_docs/prd/QUICK_START.md](./AI_docs/prd/QUICK_START.md) – Current PRD status
5. [Current sprint plan] – Auto-loaded based on PRD phase
6. [/usage-rules.md](./usage-rules.md) – Framework overview index
7. [/usage-rules/](./usage-rules/) – Framework rules and xTweak-specific patterns
8. [.claude/patterns/](.//.claude/patterns/) – Reusable execution patterns

## Additional References

- [.claude/patterns/README.md](./.claude/patterns/README.md) – Pattern library details
- [.claude/commands/](./.claude/commands/) – PRD-centric slash commands

## How to Use This Playbook

- Treat this document as the high-level contract; detailed instructions live in `.claude/README.md` and pattern library (`.claude/patterns/README.md`).
- Read `.claude/README.md` for agent matrix, workflows, and model selection strategy.
- Load the **Core Pattern Stack** (`placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`) before implementing anything.

## Project Snapshot (October 30, 2025)

- **Umbrella apps**: `xtweak_core` (Ash domain logic), `xtweak_web` (Phoenix + LiveView), `xtweak_docs` (documentation), `xtweak_ui` (component library).
- **Domain module**: `XTweak.Core`.
- **Web namespace**: `XTweakWeb`.
- **Frontend stack**: Tailwind CSS (no component framework), validated with Playwright MCP tools.
- **Data layer**: Ash Framework 3.7.6+ over Postgres—no direct Ecto schemas or Repo calls.
- **Recent updates**: AI workflow refactor complete (2025-10-30) - PRD-centric commands, consolidated documentation, usage_rules integration.

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

See [.claude/README.md](./.claude/README.md) for complete workflows.

## Tooling Cheat Sheet

- **Tidewave MCP**: `project_eval`, `get_docs`, `get_logs`, `search_package_docs`, `get_ecto_schemas`, `execute_sql_query` (debug only).
- **Ash AI MCP**: `list_ash_resources`, `list_generators`, `get_usage_rules` (discovers usage rules from deps).
- **Context7 MCP**: `resolve-library-id`, `get-library-docs` (Nuxt UI reference, Cytoscape, etc.).
- **Playwright MCP**: browser navigation, screenshots, console capture for UI verification.

## Elixir/Ash Framework Rules

**All framework rules are now in `/usage-rules/`** at project root:
- [/usage-rules.md](./usage-rules.md) – Overview and index of all framework rules
- [/usage-rules/](./usage-rules/) – Individual framework rule files

**Core Files**:
- **Core**: [usage-rules/ash.md](./usage-rules/ash.md) – Ash framework patterns
- **Data Layer**: [usage-rules/ash_postgres.md](./usage-rules/ash_postgres.md) – Database patterns
- **Web Integration**: [usage-rules/ash_phoenix.md](./usage-rules/ash_phoenix.md) – Phoenix/LiveView patterns
- **AI Integration**: [usage-rules/ash_ai.md](./usage-rules/ash_ai.md) – AI integration patterns
- **Authentication**: [usage-rules/ash_authentication.md](./usage-rules/ash_authentication.md) – Auth patterns
- **Templates**: [usage-rules/heex.md](./usage-rules/heex.md) – HEEx template conventions
- **Code Generation**: [usage-rules/igniter.md](./usage-rules/igniter.md) – Generator patterns

**Agents should**: Read relevant files from `/usage-rules/` for all framework guidance

## Usage Rules (Automatic Discovery)

Package usage rules are **automatically discovered** via the Ash AI MCP server (`mcp__ash_ai__get_usage_rules`). No manual sync required!

**How it works**:
- MCP server scans `deps/` for `usage-rules.md` files
- Currently available: 17 rule files from ash, phoenix, igniter, and more
- Agents read relevant rules on-demand based on task context
- Always current with installed package versions

**Human-readable copies** maintained in `/usage-rules/` for reference.

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

- `.claude/README.md` – **Single reference** for agents (matrix, workflows, model strategy, patterns)
- `.claude/patterns/README.md` – Pattern library index with version metadata
- `.claude/CHANGELOG.md` – Pattern library and agent change log
- `.claude/commands/` – PRD-centric slash commands (5 commands)
- `AI_docs/prd/06-sprint-plans/` – Sprint plans with REPORTS.md (agent execution logs)
- `/usage-rules.md` and `/usage-rules/` – Framework rules and xTweak-specific patterns
- [AI_docs/README.md](./AI_docs/README.md) – Complete AI documentation index

Stay pattern-first, cite MCP evidence, and keep responses sharp and scannable.
