# Codex Profiles · xTweak (Updated October 2, 2025)

## Plan
- Phase 0 – Baseline inventory; risk: miss hidden Claude prompts; success: spreadsheet mapping agents → patterns → MCP endpoints.
- Phase 1 – Profile scaffolding; risk: Codex TOML drift; success: `codex --list-profiles` shows `xtweak-review` with MCP handshake logs.
- Phase 2 – Parity build-out; risk: prompt regression; success: all 21 Claude mirrors emit PLAN → CONTEXT → DIFFS → CHECKS → SUMMARY transcripts.
- Phase 3 – Validation + rollout; risk: CI lacks MCP access; success: smoke CI job exits 0 with evidence bundle and AGENTS.md addendum shipped.

## Mapping Tables

### Claude Agent Mirrors
| Claude Agent | Codex Profile | Purpose Snapshot | MCP Servers |
| --- | --- | --- | --- |
| mcp-verify-first | xtweak-mcp-verify-first | Gather verified context packet before any work | tidewave, ash_ai, context7 |
| ash-resource-architect | xtweak-ash-resource-architect | Generator-first Ash resource design | tidewave, ash_ai, context7 |
| frontend-design-enforcer | xtweak-frontend-design-enforcer | LiveView UX orchestration with accessibility | tidewave, ash_ai, context7, playwright |
| cytoscape-expert | xtweak-cytoscape-expert | Cytoscape graph integration + validation | tidewave, ash_ai, context7, playwright |
| daisyui-expert | xtweak-daisyui-expert | DaisyUI component/theming research | tidewave, context7 |
| tailwind-strategist | xtweak-tailwind-strategist | Tailwind utility/layout strategy | tidewave, context7 |
| docs-maintainer | xtweak-docs-maintainer | Sync developer docs + changelog | tidewave, context7 |
| release-coordinator | xtweak-release-coordinator | Compile release readiness report | tidewave, context7 |
| dependency-auditor | xtweak-dependency-auditor | Audit deps for upgrades/security | tidewave, context7 |
| database-migration-specialist | xtweak-database-migration-specialist | Plan complex migrations/backfills | tidewave, ash_ai |
| performance-profiler | xtweak-performance-profiler | Profile hotspots + recommend optimizations | tidewave |
| beam-runtime-specialist | xtweak-beam-runtime-specialist | Diagnose BEAM runtime issues | tidewave |
| api-contract-guardian | xtweak-api-contract-guardian | Guard API contracts + compatibility | tidewave, context7 |
| ci-cd-optimizer | xtweak-ci-cd-optimizer | Improve CI/CD workflows | tidewave |
| monitoring-setup | xtweak-monitoring-setup | Configure telemetry/logging/alerts | tidewave, context7 |
| test-builder | xtweak-test-builder | Author/repair targeted test suites | tidewave, ash_ai |
| code-reviewer | xtweak-code-reviewer | Read-only review scorecard | tidewave, ash_ai, context7 |
| code-review-implement | xtweak-code-review-implement | Apply review feedback safely | tidewave, ash_ai, context7 |
| security-reviewer | xtweak-security-reviewer | Produce security findings with evidence | tidewave, context7 |
| pattern-librarian | xtweak-pattern-librarian | Audit pattern library & compliance | tidewave, context7 |
| agent-architect | xtweak-agent-architect | Design/refine agent specs & prompts | tidewave, context7 |

## MCP Integration Plan
- Reuse existing MCP launchers: `node scripts/mcp/tidewave-stdio-proxy.js`, `node scripts/mcp/ashai-stdio-proxy.js`, `npx -y @upstash/context7-mcp`, `npx @playwright/mcp`; export `*_BASE_URL` env vars once in shell rc.
- Plan step: `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first --call tidewave__project_eval '{"code":"Mix.Project.config"}'` to collect ground truth.
- Context step: `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-ash-resource-architect --call ash_ai__list_generators '{}'` before crafting Ash code; `context7__resolve-library-id "daisyui"` when UI involved.
- Checks step: Phoenix/UX runs must trigger `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-phoenix --call playwright__browser_navigate '{"url":"http://localhost:4000"}'` for screenshot evidence; migrations call Tidewave SQL helpers with the same `CODE_CONFIG_HOME` wrapper.
- Profiles declare explicit `mcp = [...]` lists to enforce MCP-first discipline; omit unused servers per role if necessary.

