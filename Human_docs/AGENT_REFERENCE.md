# Agent Reference Guide - FOR PETER (HUMAN USER)

> **AUDIENCE**: This document is for **Peter (the human user)**, NOT for the coordinator or subagents.
>
> **Three-Layer Architecture**:
> 1. **Peter (User)** - You, the human. This doc is for you.
> 2. **Base Claude (Coordinator)** - Reads `CLAUDE.md` for routing protocol
> 3. **Subagents** - Read their frontmatter (`model:`, `pattern-stack:`, `required-usage-rules:`)
>
> **When to use this doc**: Reference agent capabilities, understand model selection strategy, or review common workflow patterns.

---

## Quick Reference: Agent Matrix

| Agent | Model | Primary Use | Key Outputs |
| --- | --- | --- | --- |
| `mcp-verify-first` | ⚡ Haiku | Gather ground truth before work begins | Context packet, evidence log, next steps |
| `ash-resource-architect` | 🧠 Sonnet | Design/extend Ash resources, actions, policies | Resource plan, generator usage, migration/test checklist |
| `frontend-design-enforcer` | 🧠 Sonnet | Coordinate LiveView UX, accessibility, integration | HEEx/JS updates, validation evidence, integration TODOs |
| `heex-template-expert` | 🧠 Sonnet | Generate/refactor HEEx templates with modern directives | Production-grade components, accessibility-compliant markup |
| `cytoscape-expert` | 🧠 Sonnet | Graph visualizations with Cytoscape.js + LiveView | Resource updates, JS hooks, performance guidance |
| `nuxt-ui-expert` | 🧠 Sonnet | Read-only Nuxt UI component API research | Component specs (props/slots/events), markdown + JSON output |
| `tailwind-strategist` | 🧠 Sonnet | Tailwind strategy, utility audits, responsive plans | Usage audit, config recommendations, layout playbooks |
| `theme-compliance-guard` | 🧠 Sonnet | Audit UI components for theme compliance | Violation report, theme usage audit, remediation guidance |
| `docs-maintainer` | ⚡ Haiku | Sync developer docs & changelog with changes | Updated Markdown, changelog snippets, doc debt Todo list |
| `release-coordinator` | 🧠 Sonnet | Run release readiness checks and compile notes | Readiness dashboard, changelog draft, risk register |
| `dependency-auditor` | 🧠 Sonnet | Audit deps for updates & security issues | Prioritized findings, upgrade plan, evidence bundle |
| `database-migration-specialist` | ⚡ Haiku | Plan/validate complex migrations/backfills | Migration files, rollback strategies, validation report |
| `performance-profiler` | 🧠 Sonnet | Profile hotspots & recommend optimizations | Benchmark results, bottleneck analysis, optimization Todo list |
| `beam-runtime-specialist` | 🧠 Sonnet | Diagnose BEAM/OTP runtime issues | Tracing logs, supervision guidance, runtime tuning plan |
| `api-contract-guardian` | 🧠 Sonnet | Guard API contracts and specs | Compatibility report, updated schemas/tests, deprecation notes |
| `ci-cd-optimizer` | 🧠 Sonnet | Improve CI/CD pipelines & fix flaky workflows | Workflow diff suggestions, failure analysis, optimization checklist |
| `monitoring-setup` | ⚡ Haiku | Configure telemetry/logging/alerts | Config updates, dashboard/alert plan, runbooks |
| `test-builder` | 🧠 Sonnet | Author or repair ExUnit suites | Test modules, command logs, coverage summary |
| `code-reviewer` | 🧠 Sonnet | Single-file audit with actionable report (no edits) | Scorecard, critical findings, recommendations, quick wins |
| `code-review-implement` | ⚡ Haiku | Apply review feedback safely | Completed fixes, quality gate results, residual tasks |
| `security-reviewer` | 🧠 Sonnet | High-confidence security assessment | Findings with repro steps, remediation plan, confidence scores |
| `pattern-librarian` | ⚡ Haiku | Audit pattern library & agent compliance | Updated pattern versions, compliance report, changelog entry |
| `agent-architect` | 🧠 Sonnet | Design or refactor agent prompts/system messages | JSON agent spec, pattern stack references, follow-up tasks |
| `tools-config-guardian` | 🧠 Sonnet | Verify CLI configs, test MCP servers, check versions | Configuration health report, version comparison, breaking changes |
| `workflow-expert` | 🧠 Sonnet | Audit, validate, propose workflow improvements | Audit reports, validation reports, structured proposals |

---

## Model Selection Philosophy

xTweak uses a **cost-optimized model selection strategy**:

### ⚡ Haiku 4.5 (Cost-Optimized)
**Use for**: Bounded implementation tasks with clear patterns
- ~90% cheaper than Sonnet
- Fast for structured, well-defined work
- Auto-escalates to Sonnet when needed

**6 Haiku Agents**:
- `mcp-verify-first` - Context gathering with MCP tools
- `docs-maintainer` - Markdown/changelog editing
- `code-review-implement` - Applying documented review feedback
- `database-migration-specialist` - Schema-focused SQL migration generation
- `pattern-librarian` - Pattern compliance auditing
- `monitoring-setup` - Configuration-focused telemetry setup

### 🧠 Sonnet 4.5 (Quality-Focused)
**Use for**: Analysis, judgment, coordination, complex reasoning
- Baseline quality model
- All complex decision-making
- 18 Sonnet agents (all others)

### Escalation Strategy
**When Haiku escalates** (look for `⚠️ HAIKU ESCALATION RECOMMENDED`):
- Compile errors
- Test failures
- MCP tool failures
- Pattern violations
- Uncertain outcomes

