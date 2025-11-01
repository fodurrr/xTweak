# Claude Code Consolidated Reference

> **Purpose**: Single reference for all agents. Contains agent matrix, workflows, model selection, pattern guide, and quick checklist.

---

## Table of Contents
1. [Quick Start Checklist](#quick-start-checklist)
2. [Slash Commands Overview](#slash-commands-overview)
3. [Model Selection Strategy](#model-selection-strategy)
4. [Agent Matrix](#agent-matrix)
5. [Multi-Agent Workflows](#multi-agent-workflows)
6. [Pattern Library Guide](#pattern-library-guide)
7. [Usage Rules Integration](#usage-rules-integration)
8. [Launch Protocol](#launch-protocol)
9. [Validation Expectations](#validation-expectations)

---

## Quick Start Checklist

### One-Minute Checklist for Every Task
- [ ] **Model**: Choose Haiku (⚡ cost) or Sonnet (🧠 quality) based on task complexity
- [ ] **NEW**: If Peter gives direct prompt (no slash command), run mandatory Prompt Analysis & Agent Routing protocol from CLAUDE.md
- [ ] Launch `mcp-verify-first` to confirm project context (OR it runs automatically in routing protocol)
- [ ] Load core patterns: placeholder-basics → phase-zero-context → mcp-tool-discipline → self-check-core → dual-example-bridge
- [ ] **NEW**: Load architecture rules from `/usage-rules/` based on task type
- [ ] Select the right agent from Agent Matrix below (OR coordinator selects via classification table)
- [ ] Track work with `TodoWrite`; keep tasks visible until done
- [ ] Run quality gates (`mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, targeted `mix test`)
- [ ] Close with `collaboration-handoff`: summary, artifacts, outstanding items, validation, next steps

### 🆕 Coordination Layer (2025-11-01)

**Base Claude is ALWAYS the coordinator** for non-slash-command prompts. See CLAUDE.md "Prompt Analysis & Agent Routing" section for full protocol.

**Key changes**:
- **Clarification-first**: Claude checks prompt clarity before launching any agent
- **Architecture rules loading**: Mandatory loading from `/usage-rules/` based on task type
- **Explicit agent selection**: Classification table maps request type → lead agent
- **Context handoff**: Full context passed to agents (detected apps/domain + loaded rules)

### MCP Command Highlights
- `mcp__tidewave__project_eval` – Verify modules, run Ash queries, inspect configs
- `mcp__ash_ai__list_ash_resources` / `list_generators` – Discover resources and scaffolds
- `mcp__nuxt-ui-remote__list_components` / `get_component` – Research UI component APIs and design specs
- `mcp__context7__get-library-docs` – Fetch docs for non-Elixir libraries (fallback when specific MCP unavailable)
- `mcp__tidewave__get_logs level: "error"` – Catch runtime issues after executing code

### Quality Gates
```bash
mix format
mix credo --strict
mix compile --warnings-as-errors
mix test apps/xtweak_core/test/...
```

---

## Slash Commands Overview

xTweak uses 11 slash commands split into two categories: **PRD-centric** (feature development) and **Non-PRD** (maintenance & quality).

### PRD-Centric Commands (Feature Development)

| Command | Purpose | Primary Agent | When to Use |
|---------|---------|---------------|-------------|
| `/prd-plan-sprint` | Plan next sprint from PRD roadmap | docs-maintainer (Haiku) | Ready to start new sprint |
| `/prd-implement` | Execute current sprint tasks | Various (task-dependent) | Sprint plan ready, start building |
| `/prd-status` | Dashboard of progress | mcp-verify-first (Haiku) | Check what's done/next |
| `/prd-continue` | Resume where you left off | mcp-verify-first (Haiku) | Starting new session |
| `/prd-update [section]` | Update specific PRD chapter | docs-maintainer (Haiku) | Architecture/requirements evolved |

### Non-PRD Commands (Maintenance & Quality)

| Command | Purpose | Primary Agents | When to Use |
|---------|---------|----------------|-------------|
| `/fix-bug "description"` | Emergency bug fixes, hotfixes | test-builder (Sonnet) → domain specialist → code-reviewer (Sonnet) | Production broken, critical issue |
| `/refactor [operation] [target]` | Code quality improvements | code-reviewer (Sonnet) → domain specialist → test-builder (Sonnet) | Technical debt, code smells |
| `/upgrade-deps [package]` | Dependency upgrades | dependency-auditor (Sonnet) → domain specialists → docs-maintainer (Haiku) | Security patches, framework upgrades |
| `/update-docs [type]` | Non-PRD documentation | docs-maintainer (Haiku) | README, migration guides, framework rules |
| `/setup-tool [type] [name]` | Infrastructure & tooling | tools-config-guardian (Haiku) → ci-cd-optimizer (Sonnet) | MCP servers, CI checks, dev tools |
| `/workflow [action] [target]` | Workflow infrastructure management | workflow-expert (Sonnet) | Audit/validate/propose changes to agents, patterns, commands |

### Command Selection Decision Tree

```
Is this a new feature or enhancement?
├─ Yes → Use PRD commands
│   ├─ Starting new work? → /prd-plan-sprint
│   ├─ Continuing work? → /prd-continue or /prd-implement
│   ├─ Check progress? → /prd-status
│   └─ Update PRD docs? → /prd-update
│
└─ No → Use Non-PRD commands
    ├─ Something broken? → /fix-bug
    ├─ Code quality issue? → /refactor
    ├─ Package update needed? → /upgrade-deps
    ├─ Docs outdated? → /update-docs
    ├─ Need new tool? → /setup-tool
    └─ Workflow/agent/pattern issue? → /workflow
```

**Key Principle**: PRD commands track long-term project goals. Non-PRD commands handle reactive work, maintenance, and infrastructure.

---

## Model Selection Strategy

### Philosophy
xTweak uses a **cost-optimized model selection strategy** that balances quality, speed, and API costs:
- **Haiku 4.5** for bounded implementation tasks with clear patterns
- **Sonnet 4.5** for analysis, judgment, coordination, and complex reasoning
- **Manual escalation** when Haiku encounters complexity beyond its capabilities

**Expected Impact**: 30-40% cost reduction with <10% escalation rate

### Quick Decision Guide

**⚡ Use Haiku 4.5 agents (cost-optimized) for:**
- Structured context gathering with MCP tools
- Applying documented review feedback
- Straightforward markdown/changelog editing
- Schema-focused SQL migration generation
- Pattern compliance auditing
- Configuration-focused telemetry setup

**🧠 Use Sonnet 4.5 agents (quality-focused) for:**
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

### When to Use Haiku vs Sonnet

**Use Haiku When:**
- ✅ Task has clear, documented patterns to follow
- ✅ Input is structured (e.g., review report, MCP response)
- ✅ Output is well-defined (e.g., context packet, changelog)
- ✅ Task is high-frequency (cost savings add up)
- ✅ Failure is easily detectable (compile errors, test failures)

**Use Sonnet When:**
- ✅ Task requires judgment calls or interpretation
- ✅ Multiple approaches are valid, need to choose best
- ✅ Analysis or reasoning is the primary deliverable
- ✅ Coordination across multiple concerns
- ✅ High-stakes work (security, architecture, production)
- ✅ Unsure which model to use (Sonnet is safer default)

### Escalation Strategy

**When Haiku Escalates:**
Look for `⚠️ HAIKU ESCALATION RECOMMENDED` messages with structured context containing:
- **Error Type**: Specific category (compile, test, MCP, pattern, uncertainty)
- **Details**: What went wrong
- **What I Attempted**: What was tried
- **Why Escalation Needed**: Why Sonnet is required
- **Suggested Action**: Re-run command with Sonnet model
- **Context for Sonnet**: Specific context to preserve

**Escalation Triggers:**
1. **Compile Errors** - Type mismatches, missing imports, syntax errors
2. **Test Failures** - Implementation fails existing tests or new tests don't pass
3. **MCP Tool Failures** - Server errors, incomplete data, timeouts
4. **Pattern Violations** - Output doesn't follow required patterns
5. **Uncertain Outcomes** - Multiple valid approaches, unclear which to choose

**Target Escalation Rate**: <10% (1 in 10 Haiku executions requires Sonnet retry)

---

## Agent Matrix

### Read This First
- Load the **Core Pattern Stack** before launching any agent: `placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`
- Start ambiguous requests with `mcp-verify-first`; it produces a verified context packet for downstream agents
- Each agent declares its patterns in front matter (`pattern-stack`). Reference those files for full instructions
- For Elixir/Ash implementation rules, consult usage rules (see Usage Rules Integration section)

### Quick Selection Matrix

| Agent | Model | Primary Use | Key Outputs | Core Follow-ups |
| --- | --- | --- | --- | --- |
| `mcp-verify-first` | ⚡ Haiku | Gather ground truth before work begins | Detected app/domain map, evidence log, recommended next steps | Any implementation or review agent |
| `ash-resource-architect` | 🧠 Sonnet | Design/extend Ash resources, actions, policies | Resource plan, generator usage, code snippets, migration/test checklist | `test-builder`, `code-reviewer` |
| `frontend-design-enforcer` | 🧠 Sonnet | Coordinate LiveView UX, accessibility, and integration tasks | HEEx/JS updates, validation evidence, integration TODOs | `heex-template-expert`, `tailwind-strategist`, `test-builder` |
| `heex-template-expert` | 🧠 Sonnet | Generate/refactor HEEx templates with modern directives | Production-grade components, accessibility-compliant markup, Ash form integration | `frontend-design-enforcer`, `test-builder`, `code-reviewer` |
| `cytoscape-expert` | 🧠 Sonnet | Graph visualizations with Cytoscape.js + LiveView | Resource updates, JS hooks, performance guidance, UI validation artifacts | `test-builder`, `code-reviewer` |
| `nuxt-ui-expert` | 🧠 Sonnet | Read-only Nuxt UI component API research | Component specs (props/slots/events), markdown + JSON output, accessibility docs | `frontend-design-enforcer`, `heex-template-expert` |
| `tailwind-strategist` | 🧠 Sonnet | Tailwind strategy, utility audits, responsive plans | Usage audit, config recommendations, layout playbooks | `frontend-design-enforcer`, `heex-template-expert` |
| `theme-compliance-guard` | 🧠 Sonnet | Audit UI components for theme architecture compliance and detect hardcoded colors | Violation report, theme usage audit, remediation guidance | `frontend-design-enforcer`, `heex-template-expert` |
| `docs-maintainer` | ⚡ Haiku | Sync developer docs & changelog with recent changes | Updated Markdown, changelog snippets, doc debt Todo list | Review/merge, `release-coordinator` |
| `release-coordinator` | 🧠 Sonnet | Run release readiness checks and compile notes | Readiness dashboard, changelog draft, risk register | `docs-maintainer`, `dependency-auditor` |
| `dependency-auditor` | 🧠 Sonnet | Audit deps for updates & security issues | Prioritized findings, upgrade plan, evidence bundle | `test-builder`, `release-coordinator` |
| `database-migration-specialist` | ⚡ Haiku | Plan/validate complex migrations/backfills | Migration files, rollback strategies, validation report | `test-builder`, `release-coordinator` |
| `performance-profiler` | 🧠 Sonnet | Profile hotspots & recommend optimizations | Benchmark results, bottleneck analysis, optimization Todo list | Implementation agent of affected area |
| `beam-runtime-specialist` | 🧠 Sonnet | Diagnose BEAM/OTP runtime issues | Tracing logs, supervision guidance, runtime tuning plan | Implementation agent, `performance-profiler` |
| `api-contract-guardian` | 🧠 Sonnet | Guard API contracts and specs | Compatibility report, updated schemas/tests, deprecation notes | `docs-maintainer`, implementation owner |
| `ci-cd-optimizer` | 🧠 Sonnet | Improve CI/CD pipelines & fix flaky workflows | Workflow diff suggestions, failure analysis, optimization checklist | Implementation owner, `release-coordinator` |
| `monitoring-setup` | ⚡ Haiku | Configure telemetry/logging/alerts | Config updates, dashboard/alert plan, runbooks | Ops follow-up, `release-coordinator` |
| `test-builder` | 🧠 Sonnet | Author or repair ExUnit suites (Ash, LiveView, unit) | Test modules, command logs, coverage summary | `code-reviewer` (optional) |
| `code-reviewer` | 🧠 Sonnet | Single-file audit with actionable report (no edits) | Scorecard, critical findings, recommendations, quick wins | `code-review-implement` |
| `code-review-implement` | ⚡ Haiku | Apply review feedback safely | Completed fixes, quality gate results, residual tasks | `code-reviewer` (re-run) |
| `security-reviewer` | 🧠 Sonnet | High-confidence security assessment | Findings with repro steps, remediation plan, confidence scores | Implementation owners, `code-review-implement` |
| `pattern-librarian` | ⚡ Haiku | Audit pattern library & agent compliance | Updated pattern versions, compliance report, changelog entry | Agent owners, `docs-maintainer` |
| `agent-architect` | 🧠 Sonnet | Design or refactor agent prompts/system messages | JSON agent spec, pattern stack references, follow-up tasks | Implement new agent, update docs |
| `tools-config-guardian` | 🧠 Sonnet | Verify CLI configs, test MCP servers, check tool versions | Configuration health report, version comparison, breaking changes, recommendations | `docs-maintainer` (if updates needed) |
| `workflow-expert` | 🧠 Sonnet | Meta-workflow specialist: audit, validate, propose improvements to workflow infrastructure (agents, patterns, commands). Proposal-only mode | Audit reports, validation reports, structured proposals (with diffs, rationale, risk assessment) | Approval required before changes |

### Pattern Shortcuts by Agent
- **Ash resource work**: `ash-resource-architect` + `ash-resource-template` pattern
- **LiveView UI**: `frontend-design-enforcer` orchestrates builds; `heex-template-expert` generates/refactors templates with modern directives; pull component research from `nuxt-ui-expert` and utility/layout strategy from `tailwind-strategist`
- **HEEx refactoring**: `heex-template-expert` converts legacy EEx (`<%= if %>`) to modern directives (`:if`), enforces accessibility
- **Graph UI**: `cytoscape-expert` + `ash-resource-template` for nodes/edges
- **Runtime debugging**: `beam-runtime-specialist` for OTP tracing and supervision advice
- **Testing**: `test-builder` + `error-recovery-loop` for flaky tests
- **Security sweeps**: `security-reviewer` (confidence-based findings only)
- **Framework rules**: Reference `/usage-rules/` for all framework and xTweak-specific patterns
- **Workflow management**: `workflow-expert` with `documentation-organization` + `collaboration-handoff` for structured proposals

---

## Multi-Agent Workflows

Each flow assumes the **Core Pattern Stack** is loaded and `mcp-verify-first` has supplied verified context.

### Code Quality Pipeline
**Sequence**: `mcp-verify-first` → `code-reviewer` → `code-review-implement` → `code-reviewer`

**Why**: Separates diagnosis from execution, ensuring clean reports before and after fixes.

**Notes**:
- Capture score deltas between reviews
- `code-review-implement` must log commands and remaining todos via `collaboration-handoff`

### Frontend Delivery
**Sequence**: `mcp-verify-first` → (optional `ash-resource-architect`) → `nuxt-ui-expert` (component research) → `frontend-design-enforcer` → `heex-template-expert` / `tailwind-strategist` (as needed) → `test-builder` → (`security-reviewer` for auth-sensitive UI)

**Highlights**:
- Research phase: `nuxt-ui-expert` provides component specs (props/slots/events) in markdown + JSON
- Coordination phase: `frontend-design-enforcer` drives integration using component specs
- Implementation phase: Specialists (`heex-template-expert`, `tailwind-strategist`) generate code
- Use Playwright for screenshots/accessibility; coordinate monitoring if instrumentation changes

### Graph Visualization (Cytoscape)
**Sequence**: `mcp-verify-first` → `cytoscape-expert` → `test-builder` → `code-reviewer`

**Highlights**:
- Ensure node/edge resources align with `ash-resource-template`
- Capture browser console output and screenshots to prove stability

### Backend Resource Development
**Sequence**: `mcp-verify-first` → `ash-resource-architect` → `test-builder` → `code-reviewer` (or `security-reviewer` if sensitive data)

**Highlights**:
- Always generate migrations + tests before handoff
- Document policies, calculations, and pending follow-ups

### End-to-End Feature Slice
**Sequence**: `mcp-verify-first` → Planning (TodoWrite) → `ash-resource-architect` → `frontend-design-enforcer` → `test-builder` → `code-reviewer` → `security-reviewer`

**Highlights**:
- Keep a shared Todo board; update after each agent completes
- Cross-reference patterns in final summary for traceability

### Bug Fix / Incident Response
**Sequence**: `mcp-verify-first` → `test-builder` (reproduce + tests) → Domain agent (e.g., `ash-resource-architect`/`frontend-design-enforcer`) → `code-reviewer` → `security-reviewer` (if exploit)

**Highlights**:
- Use `error-recovery-loop` to document failed attempts
- Root cause summary + remediation steps go in final handoff

### Security Sweep
**Sequence**: `mcp-verify-first` → `security-reviewer` → Owners (`code-review-implement`/custom fix) → `security-reviewer` (verification pass)

**Highlights**:
- Report only findings with confidence ≥8/10
- Track mitigation status via TodoWrite tasks

### Regression Prevention
**Sequence**: `mcp-verify-first` → `test-builder` (add regression test) → Fix agent → `test-builder` (ensure pass) → `code-reviewer`

**Highlights**:
- Commit history stays clean: tests first, fixes second
- Document commands and evidence for future incidents

### Release Readiness
**Sequence**: `mcp-verify-first` → `dependency-auditor` → `test-builder` (targeted suites) → `release-coordinator` → `docs-maintainer`

**Highlights**:
- Dependency checks run before final gates to reduce surprises
- `release-coordinator` blocks completion without proof; `docs-maintainer` finalizes public notes

### Dependency Maintenance
**Sequence**: `dependency-auditor` → Implementation agent (apply upgrades) → `test-builder` → `release-coordinator`

**Highlights**:
- Use break-glass Todo items for risky upgrades; coordinate with release window
- Ensure quality gates run after each batch of updates

### Migration & Backfill
**Sequence**: `mcp-verify-first` → `database-migration-specialist` → `test-builder` → `release-coordinator`

**Highlights**:
- Rollout/rollback instructions accompany every migration
- Coordinate with ops for timed deploys, especially for data-heavy scripts

### Performance Investigation
**Sequence**: `mcp-verify-first` → `performance-profiler` → Implementation agent (apply optimizations) → `test-builder`/`code-reviewer`

**Highlights**:
- Capture before/after benchmarks; keep them for release notes
- Re-run profiler after fixes to confirm gains

### API Evolution
**Sequence**: `ash-resource-architect` (if schema change) → `api-contract-guardian` → Implementation agent → `docs-maintainer`

**Highlights**:
- Guardian ensures specs/tests updated before merge
- Documentation and changelog entries follow immediately

### CI/CD Hardening
**Sequence**: `ci-cd-optimizer` → Implementation agent (apply workflow changes) → `test-builder` (spot-check) → `release-coordinator`

**Highlights**:
- Run optimizer after flaky runs or pipeline additions
- Keep optimization diffs small and well-documented for reviewers

### Observability Uplift
**Sequence**: `monitoring-setup` → Implementation agent (if code instrumentation needed) → `docs-maintainer`

**Highlights**:
- Ensure dashboards/alerts are shared in the handoff
- Coordinate with ops/SRE before enabling production alerts

### Pattern Maintenance
**Sequence**: `pattern-librarian` → Affected agent owners → `docs-maintainer`

**Highlights**:
- Librarian updates `.claude/CHANGELOG.md` and identifies follow-up work
- Documentation team mirrors any pattern changes in developer guides

### Meta-Workflow Management
**Sequence**: `workflow-expert` (audit/validate/propose) → Peter approval → Implementation (if approved)

**When to Use**:
- Adding new agents, patterns, or commands
- Detecting inconsistencies or broken references in workflow files
- Regular workflow quality audits
- Before major workflow refactors

**Highlights**:
- **Proposal-only mode**: workflow-expert NEVER directly edits files, only generates structured proposals
- All proposals include: current state analysis → proposed changes (diffs) → rationale → risk assessment → rollback plan
- Peter must approve before any changes are applied
- Self-validation capability: `/workflow self-check` validates workflow-expert itself (meta-awareness)

**Common Operations**:
- `/workflow review` - Full audit of all workflow infrastructure
- `/workflow validate agent:name` - Check specific component compliance
- `/workflow add agent name` - Propose new agent with complete specification
- `/workflow update target` - Propose improvements to existing component

### Decision Trees for Common Scenarios

#### New Feature Implementation
```
START
  ↓
Is context verified? → NO → Run mcp-verify-first (Haiku)
  ↓ YES
Does it need backend? → YES → ash-resource-architect (Sonnet)
  ↓ NO                        ↓
Does it need frontend? → YES → frontend-design-enforcer (Sonnet)
  ↓ BOTH                      ↓
                        test-builder (Sonnet)
                              ↓
                        code-reviewer (Sonnet)
                              ↓
                    Does review pass? → NO → code-review-implement (Haiku)
                              ↓ YES                    ↓
                        security-reviewer (Sonnet)     ↓
                              ↓                         ↓
                        docs-maintainer (Haiku) ←──────┘
                              ↓
                           DONE
```

#### Bug Fix with Known Root Cause
```
START
  ↓
Is context verified? → NO → mcp-verify-first (Haiku)
  ↓ YES
Can I reproduce? → NO → test-builder (Sonnet) to create reproduction
  ↓ YES
Is fix straightforward? → YES → code-review-implement (Haiku)
  ↓ NO                              ↓
Domain agent (Sonnet)               ↓
  ↓                                 ↓
test-builder (Sonnet) ←─────────────┘
  ↓
code-reviewer (Sonnet)
  ↓
DONE
```

#### Documentation Update
```
START
  ↓
Is scope clear? → NO → Ask user for clarification
  ↓ YES
docs-maintainer (Haiku)
  ↓
Did formatting succeed? → NO → Escalate to Sonnet
  ↓ YES
DONE
```

#### Database Migration
```
START
  ↓
Is context verified? → NO → mcp-verify-first (Haiku)
  ↓ YES
database-migration-specialist (Haiku)
  ↓
Did migration generate? → NO → Escalate to Sonnet (complex schema)
  ↓ YES
test-builder (Sonnet) for validation
  ↓
release-coordinator (Sonnet)
  ↓
DONE
```

---

## Pattern Library Guide

This guide explains how to combine the reusable patterns in `.claude/patterns/` when building or running agents.

### Core Stack (load in this order)
1. **placeholder-basics** – Introduces placeholder tokens and wrong/right examples
2. **phase-zero-context** – Detects umbrella apps, domains, and resources before any action
3. **mcp-tool-discipline** – Enforces tooling-first verification
4. **self-check-core** – Pre-flight checklist before responses
5. **dual-example-bridge** – Shows generic + concrete snippets side by side

### Specialized Patterns

| Pattern | Purpose | Typical Agents |
| --- | --- | --- |
| `ash-resource-template` | Scaffold Ash resources with actions, policies, migrations | `ash-resource-architect`, `cytoscape-expert`, `database-migration-specialist`, `api-contract-guardian` |
| `error-recovery-loop` | Handle failing commands/tests with structured retries | Implementation agents, `test-builder`, `code-review-implement`, `release-coordinator`, `dependency-auditor` |
| `context-handling` | Maintain session summaries, Todo lists, handoffs | Long-running agents (architect, testers, `pattern-librarian`) |
| `collaboration-handoff` | Package results for the next teammate | All agents ending a session |

### How Agents Reference Patterns
- Each agent lists `pattern-stack` in front matter with pattern names
- Use the short "Pattern:" callouts inside prompts to reinforce critical steps
- Git history tracks all pattern changes (no need for manual version/timestamp tracking)

### Updating Patterns
1. Edit the pattern file (keep it under ~200 lines, focused on single responsibility)
2. Update agents' `pattern-stack` if the dependency set changes (adding/removing patterns)
3. Run `scripts/check_claude_patterns.exs` to ensure compliance (if available)

### Compliance Script
If `scripts/check_claude_patterns.exs` exists, it performs lightweight validation:
- Confirms every agent includes `pattern-stack`
- Flags patterns referenced without matching files
- Lists agents missing the core stack

Run it with:
```bash
mix run scripts/check_claude_patterns.exs
```

---

## Usage Rules Integration

### Automatic Discovery via MCP

**Tool**: `mcp__ash_ai__get_usage_rules`

**Returns**: All usage rules from installed packages with file paths

**Agents should**: Call this tool to discover available rules, then read relevant files

### Available Rules (17 files)
- **Core**: ash, ash_postgres, ash_phoenix, ash_authentication, ash_json_api, ash_ai
- **Tools**: igniter, spark, reactor, usage_rules (general elixir/otp)
- **Phoenix**: main + 5 sub-rules (ecto, elixir, html, liveview, phoenix)

### When to Use

- **`ash-resource-architect`**: Read `/usage-rules/ash.md`, `/usage-rules/ash_postgres.md` before designing resources
- **`frontend-design-enforcer`**: Read `/usage-rules/heex.md`, `/usage-rules/ash_phoenix.md` for LiveView work
- **`code-reviewer`**: Reference relevant rules from `/usage-rules/` for framework compliance checks
- **Any agent working with Ash/Phoenix**: Discover and read contextually relevant rules from `/usage-rules/`

### Usage Rules Location
- **Root file**: `/usage-rules.md` - Overview and index of all framework rules
- **Folder**: `/usage-rules/` - All framework rules and xTweak-specific patterns

**Agents should**:
1. Read `/usage-rules.md` for overview and index
2. Read specific files from `/usage-rules/` for framework and xTweak patterns
3. All framework rules are now consolidated in this single location

---

## Launch Protocol

1. **Clarify scope** – Confirm the request maps to exactly one agent. Split work if necessary
2. **Phase Zero** – The first step is always to run `phase-zero-context` (auto-enforced by agents)
3. **Gather evidence** – Leverage MCP tools listed in each agent's `pattern-stack`. No assumptions
4. **Use TodoWrite** – Complex tasks should maintain a visible checklist for transparency
5. **Run quality gates** – Before finishing, ensure relevant commands/tests succeeded
6. **Handoff** – Apply `collaboration-handoff` pattern: summary, artifacts, outstanding work, validation, next actions

---

## Validation Expectations

- Every agent triggers `self-check-core` before responding—ensure it passes
- Capture command output or screenshots for each significant claim
- List unaddressed issues explicitly; silence implies completion

### Maintenance & Verification

Run `tools-config-guardian` monthly or after tool updates to:
- Verify Claude Code + Codex CLI configurations are valid
- Test all MCP servers (TideWave, Ash AI, Playwright, Context7)
- Check for tool version updates and breaking changes
- Validate documentation accuracy and flow

---

## Need a New Agent?

Launch `agent-architect` with:
- Goal, constraints, and success criteria
- Required tools/permissions
- Related patterns or docs to reuse

It will produce a JSON spec referencing the same pattern stack structure so the team stays aligned.

