# Repository Guidelines

This file follows the **AGENTS.md open standard**, read automatically by **Codex CLI, Cursor, GitHub Copilot, Jules, Aider**, and 20+ other AI coding tools.

> **📋 MANDATORY**: Read [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) first – These rules override all guidelines below.

> **Claude Code Users**: You're in the wrong file. See [CLAUDE.md](./CLAUDE.md) for Claude-specific workflows.

## Documentation

**Complete index**: [docs/README.md](./docs/README.md) – All documentation, guides, and references

**Codex CLI Setup**: [docs/codex_profiles.md](./docs/codex_profiles.md) – 21 agent profiles (see below for quick start)

## Project Structure & Module Organization
- `apps/`: Umbrella apps
  - `xtweak_core/`: Ash domain, data, and business logic.
  - `xtweak_web/`: Phoenix web app (LiveView, endpoints, assets).
  - Additional apps as needed for your domain.
- `config/`: Environment configs (`dev.exs`, `test.exs`, `prod.exs`, `runtime.exs`).
- `apps/xtweak_web/assets/`: JS/CSS (Tailwind, esbuild) and UI libs.

## Build, Test, and Development Commands
- `make install`: `mix deps.get` + `npm install` in `apps/xtweak_web/assets`.
- `make setup`: `mix ecto.setup` then `mix assets.setup` (web assets). If missing, run `mix cmd --app xtweak_web mix assets.setup`.
- `make server`: `mix phx.server`.
- `make test`: `mix test` (umbrella tests).
- `make quality` / `make quality-full`: `mix quality` / `mix quality.full` (format, Credo, compile; “full” adds tests + `deps.audit`).
- `make ci-check`: `mix ci.local` (format check, Credo strict, WAE compile).
- Useful: `make format`, `make dialyzer`, `make security`, `make pre-push-check`, `make clean`.

## Architecture Overview
```
               +-------------------+
               |  xtweak_web (UI)  |
               | Phoenix + LiveView|
               +---------+---------+
                         |
                         v
                 +-------+-------+
                 |  xtweak_core  |
                 |  Ash Domains  |
                 +-------+-------+
```
- Web depends on Core; Core has no web dependencies.
- Additional apps can be added as needed for your domain.

## Coding Style & Naming Conventions
- Elixir: `mix format` (2‑space); Credo enforced. Modules `PascalCase`, files `snake_case.ex`.
- Phoenix/Ash: Contexts in `xtweak_core`; web code in `xtweak_web/lib/**`.
- JS/CSS: Tailwind + esbuild; `kebab-case.js` under `assets/js/`.

## Testing Guidelines
- ExUnit. Place tests under the matching app’s `test/`; name `*_test.exs`.
- Run `mix test` (or `make test`). Cover Ash actions and Phoenix flows.

## Commit & Pull Request Guidelines
- Commits: Imperative mood, concise subject (e.g., “Add graph layout to dashboard”).
- PRs include: purpose/summary, linked issue(s), test notes, UI screenshots/GIFs.
- Pre‑PR: run `make quality-full` and ensure `mix ci.local` passes.

## Security & Configuration Tips
- Secrets via env in `config/runtime.exs` (`SECRET_KEY_BASE`, `PHX_SERVER`, `PORT`).
- Run `make security` (`mix deps.audit` + `sobelow`) before releases.

## Agents & MCP Instructions
- MCP servers configured project-locally for both Claude Code and Codex CLI
  - **Claude Code**: `.claude/settings.json` (team-shared configuration)
  - **Codex CLI**: `.codex/config.toml` (21 agent profiles)
- Keep Phoenix running; don't start/stop from MCP sessions.
- Key tools: `mcp__tidewave__project_eval`, `mcp__tidewave__get_docs`, `mcp__ash_ai__list_generators`.
- Flow: query → generate (Ash) → customize → `make quality-full`. See `CLAUDE.md` for details.

## Codex CLI Setup (Project-Local Configuration)
> **✅ Self-Contained**: All Codex configuration lives in `.codex/config.toml` at the project root. No global config changes needed!

**Quick Start**:
```bash
cd /path/to/xTweak
codex                                    # Automatically reads .codex/config.toml
codex --profile xtweak-mcp-verify-first "PLAN"  # Use a specific profile
```

**Validation**:
```bash
bash scripts/codex/validate.sh          # Validate configuration
codex mcp list                           # List all MCP servers
# Expected: TideWave & AshAI show "transport: streamable_http"
#           Context7 & Playwright show command-based stdio
```

**Configuration Details**:
- **Location**: `.codex/config.toml` (project root)
- **MCP Servers**: Native HTTP for TideWave/AshAI, stdio for Context7/Playwright
- **Profiles**: 21 Claude agent mirrors (see `docs/codex_profiles.md`)
- **Model**: GPT-5 Codex Medium (default)
- **Migration**: See `scripts/codex/MIGRATION.md` for history and rollback procedures

## Claude Code Setup

Claude Code users should start with [CLAUDE.md](./CLAUDE.md) – contains complete configuration and pattern-first workflows.