**Target escalation rate**: <10% (1 in 10 Haiku executions requires Sonnet retry)

---

## Common Multi-Agent Workflows

### Code Quality Pipeline
**Sequence**: `mcp-verify-first` → `code-reviewer` → `code-review-implement` → `code-reviewer`

**Use when**: You want to audit and improve code quality
- Separates diagnosis from execution
- Captures score deltas between reviews
- Logs commands and remaining todos

### Frontend Delivery
**Sequence**: `mcp-verify-first` → (optional `ash-resource-architect`) → `nuxt-ui-expert` (research) → `frontend-design-enforcer` → `heex-template-expert` / `tailwind-strategist` → `test-builder`

**Use when**: Building UI features
- Research phase: Component specs
- Coordination phase: Integration strategy
- Implementation phase: Code generation
- Use Playwright for screenshots/accessibility

### Backend Resource Development
**Sequence**: `mcp-verify-first` → `ash-resource-architect` → `test-builder` → `code-reviewer`

**Use when**: Creating or modifying Ash resources
- Always generate migrations + tests before handoff
- Document policies, calculations, pending follow-ups

### Bug Fix / Incident Response
**Sequence**: `mcp-verify-first` → `test-builder` (reproduce + tests) → Domain agent → `code-reviewer` → `security-reviewer` (if exploit)

**Use when**: Something's broken
- Reproduce first with tests
- Document root cause + remediation steps
- Use error-recovery-loop pattern

### Release Readiness
**Sequence**: `mcp-verify-first` → `dependency-auditor` → `test-builder` → `release-coordinator` → `docs-maintainer`

**Use when**: Preparing for release
- Dependency checks run first
- Release coordinator blocks completion without proof
- Documentation finalized last

### Security Sweep
**Sequence**: `mcp-verify-first` → `security-reviewer` → Owners (`code-review-implement`) → `security-reviewer` (verification)

**Use when**: Auditing for vulnerabilities
- Only findings with confidence ≥8/10
- Track mitigation status via TodoWrite

---

## Slash Commands Quick Reference

### PRD-Centric Commands (Feature Development)
- `/prd-plan-sprint` - Plan next sprint from PRD roadmap
- `/prd-implement` - Execute current sprint tasks
- `/prd-status` - Dashboard of progress
- `/prd-continue` - Resume where you left off
- `/prd-update [section]` - Update specific PRD chapter

### Non-PRD Commands (Maintenance & Quality)
- `/fix-bug "description"` - Emergency bug fixes, hotfixes
- `/refactor [operation] [target]` - Code quality improvements
- `/upgrade-deps [package]` - Dependency upgrades
- `/update-docs [type]` - Non-PRD documentation
- `/setup-tool [type] [name]` - Infrastructure & tooling
- `/workflow [action] [target]` - Workflow infrastructure management

**Key Principle**: PRD commands track long-term project goals. Non-PRD commands handle reactive work, maintenance, and infrastructure.

---

## When to Launch Agents Directly vs. Slash Commands

| Your Request | Best Approach | Why |
|--------------|---------------|-----|
| "Fix the login bug" | `/fix-bug "login bug"` | Structured workflow with test-first approach |
| "Add email field to User" | Direct: `ash-resource-architect` | Simple, single-agent task |
| "Refactor Badge component" | `/refactor extract Badge` | Ensures review → implement → test sequence |
| "Continue working on sprint" | `/prd-continue` | Checks PRD status, resumes tasks |
| "Review this file" | Direct: `code-reviewer` | Single-agent, single-file audit |
| "Upgrade Ash to 3.8" | `/upgrade-deps ash` | Complex workflow with safety checks |

---

## How Information Flows (Three-Layer Architecture)

```
Peter (You)
    ↓ [Give prompt]
Base Claude (Coordinator)
    ↓ [Read CLAUDE.md]
    ↓ [Classify request type]
    ↓ [Select agent from matrix above]
    ↓ [Launch via Task tool with context]
Subagent (e.g., ash-resource-architect)
    ↓ [Read own frontmatter: model, pattern-stack, required-usage-rules]
    ↓ [Receive context from coordinator]
    ↓ [Execute task]
    ↓ [Return results via collaboration-handoff]
Base Claude (Coordinator)
    ↓ [Synthesize results]
    ↓ [Present to Peter]
Peter (You)
    ↓ [Review results, provide feedback]
```

**Key Points**:
- **Peter (you)**: Only interact with the coordinator
- **Coordinator**: Routes everything, doesn't implement
- **Subagents**: Self-contained, receive context from coordinator
- **No circular references**: Each layer knows only what it needs

---

## Quality Gates (Always Run These)

```bash
mix format                           # Format code
mix credo --strict                   # Linting
mix compile --warnings-as-errors     # Compilation
mix test apps/xtweak_core/test/...   # Targeted tests
```

All agents should run these before completing work.

---

## Need More Details?

- **Coordinator routing logic**: See `CLAUDE.md` (Step 0-5: prompt analysis, agent selection, context handoff)
- **Agent-specific details**: Browse `.claude/agents/` directory, read agent frontmatter
- **Pattern library**: See `.claude/patterns/` for reusable patterns (placeholder-basics, phase-zero-context, etc.)
- **Slash command implementations**: See `.claude/commands/` for detailed workflows
- **Project roadmap**: See `AI_docs/prd/` for feature plans and sprint tasks

---

**Last Updated**: 2025-11-01 (Layered architecture clarification)
