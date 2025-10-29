# Agent Usage Guide (Updated October 29, 2025)

## Read This First
- Load the **Core Pattern Stack** before launching any agent: `placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`.
- Start ambiguous requests with `mcp-verify-first`; it produces a verified context packet for downstream agents.
- Each agent declares its patterns in front matter (`pattern-stack`). Reference those files for full instructions.
- For Elixir/Ash implementation rules, consult `docs/elixir_rules/` before generating code.

## Model Selection Strategy

**Purpose**: Optimize cost while maintaining quality by using appropriate model for each task type.

### Quick Decision Guide

**Use Haiku 4.5 agents (⚡ cost-optimized) for:**
- Structured context gathering with MCP tools
- Applying documented review feedback
- Straightforward markdown/changelog editing
- Schema-focused SQL migration generation
- Pattern compliance auditing
- Configuration-focused telemetry setup

**Use Sonnet 4.5 agents (🧠 quality-focused) for:**
- Architecture and design decisions
- Complex reasoning and analysis
- Research and planning
- Code review and security assessment
- Coordination between agents
- Ambiguous requirements

### Model Assignments by Agent

| Agent | Model | Cost Factor | Escalation Pattern |
| --- | --- | --- | --- |
| **Haiku Agents (6)** |
| `mcp-verify-first` | Haiku 4.5 | ~90% cheaper | MCP errors, incomplete context → Sonnet |
| `docs-maintainer` | Haiku 4.5 | ~90% cheaper | Complex formatting, merge conflicts → Sonnet |
| `code-review-implement` | Haiku 4.5 | ~90% cheaper | Compile/test failures, unclear feedback → Sonnet |
| `database-migration-specialist` | Haiku 4.5 | ~90% cheaper | Complex backfills, data safety issues → Sonnet |
| `pattern-librarian` | Haiku 4.5 | ~90% cheaper | Pattern interpretation ambiguity → Sonnet |
| `monitoring-setup` | Haiku 4.5 | ~90% cheaper | Complex observability design → Sonnet |
| **Sonnet Agents (18)** |
| All others | Sonnet 4.5 | Baseline | N/A (no escalation) |

**Expected Impact**:
- 26% of agent fleet on Haiku (targeting 40-50% of execution volume)
- 30-40% cost reduction with <10% escalation rate
- Automatic escalation on complexity via structured error messages

See `.claude/MODEL_SELECTION_STRATEGY.md` for full philosophy and `.claude/agent-workflows.md` for decision trees.

## Quick Selection Matrix

| Agent | Primary Use | Key Outputs | Core Follow-ups |
| --- | --- | --- | --- |
| `mcp-verify-first` | Gather ground truth before work begins | Detected app/domain map, evidence log, recommended next steps | Any implementation or review agent |
| `ash-resource-architect` | Design/extend Ash resources, actions, policies | Resource plan, generator usage, code snippets, migration/test checklist | `test-builder`, `code-reviewer` |
| `frontend-design-enforcer` | Coordinate LiveView UX, accessibility, and integration tasks | HEEx/JS updates, validation evidence, integration TODOs | `heex-template-expert`, `tailwind-strategist`, `test-builder` |
| `heex-template-expert` | Generate/refactor HEEx templates with modern directives | Production-grade components, accessibility-compliant markup, Ash form integration | `frontend-design-enforcer`, `test-builder`, `code-reviewer` |
| `cytoscape-expert` | Graph visualizations with Cytoscape.js + LiveView | Resource updates, JS hooks, performance guidance, UI validation artifacts | `test-builder`, `code-reviewer` |
| `nuxt-ui-expert` | Read-only Nuxt UI component API research | Component specs (props/slots/events), markdown + JSON output, accessibility docs | `frontend-design-enforcer`, `heex-template-expert` |
| `tailwind-strategist` | Tailwind strategy, utility audits, responsive plans | Usage audit, config recommendations, layout playbooks | `frontend-design-enforcer`, `heex-template-expert` |
| `docs-maintainer` | Sync developer docs & changelog with recent changes | Updated Markdown, changelog snippets, doc debt Todo list | Review/merge, `release-coordinator` |
| `release-coordinator` | Run release readiness checks and compile notes | Readiness dashboard, changelog draft, risk register | `docs-maintainer`, `dependency-auditor` |
| `dependency-auditor` | Audit deps for updates & security issues | Prioritized findings, upgrade plan, evidence bundle | `test-builder`, `release-coordinator` |
| `database-migration-specialist` | Plan/validate complex migrations/backfills | Migration files, rollback strategies, validation report | `test-builder`, `release-coordinator` |
| `performance-profiler` | Profile hotspots & recommend optimizations | Benchmark results, bottleneck analysis, optimization Todo list | Implementation agent of affected area |
| `beam-runtime-specialist` | Diagnose BEAM/OTP runtime issues | Tracing logs, supervision guidance, runtime tuning plan | Implementation agent, `performance-profiler` |
| `api-contract-guardian` | Guard API contracts and specs | Compatibility report, updated schemas/tests, deprecation notes | `docs-maintainer`, implementation owner |
| `ci-cd-optimizer` | Improve CI/CD pipelines & fix flaky workflows | Workflow diff suggestions, failure analysis, optimization checklist | Implementation owner, `release-coordinator` |
| `monitoring-setup` | Configure telemetry/logging/alerts | Config updates, dashboard/alert plan, runbooks | Ops follow-up, `release-coordinator` |
| `test-builder` | Author or repair ExUnit suites (Ash, LiveView, unit) | Test modules, command logs, coverage summary | `code-reviewer` (optional) |
| `code-reviewer` | Single-file audit with actionable report (no edits) | Scorecard, critical findings, recommendations, quick wins | `code-review-implement` |
| `code-review-implement` | Apply review feedback safely | Completed fixes, quality gate results, residual tasks | `code-reviewer` (re-run) |
| `security-reviewer` | High-confidence security assessment | Findings with repro steps, remediation plan, confidence scores | Implementation owners, `code-review-implement` |
| `pattern-librarian` | Audit pattern library & agent compliance | Updated pattern versions, compliance report, changelog entry | Agent owners, `docs-maintainer` |
| `agent-architect` | Design or refactor agent prompts/system messages | JSON agent spec, pattern stack references, follow-up tasks | Implement new agent, update docs |
| `tools-config-guardian` | Verify CLI configs, test MCP servers, check tool versions | Configuration health report, version comparison, breaking changes, recommendations | `docs-maintainer` (if updates needed) |