## Minimal TOML Excerpt
```toml
[providers.openai]
type = "openai"
model = "gpt-4.1"

[mcp_servers.tidewave]
command = "node"
args = ["{{PROJECT_ROOT}}/scripts/mcp/tidewave-stdio-proxy.js"]
env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp", TIDEWAVE_PROTOCOL_VERSION = "2025-03-26" }

[mcp_servers.ash_ai]
command = "node"
args = ["{{PROJECT_ROOT}}/scripts/mcp/ashai-stdio-proxy.js"]
env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp", ASHAI_PROTOCOL_VERSION = "2025-03-26" }

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp"]

[profiles.xtweak-review]
provider = "openai"
instructions = """
Role: xtweak-review scorecard profile.
Follow PLAN → CONTEXT → DIFFS → CHECKS → SUMMARY.
Load placeholder-basics, phase-zero-context, mcp-tool-discipline, self-check-core, dual-example-bridge.
Guardrails:
- Read-only; cite Tidewave/Ash evidence in CONTEXT.
- DIFFS highlights findings instead of patches.
- CHECKS captures validation commands.
- SUMMARY ends with recommendation + next steps.
"""
# See scripts/codex/config.xtweak.toml for full Claude mirror definitions.
```

### Template & Scripts
- Template file: `scripts/codex/config.xtweak.toml` (uses `{{PROJECT_ROOT}}` placeholder).
- Bootstrap: `scripts/codex/setup.sh` replaces the placeholder and writes repo-local config under `scripts/codex/local/` (no `~/.code` usage).
- Validation: `scripts/codex/validate.sh` checks for Codex CLI availability, substituted paths, and that referenced proxy scripts exist; run via `make codex-validate`.
- Convenience targets: `make codex-setup` (regenerate local config) and `make codex-validate` (rerun validation).

### MCP Server Snapshot
```text
$ codex mcp list
Name        Command  Args                                                             Env
ash_ai      node     {{PROJECT_ROOT}}/scripts/mcp/ashai-stdio-proxy.js                ASHAI_BASE_URL=http://127.0.0.1:4000/ash_ai/mcp, ASHAI_PROTOCOL_VERSION=2025-03-26
context7    npx      -y @upstash/context7-mcp                                         -
playwright  npx      @playwright/mcp                                                  -
tidewave    node     {{PROJECT_ROOT}}/scripts/mcp/tidewave-stdio-proxy.js             TIDEWAVE_BASE_URL=http://127.0.0.1:4000/tidewave/mcp, TIDEWAVE_PROTOCOL_VERSION=2025-03-26
```

## Example Workflows
- Interactive: `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first "PLAN – map project state"`
- Implementation: `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-ash-resource-architect "PLAN – extend Accounts resource"`
- Review: `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-code-reviewer "PLAN – audit PR 123"`

## Verification Checklist
- [ ] `scripts/codex/local/config.xtweak.toml` contains xtweak-mcp-verify-first … xtweak-agent-architect (21 profiles) matching the template.
- [ ] Each profile transcript shows PLAN → CONTEXT → DIFFS → CHECKS → SUMMARY ordering with MCP evidence.
- [ ] Tidewave + Ash AI calls succeed (`codex --profile xtweak-ash-resource-architect --call tidewave__project_eval ...`).
- [ ] Frontend runs emit Playwright screenshots via `xtweak-frontend-design-enforcer`; migrations emit rollback + `mix test` commands via `xtweak-database-migration-specialist`.
- [ ] CI smoke job emits JSON/markdown artifact and respects failure thresholds.
- [ ] AGENTS.md updated with Codex availability, scripts, and fallback instructions.
- [ ] `make codex-validate` completes without missing-script errors.

## Rollback / Exit Plan
- Remove `scripts/codex/local/` (or regenerate via `make codex-setup` when needed).
- Launch Codex without `CODE_CONFIG_HOME` to fall back to personal/global configuration.
- If MCP instability occurs, comment profile `mcp` arrays inside `scripts/codex/config.xtweak.toml` and rerun `make codex-setup`.
- Document rollback choice in team notes and restore previous config within minutes.
