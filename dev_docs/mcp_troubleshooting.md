# MCP Troubleshooting (Codex CLI + WSL)

This guide helps diagnose stdio↔HTTP MCP setups for TideWave and Ash AI using the local proxy scripts in this repo.

## Quick Health Checks
- TideWave init (expect JSON with tools and protocolVersion):
  
  ```bash
  curl -sS -X POST -H 'content-type: application/json' \
    -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","clientInfo":{"name":"test"},"capabilities":{}}}' \
    http://127.0.0.1:4000/tidewave/mcp
  ```

- Ash AI init (expect JSON with protocolVersion):
  
  ```bash
  curl -sS -X POST -H 'content-type: application/json' \
    -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","clientInfo":{"name":"test"},"capabilities":{}}}' \
    http://127.0.0.1:4000/ash_ai/mcp
  ```

If curl works, the server endpoint is healthy.

## Enable Proxy Debug Logging
Use a logging wrapper to capture proxy stderr to /tmp without polluting MCP stdout.

- TideWave:
  
  ```toml
  [mcp_servers.tidewave]
  command = "bash"
  args = ["-lc", "TIDEWAVE_BASE_URL=http://127.0.0.1:4000/tidewave/mcp TIDEWAVE_PROTOCOL_VERSION=2025-03-26 TIDEWAVE_DEBUG=1 node /home/you/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js 2>>/tmp/tidewave-proxy.log"]
  ```

- Ash AI:
  
  ```toml
  [mcp_servers.ash_ai]
  command = "bash"
  args = ["-lc", "ASHAI_BASE_URL=http://127.0.0.1:4000/ash_ai/mcp ASHAI_PROTOCOL_VERSION=2025-03-26 ASHAI_DEBUG=1 node /home/you/xpando_ai/scripts/mcp/ashai-stdio-proxy.js 2>>/tmp/ashai-proxy.log"]
  ```

Tail logs while starting Codex:

```bash
tail -f /tmp/tidewave-proxy.log /tmp/ashai-proxy.log
```

Expected lines:
- "stdin chunk bytes=…" — Codex wrote to proxy
- "RAW JSON fallback" or printed header — framing detected
- "<- client method=initialize id=1"
- "POST …/mcp" and "HTTP 200 bytes=…"
- "-> client RAW json bytes=…" (or Content-Length: …) — proxy replied

## Common Symptoms and Fixes
- Error: request timed out
  - Cause: Wrong host/port/path or missing protocolVersion.
  - Fix: Use 127.0.0.1 (not localhost), ensure server path is `/tidewave/mcp` or `/ash_ai/mcp`, and set `*_PROTOCOL_VERSION=2025-03-26`.

- No MCP tools available
  - Cause: Client uses RAW JSON but proxy replied with LSP framing, or tools/list not forwarded.
  - Fix: Set `TIDEWAVE_FORCE_RAW=1` or `ASHAI_FORCE_RAW=1` in TOML env; check logs for `tools/list` flow and RAW reply.

- Nothing in /tmp logs
  - Cause: Codex reading a different config.
  - Fix: Confirm you edited WSL `~/.codex/config.toml`. Temporarily set `command = "bash"`, `args=["-lc","exit 99"]` to confirm it’s read.

- WSL vs Windows
  - If Codex runs on Windows: use `command="wsl"` and WSL paths, or set base URL to `http://wsl.localhost:4000/...`.

- Node not found
  - Ensure `node -v` ≥ 18 in the same shell you start Codex from. Use absolute path to node if needed (e.g., `/usr/bin/node`).

## Minimal Working TOML (WSL)
- TideWave:
  
  ```toml
  [mcp_servers.tidewave]
  command = "node"
  args = ["/home/you/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js"]
  env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp", TIDEWAVE_PROTOCOL_VERSION = "2025-03-26" }
  ```

- Ash AI:
  
  ```toml
  [mcp_servers.ash_ai]
  command = "node"
  args = ["/home/you/xpando_ai/scripts/mcp/ashai-stdio-proxy.js"]
  env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp", ASHAI_PROTOCOL_VERSION = "2025-03-26" }
  ```

If your Codex build uses RAW JSON, add `*_FORCE_RAW = "1"` to the env.

## Manual Stdio Handshake Test
If in doubt, send a correctly framed initialize to the proxy directly:

```bash
BODY='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"clientInfo":{"name":"test"},"capabilities":{},"protocolVersion":"2025-03-26"}}'
LEN=$(printf '%s' "$BODY" | wc -c)
printf 'Content-Length: %d\r\n\r\n%s' "$LEN" "$BODY" | node /home/you/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js | head -c 200
```

You should see a framed response (`Content-Length: …`).

---
If issues persist, capture the last 15 lines from `/tmp/*-proxy.log` and your `[mcp_servers.*]` TOML blocks; those two bits of info are enough to pinpoint framing and connectivity.
