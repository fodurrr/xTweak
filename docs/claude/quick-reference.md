# Claude CLI Quick Reference

## One-Minute Checklist
- [ ] Launch `mcp-verify-first` to confirm project context.
- [ ] Load core patterns: placeholder-basics → phase-zero-context → mcp-tool-discipline → self-check-core → dual-example-bridge.
- [ ] Select the right agent from `.claude/AGENT_USAGE_GUIDE.md`.
- [ ] Track work with `TodoWrite`; keep tasks visible until done.
- [ ] Run quality gates (`mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, targeted `mix test`).
- [ ] Close with `collaboration-handoff`: summary, artifacts, outstanding items, validation, next steps.

## Agent Cheat Sheet
| Need | Agent |
| --- | --- |
| Verified ground truth | `mcp-verify-first` |
| Ash resource design | `ash-resource-architect` |
| LiveView integration | `frontend-design-enforcer` |
| DaisyUI component guidance | `daisyui-expert` |
| Tailwind strategy | `tailwind-strategist` |
| Cytoscape graph work | `cytoscape-expert` |
| Runtime/OTP troubleshooting | `beam-runtime-specialist` |
| Documentation & changelog updates | `docs-maintainer` |
| Release readiness | `release-coordinator` |
| Dependency audits | `dependency-auditor` |
| Complex migrations/backfills | `database-migration-specialist` |
| Performance investigations | `performance-profiler` |
| API contract review | `api-contract-guardian` |
| CI/CD tuning | `ci-cd-optimizer` |
| Observability setup | `monitoring-setup` |
| Test writing / TDD | `test-builder` |
| Code audit (no edits) | `code-reviewer` |
| Apply review fixes | `code-review-implement` |
| Security assessment | `security-reviewer` |
| Pattern compliance audit | `pattern-librarian` |
| Author new agents | `agent-architect` |

## MCP Command Highlights
- `mcp__tidewave__project_eval` – verify modules, run Ash queries, inspect configs.
- `mcp__ash_ai__list_ash_resources` / `list_generators` – discover resources and scaffolds.
- `mcp__context7__get-library-docs` – fetch DaisyUI, Cytoscape, or dependency docs quickly.
- `mcp__tidewave__get_logs level: "error"` – catch runtime issues after executing code.

## Quality Gates
```bash
mix format
mix credo --strict
mix compile --warnings-as-errors
mix test apps/xtweak_core/test/...
```

## Handoff Essentials
When you pause or finish, follow `collaboration-handoff`:
1. Summary of work and detected context.
2. Artifact list (files touched, scripts run, screenshots).
3. Outstanding issues or questions with owners.
4. Validation status (tests, lint, screenshots) and next steps.
