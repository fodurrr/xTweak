# Claude CLI Quick Reference

## One-Minute Checklist
- [ ] **Model**: Choose Haiku (⚡ cost) or Sonnet (🧠 quality) based on task complexity.
- [ ] Launch `mcp-verify-first` to confirm project context.
- [ ] Load core patterns: placeholder-basics → phase-zero-context → mcp-tool-discipline → self-check-core → dual-example-bridge.
- [ ] Select the right agent from `.claude/AGENT_USAGE_GUIDE.md`.
- [ ] Track work with `TodoWrite`; keep tasks visible until done.
- [ ] Run quality gates (`mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, targeted `mix test`).
- [ ] Close with `collaboration-handoff`: summary, artifacts, outstanding items, validation, next steps.

## Model Selection (Haiku vs Sonnet)

**⚡ Use Haiku 4.5 for:**
- Context gathering (`mcp-verify-first`)
- Applying review feedback (`code-review-implement`)
- Markdown editing (`docs-maintainer`)
- SQL migrations (`database-migration-specialist`)
- Pattern audits (`pattern-librarian`)
- Config setup (`monitoring-setup`)

**🧠 Use Sonnet 4.5 for:**
- Architecture & design (all `*-architect`, `*-enforcer` agents)
- Analysis & review (`code-reviewer`, `security-reviewer`)
- Research & planning (`*-expert` agents)
- Complex reasoning (ambiguous requirements)
- Coordination (`release-coordinator`)

**🔄 When Haiku Escalates:**
Look for `⚠️ HAIKU ESCALATION RECOMMENDED` messages with structured context. Re-run same agent with Sonnet model.

## Agent Cheat Sheet
| Need | Agent | Model |
| --- | --- | --- |
| Verified ground truth | `mcp-verify-first` | ⚡ Haiku |
| Ash resource design | `ash-resource-architect` | 🧠 Sonnet |
| LiveView integration | `frontend-design-enforcer` | 🧠 Sonnet |
| DaisyUI component research | `daisyui-expert` | 🧠 Sonnet |
| Nuxt UI component research | `nuxt-ui-expert` | 🧠 Sonnet |
| Tailwind component design | `tailwind-component-expert` | 🧠 Sonnet |
| Tailwind strategy | `tailwind-strategist` | 🧠 Sonnet |
| Cytoscape graph work | `cytoscape-expert` | 🧠 Sonnet |
| Runtime/OTP troubleshooting | `beam-runtime-specialist` | 🧠 Sonnet |
| Documentation & changelog updates | `docs-maintainer` | ⚡ Haiku |
| Release readiness | `release-coordinator` | 🧠 Sonnet |
| Dependency audits | `dependency-auditor` | 🧠 Sonnet |
| Complex migrations/backfills | `database-migration-specialist` | ⚡ Haiku |
| Performance investigations | `performance-profiler` | 🧠 Sonnet |
| API contract review | `api-contract-guardian` | 🧠 Sonnet |
| CI/CD tuning | `ci-cd-optimizer` | 🧠 Sonnet |
| Observability setup | `monitoring-setup` | ⚡ Haiku |
| Test writing / TDD | `test-builder` | 🧠 Sonnet |
| Code audit (no edits) | `code-reviewer` | 🧠 Sonnet |
| Apply review fixes | `code-review-implement` | ⚡ Haiku |
| Security assessment | `security-reviewer` | 🧠 Sonnet |
| Pattern compliance audit | `pattern-librarian` | ⚡ Haiku |
| Author new agents | `agent-architect` | 🧠 Sonnet |

## MCP Command Highlights
- `mcp__tidewave__project_eval` – verify modules, run Ash queries, inspect configs.
- `mcp__ash_ai__list_ash_resources` / `list_generators` – discover resources and scaffolds.
- `mcp__context7__get-library-docs` – fetch Nuxt UI, Cytoscape, or dependency docs quickly.
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
