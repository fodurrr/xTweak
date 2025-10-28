#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/../.." && pwd)
TARGET="${REPO_ROOT}/.codex/config.toml"

echo "[codex] Validating project-local Codex configuration"

if ! command -v codex >/dev/null 2>&1; then
  echo "[codex] 'codex' CLI not found on PATH. Install Codex CLI before continuing." >&2
  exit 1
fi

if [[ ! -f "${TARGET}" ]]; then
  echo "[codex] ${TARGET} not found. This project requires .codex/config.toml to exist." >&2
  exit 1
fi

# Check for native HTTP MCP configuration
if ! grep -q "experimental_use_rmcp_client.*true" "${TARGET}"; then
  echo "[codex] Warning: experimental_use_rmcp_client not enabled. Native HTTP MCP support requires this flag." >&2
  echo "[codex] Add 'experimental_use_rmcp_client = true' to your config." >&2
fi

# Check that HTTP MCP servers use 'url' field instead of 'command'
has_http_config=false
if grep -q 'url.*=.*"http.*://.*:4000/.*wave/mcp"' "${TARGET}"; then
  has_http_config=true
fi

if [[ "${has_http_config}" == "true" ]]; then
  echo "[codex] ✓ Native HTTP MCP configuration detected (TideWave/AshAI)"
else
  echo "[codex] Warning: No native HTTP MCP configuration found." >&2
  echo "[codex] Expected: [mcp_servers.tidewave] url = \"http://127.0.0.1:4000/tidewave/mcp\"" >&2
fi

# Verify Context7 and Playwright are configured
if ! grep -q '@upstash/context7-mcp' "${TARGET}"; then
  echo "[codex] Warning: Context7 MCP server not found in config" >&2
fi

if ! grep -q '@playwright/mcp' "${TARGET}"; then
  echo "[codex] Warning: Playwright MCP server not found in config" >&2
fi

echo "[codex] Configuration looks good! Launch Codex from project root:"
echo "  cd ${REPO_ROOT}"
echo "  codex --profile xtweak-mcp-verify-first \"PLAN\""
