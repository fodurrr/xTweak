#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${TEMPLATE_DIR}/../.." && pwd)
OUTPUT_HOME=${LOCAL_CODE_HOME:-"${REPO_ROOT}/scripts/codex/local"}
TARGET_FILE="${OUTPUT_HOME}/config.xtweak.toml"
ROOT_CONFIG="${OUTPUT_HOME}/config.toml"

echo "➡️  Preparing repo-local Codex configuration"
mkdir -p "${OUTPUT_HOME}"

tmp_file=$(mktemp)
trap 'rm -f "${tmp_file}"' EXIT

sed "s#{{PROJECT_ROOT}}#${REPO_ROOT}#g" "${TEMPLATE_DIR}/config.xtweak.toml" > "${tmp_file}"

if [[ -f "${TARGET_FILE}" ]]; then
  echo "📄 Updating ${TARGET_FILE}"
else
  echo "🆕 Creating ${TARGET_FILE}"
fi
mv "${tmp_file}" "${TARGET_FILE}"

cat <<EOF > "${ROOT_CONFIG}"
include = ["${TARGET_FILE}"]
EOF

echo "✅ Repo-local Codex config ready at ${OUTPUT_HOME}"
echo "   Launch Codex via: CODE_CONFIG_HOME=${OUTPUT_HOME} codex --profile xtweak-mcp-verify-first \"PLAN\""
