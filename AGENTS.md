# Repository Guidelines

## Project Structure & Module Organization
- `apps/`: Umbrella apps
  - `xpando_core/`: Ash domain, data, and business logic.
  - `xpando_web/`: Phoenix web app (LiveView, endpoints, assets).
  - `xpando_node/`: Node/peer runtime components.
- `config/`: Environment configs (`dev.exs`, `test.exs`, `prod.exs`, `runtime.exs`).
- `apps/xpando_web/assets/`: JS/CSS (Tailwind, esbuild) and UI libs.

## Build, Test, and Development Commands
- `make install`: `mix deps.get` + `npm install` in `apps/xpando_web/assets`.
- `make setup`: `mix ecto.setup` then `mix assets.setup` (web assets). If missing, run `mix cmd --app xpando_web mix assets.setup`.
- `make server`: `mix phx.server`.
- `make test`: `mix test` (umbrella tests).
- `make quality` / `make quality-full`: `mix quality` / `mix quality.full` (format, Credo, compile; “full” adds tests + `deps.audit`).
- `make ci-check`: `mix ci.local` (format check, Credo strict, WAE compile).
- Useful: `make format`, `make dialyzer`, `make security`, `make pre-push-check`, `make clean`.

## Architecture Overview
```
               +-------------------+
               |  xpando_web (UI)  |
               | Phoenix + LiveView|
               +---------+---------+
                         |
                         v
                 +-------+-------+
                 |  xpando_core  |
                 |  Ash Domains  |
                 +-------+-------+
                         ^
                         |
               +---------+---------+
               |  xpando_node      |
               |  P2P/cluster ops  |
               +-------------------+
```
- Web/Node depend on Core; Core has no web deps.

## Coding Style & Naming Conventions
- Elixir: `mix format` (2‑space); Credo enforced. Modules `PascalCase`, files `snake_case.ex`.
- Phoenix/Ash: Contexts in `xpando_core`; web code in `xpando_web/lib/**`.
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

## TideWave MCP Setup (Codex CLI)
- Proxy script: `scripts/mcp/tidewave-stdio-proxy.js` (Node ≥ 18; bridges stdio ↔ HTTP).
- Minimal TOML (`~/.codex/config.toml`, WSL):
  
  ```toml
  [mcp_servers.tidewave]
  command = "node"
  args = ["/home/fodurrr/dev/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js"]
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
  args = ["-lc", "TIDEWAVE_BASE_URL=http://127.0.0.1:4000/tidewave/mcp TIDEWAVE_PROTOCOL_VERSION=2025-03-26 TIDEWAVE_DEBUG=1 node /home/fodurrr/dev/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js 2>>/tmp/tidewave-proxy.log"]
  ```

- Windows launcher note: if Codex runs on Windows, run the proxy in WSL:
  
  ```toml
  command = "wsl"
  args = ["node", "/home/fodurrr/dev/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js"]
  ```

## Ash AI MCP Setup (Codex CLI)
- Proxy script: `scripts/mcp/ashai-stdio-proxy.js` (Node ≥ 18).
- Minimal TOML (WSL):

  ```toml
  [mcp_servers.ash_ai]
  command = "node"
  args = ["/home/fodurrr/dev/xpando_ai/scripts/mcp/ashai-stdio-proxy.js"]
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
  args = ["-lc", "ASHAI_BASE_URL=http://127.0.0.1:4000/ash_ai/mcp ASHAI_PROTOCOL_VERSION=2025-03-26 ASHAI_DEBUG=1 node /home/fodurrr/dev/xpando_ai/scripts/mcp/ashai-stdio-proxy.js 2>>/tmp/ashai-proxy.log"]
  ```
