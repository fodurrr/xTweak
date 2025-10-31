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
| tailwind-component-expert | xtweak-tailwind-component-expert | Tailwind utility-first component design & theming research | tidewave, context7 |
| nuxt-ui-expert | xtweak-nuxt-ui-expert | Read-only Nuxt UI component API research (props/slots/events) | nuxt-ui-remote, context7 |
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

## MCP Integration (Native HTTP Support)
- **Codex CLI 0.50+** supports native HTTP MCP servers - no proxy scripts needed!
- **TideWave** and **AshAI** use direct HTTP URLs: `http://127.0.0.1:4000/tidewave/mcp` and `http://127.0.0.1:4000/ash_ai/mcp`
- **Context7** and **Playwright** remain stdio-based via npx: `npx -y @upstash/context7-mcp`, `npx @playwright/mcp`
- **Enable native support**: Set `experimental_use_rmcp_client = true` in config
- **Usage**: All Codex profiles automatically access configured MCP servers via `mcp = [...]` declarations
- Profiles declare explicit `mcp = [...]` lists to enforce MCP-first discipline; omit unused servers per role if necessary.

## Minimal TOML Excerpt (Native HTTP)
```toml
# Enable native HTTP MCP support (Codex CLI 0.50+)
experimental_use_rmcp_client = true

[providers.openai]
type = "openai"
model = "gpt-5-codex-medium"

# Native HTTP MCP servers (no proxy scripts needed!)
[mcp_servers.tidewave]
url = "http://127.0.0.1:4000/tidewave/mcp"

[mcp_servers.ash_ai]
url = "http://127.0.0.1:4000/ash_ai/mcp"

# STDIO MCP servers (via npx)
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
mcp = ["tidewave", "ash_ai", "context7"]
# See .codex/config.toml for full Claude mirror definitions.
```

### Project-Local Configuration
- Configuration file: `.codex/config.toml` (project-local, checked into version control).
- No setup script needed - just `cd` to project root and run `codex` commands.
- Validation: `scripts/codex/validate.sh` checks for Codex CLI availability and verifies `.codex/config.toml` exists; run via `make codex-validate`.
- Convenience target: `make codex-validate` (verify configuration).

### MCP Server Snapshot (Native HTTP)
```text
$ codex mcp list
Name        Command  Args                      Env  Cwd  Status   Auth
context7    npx      -y @upstash/context7-mcp  -    -    enabled  Unsupported
playwright  npx      @playwright/mcp           -    -    enabled  Unsupported

Name      Url                                 Bearer Token Env Var  Status   Auth
ash_ai    http://127.0.0.1:4000/ash_ai/mcp    -                     enabled  Unsupported
tidewave  http://127.0.0.1:4000/tidewave/mcp  -                     enabled  Unsupported
```

Note: TideWave and AshAI now show as HTTP URL-based servers (transport: `streamable_http`), while Context7 and Playwright remain stdio-based.

## Example Workflows
All commands run from the project root (`/path/to/xTweak`). Codex automatically reads `.codex/config.toml`.

- Interactive: `codex --profile xtweak-mcp-verify-first "PLAN – map project state"`
- Implementation: `codex --profile xtweak-ash-resource-architect "PLAN – extend Accounts resource"`
- Review: `codex --profile xtweak-code-reviewer "PLAN – audit PR 123"`

## Verification Checklist
- [ ] `.codex/config.toml` contains xtweak-mcp-verify-first … xtweak-agent-architect (21 profiles).
- [ ] Each profile transcript shows PLAN → CONTEXT → DIFFS → CHECKS → SUMMARY ordering with MCP evidence.
- [ ] Tidewave + Ash AI calls succeed (`codex --profile xtweak-ash-resource-architect --call tidewave__project_eval ...`).
- [ ] Frontend runs emit Playwright screenshots via `xtweak-frontend-design-enforcer`; migrations emit rollback + `mix test` commands via `xtweak-database-migration-specialist`.
- [ ] CI smoke job emits JSON/markdown artifact and respects failure thresholds.
- [ ] AGENTS.md updated with Codex availability and workflow instructions.
- [ ] `make codex-validate` completes successfully.

## Rollback / Exit Plan
- Revert `.codex/config.toml` to a previous version from git history if needed.
- Codex will use global `~/.codex/config.toml` if project-local config is removed.
- If MCP instability occurs, comment out problematic profile `mcp` arrays inside `.codex/config.toml`.
- Document rollback choice in team notes and restore previous config within minutes.
