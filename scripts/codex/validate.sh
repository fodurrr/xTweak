#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/../.." && pwd)
LOCAL_HOME=${LOCAL_CODE_HOME:-"${REPO_ROOT}/scripts/codex/local"}
TARGET="${LOCAL_HOME}/config.xtweak.toml"

echo "[codex] Validating repo-local configuration"

if ! command -v codex >/dev/null 2>&1 && ! command -v code >/dev/null 2>&1; then
  echo "[codex] Neither 'codex' nor 'code' CLI found on PATH. Install Codex CLI before continuing." >&2
  exit 1
fi

if [[ ! -f "${TARGET}" ]]; then
  echo "[codex] ${TARGET} not found. Run scripts/codex/setup.sh first." >&2
  exit 1
fi

if grep -q "{{PROJECT_ROOT}}" "${TARGET}"; then
  echo "[codex] Placeholder {{PROJECT_ROOT}} still present in ${TARGET}. Re-run setup to replace it." >&2
  exit 1
fi

missing_output=$(TARGET="${TARGET}" python3 - <<'PY'
import os
import re
import sys

target = os.environ["TARGET"]
with open(target, "r", encoding="utf-8") as fh:
    data = fh.read()

paths = [match.strip('"') for match in re.findall(r'"([^"\n]+/scripts/mcp/[^"\n]+)"', data)]
missing = [path for path in paths if not os.path.exists(path)]

print("\n".join(missing))
PY
)

if [[ -n "${missing_output}" ]]; then
  echo "[codex] MCP proxy scripts missing:" >&2
  while IFS= read -r script_path; do
    [[ -z "${script_path}" ]] && continue
    printf "   - %s\n" "${script_path}" >&2
  done <<< "${missing_output}"
  exit 1
fi

echo "[codex] Configuration looks good. Launch with CODE_CONFIG_HOME=${LOCAL_HOME} codex --profile xtweak-mcp-verify-first \"PLAN\""
