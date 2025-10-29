# MCP Troubleshooting (Codex CLI + Native HTTP Support)

This guide helps diagnose native HTTP MCP configurations for TideWave and Ash AI. **As of Codex CLI 0.50+, native HTTP support is available and the proxy scripts are no longer needed.**

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

## Native HTTP MCP Configuration

Codex CLI 0.50+ supports HTTP MCP servers natively. You need to enable the `experimental_use_rmcp_client` flag.

### Recommended Configuration

For xTweak, use the project-local `.codex/config.toml` at the repository root:

```toml
# Enable experimental RMCP client for native HTTP MCP support
experimental_use_rmcp_client = true

# TideWave - Native HTTP MCP server
[mcp_servers.tidewave]
url = "http://127.0.0.1:4000/tidewave/mcp"
# Optional: bearer_token_env_var = "TIDEWAVE_TOKEN"

# AshAI - Native HTTP MCP server
[mcp_servers.ash_ai]
url = "http://127.0.0.1:4000/ash_ai/mcp"
# Optional: bearer_token_env_var = "ASHAI_TOKEN"

# Context7 - STDIO MCP server (via npx)
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

# Playwright - STDIO MCP server (via npx)
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp"]
```

### Verify Configuration

From the xTweak project root:

```bash
cd /path/to/xTweak

# List all configured MCP servers (reads .codex/config.toml automatically)
codex mcp list

# Check specific server details
codex mcp get tidewave
codex mcp get ash_ai
```

Expected output for HTTP servers:
- `transport: streamable_http`
- `url: http://127.0.0.1:4000/...`

## Common Symptoms and Fixes

### Error: request timed out
- **Cause**: Wrong host/port/path or Phoenix server not running.
- **Fix**:
  - Use `127.0.0.1` (not `localhost`)
  - Ensure Phoenix server is running: `mix phx.server`
  - Verify endpoints: `/tidewave/mcp` and `/ash_ai/mcp`
  - Test with curl (see Quick Health Checks above)

### MCP servers not detected
- **Cause**: `experimental_use_rmcp_client` flag not enabled.
- **Fix**: Add `experimental_use_rmcp_client = true` at the top of your config file.

### Wrong transport type showing
- **Cause**: Old proxy-based configuration still present.
- **Fix**:
  - Remove old `command` and `args` fields from `[mcp_servers.tidewave]` and `[mcp_servers.ash_ai]`
  - Replace with `url` field
  - Run `codex mcp list` to verify `transport: streamable_http`

### Configuration not being read
- **Cause**: Wrong working directory or global config overriding project config.
- **Fix**:
  - Ensure you're running `codex` from the xTweak project root directory
  - Codex automatically reads `.codex/config.toml` from the current working directory
  - Check `~/.codex/config.toml` (global config) for conflicting settings
  - Use `codex mcp list` to see which configuration is active

### WSL-specific issues
- If Codex runs on Windows but servers run in WSL:
  - Use `http://wsl.localhost:4000/...` as the URL
  - Or use `127.0.0.1` if port forwarding is configured

## Minimal Working Configuration

Complete working configuration for all 4 MCP servers:

```toml
# Enable native HTTP MCP support
experimental_use_rmcp_client = true

# Default model
model = "gpt-5-codex-medium"

# TideWave - Native HTTP
[mcp_servers.tidewave]
url = "http://127.0.0.1:4000/tidewave/mcp"

# AshAI - Native HTTP
[mcp_servers.ash_ai]
url = "http://127.0.0.1:4000/ash_ai/mcp"

# Context7 - STDIO via npx
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

# Playwright - STDIO via npx
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp"]
```

---

## Getting Help

If issues persist:
1. Ensure you're running from the xTweak project root directory
2. Check `codex mcp list` output
3. Verify Phoenix server is running (`mix phx.server`)
4. Test endpoints with curl (see Quick Health Checks)
5. Review `.codex/config.toml` and check `~/.codex/config.toml` for conflicting configurations
