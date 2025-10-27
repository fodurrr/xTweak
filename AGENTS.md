# Repository Guidelines

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
- MCP servers in `.mcp.json`: `tidewave`, `ash_ai`, `playwright`, `context7`.
- Keep Phoenix running; don’t start/stop from MCP sessions.
- Key tools: `mcp__tidewave__project_eval`, `mcp__tidewave__get_docs`, `mcp__ash_ai__list_generators`.
- Flow: query → generate (Ash) → customize → `make quality-full`. See `CLAUDE.md` for details.
- Codex parity lives in-repo: run `make codex-setup` and `make codex-validate` to regenerate `scripts/codex/local/`, then launch via `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first "PLAN"` (full matrix in `docs/codex_profiles.md`).

## TideWave MCP Setup (Codex CLI)
> Prefer the repo-local workflow in `docs/codex_profiles.md`; the snippet below is kept for reference when configuring Codex globally.
- Proxy script: `scripts/mcp/tidewave-stdio-proxy.js` (Node ≥ 18; bridges stdio ↔ HTTP).
- Minimal TOML (`~/.codex/config.toml`, WSL):

  ```toml
  [mcp_servers.tidewave]
  command = "node"
  args = ["/path/to/your/project/scripts/mcp/tidewave-stdio-proxy.js"]
  env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp", TIDEWAVE_PROTOCOL_VERSION = "2025-03-26" }
  ```

- If your client speaks raw JSON (no Content-Length), force raw replies:

  ```toml
  env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp", TIDEWAVE_PROTOCOL_VERSION = "2025-03-26", TIDEWAVE_FORCE_RAW = "1" }
  ```

- Debug wrapper (optional): redirect proxy logs to `/tmp/tidewave-proxy.log`:

  ```toml
  [mcp_servers.tidewave]
  command = "bash"
  args = ["-lc", "TIDEWAVE_BASE_URL=http://127.0.0.1:4000/tidewave/mcp TIDEWAVE_PROTOCOL_VERSION=2025-03-26 TIDEWAVE_DEBUG=1 node /path/to/your/project/scripts/mcp/tidewave-stdio-proxy.js 2>>/tmp/tidewave-proxy.log"]
  ```

- Windows launcher note: if Codex runs on Windows, run the proxy in WSL:

  ```toml
  command = "wsl"
  args = ["node", "/path/to/your/project/scripts/mcp/tidewave-stdio-proxy.js"]
  ```

## Ash AI MCP Setup (Codex CLI)
> Prefer the repo-local workflow in `docs/codex_profiles.md`; the snippet below is kept for reference when configuring Codex globally.
- Proxy script: `scripts/mcp/ashai-stdio-proxy.js` (Node ≥ 18).
- Minimal TOML (WSL):

  ```toml
  [mcp_servers.ash_ai]
  command = "node"
  args = ["/path/to/your/project/scripts/mcp/ashai-stdio-proxy.js"]
  env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp", ASHAI_PROTOCOL_VERSION = "2025-03-26" }
  ```

- Force RAW replies if your client uses raw JSON (no LSP framing):

  ```toml
  env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp", ASHAI_PROTOCOL_VERSION = "2025-03-26", ASHAI_FORCE_RAW = "1" }
  ```

- Debug wrapper (optional):

  ```toml
  [mcp_servers.ash_ai]
  command = "bash"
  args = ["-lc", "ASHAI_BASE_URL=http://127.0.0.1:4000/ash_ai/mcp ASHAI_PROTOCOL_VERSION=2025-03-26 ASHAI_DEBUG=1 node /path/to/your/project/scripts/mcp/ashai-stdio-proxy.js 2>>/tmp/ashai-proxy.log"]
  ```

## Codex CLI Setup (xTweak Agent System)
> Prefer the repo-local workflow via `make codex-setup`; agents available in `.codex/agents/` with full pattern stack.

### Directory Structure
- **Agent directory**: `.codex/agents/` (21 specialized agents matching Claude parity)
- **Pattern library**: `.codex/patterns/` (shared with Claude via symlinks)
- **Launch guide**: `.codex/AGENT_USAGE_GUIDE.md` (agent matrix and selection)
- **Workflows**: `.codex/agent-workflows.md` (multi-agent sequences)
- **Guidelines**: `CODEX.md` (5 critical principles + tooling)
- **Reports**: `.codex/agent-reports/` (agent execution reports)
- **Changelog**: `.codex/CHANGELOG.md` (pattern library version tracking)

### Quick Start
```bash
make codex-setup    # One-time local configuration
make codex-validate # Verify configuration is valid
```

### Launch Syntax
All Codex agents use the repo-local configuration:
```bash
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-[agent-name] "PLAN"
```

### Example Agent Launches
```bash
# Verify project state
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first "List all Ash resources"

# Design Ash resource
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-ash-resource-architect "Add Comment resource"

# Build frontend
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-frontend-design-enforcer "Implement user profile page"

# Write tests
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-test-builder "Test Newsletter resource"

# Review code
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-code-reviewer "Review user.ex"
```

### Available Agents (21 Total)
Full agent matrix and selection guidance in `.codex/AGENT_USAGE_GUIDE.md`. Key agents:
- **mcp-verify-first**: Ground truth discovery before work begins
- **ash-resource-architect**: Design/extend Ash resources, actions, policies
- **frontend-design-enforcer**: LiveView UX and integration
- **test-builder**: Author/repair ExUnit test suites
- **code-reviewer**: Single-file audit with actionable reports
- **security-reviewer**: High-confidence security assessment
- See `.codex/AGENT_USAGE_GUIDE.md` for complete list

### Pattern Stack
All agents use the **Core Pattern Stack**: `placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`. Additional patterns available in `.codex/patterns/`.