## Launch Protocol
1. **Clarify scope** – Confirm the request maps to exactly one agent. Split work if necessary.
2. **Phase Zero** – The first step is always to run `phase-zero-context` (auto-enforced by agents).
3. **Gather evidence** – Leverage MCP tools listed in each agent’s `pattern-stack`. No assumptions.
4. **Use TodoWrite** – Complex tasks should maintain a visible checklist for transparency.
5. **Run quality gates** – Before finishing, ensure relevant commands/tests succeeded.
6. **Handoff** – Apply `collaboration-handoff` pattern: summary, artifacts, outstanding work, validation, next actions.

## Pattern Shortcuts by Agent
- **Ash resource work**: `ash-resource-architect` + `ash-resource-template` pattern.
- **LiveView UI**: `frontend-design-enforcer` orchestrates builds; `heex-template-expert` generates/refactors templates with modern directives; pull component research from `nuxt-ui-expert` and utility/layout strategy from `tailwind-strategist`.
- **HEEx refactoring**: `heex-template-expert` converts legacy EEx (`<%= if %>`) to modern directives (`:if`), enforces accessibility.
- **Graph UI**: `cytoscape-expert` + `ash-resource-template` for nodes/edges.
- **Runtime debugging**: `beam-runtime-specialist` for OTP tracing and supervision advice.
- **Testing**: `test-builder` + `error-recovery-loop` for flaky tests.
- **Security sweeps**: `security-reviewer` (confidence-based findings only).
- **Template initialization**: Use `scripts/rename_project.exs` to rename the entire xTweak project (see `scripts/README.md`).
- **Framework rules**: Reference `docs/elixir_rules/ash.md` for core patterns, `docs/elixir_rules/ash_postgres.md` for data layer, `docs/elixir_rules/igniter.md` for generators.

## Usage Rules Integration

**Automatic Discovery via MCP:**
- Tool: `mcp__ash_ai__get_usage_rules`
- Returns: All usage rules from installed packages with file paths
- Agents should call this tool to discover available rules, then read relevant files

**Available Rules (17 files):**
- Core: ash, ash_postgres, ash_phoenix, ash_authentication, ash_json_api, ash_ai
- Tools: igniter, spark, reactor, usage_rules (general elixir/otp)
- Phoenix: main + 5 sub-rules (ecto, elixir, html, liveview, phoenix)

**When to use:**
- `ash-resource-architect`: Read ash.md, ash_postgres.md before designing resources
- `frontend-design-enforcer`: Read phoenix/liveview.md, ash_phoenix.md for LiveView work
- `code-reviewer`: Reference relevant rules for framework compliance checks
- Any agent working with Ash/Phoenix: Discover and read contextually relevant rules

**Human documentation:** `docs/elixir_rules/` contains curated copies for reference.

## Validation Expectations
- Every agent triggers `self-check-core` before responding—ensure it passes.
- Capture command output or screenshots for each significant claim.
- List unaddressed issues explicitly; silence implies completion.

## Maintenance & Verification

Run `tools-config-guardian` monthly or after tool updates to:
- Verify Claude Code + Codex CLI configurations are valid
- Test all MCP servers (TideWave, Ash AI, Playwright, Context7)
- Check for tool version updates and breaking changes
- Validate documentation accuracy and flow

## Need a New Agent?
Launch `agent-architect` with:
- Goal, constraints, and success criteria
- Required tools/permissions
- Related patterns or docs to reuse

It will produce a JSON spec referencing the same pattern stack structure so the team stays aligned.
