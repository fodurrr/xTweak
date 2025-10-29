# Claude Agent Workflows (Pattern-First)

Each flow assumes the **Core Pattern Stack** is loaded and `mcp-verify-first` has supplied verified context. Adjust as needed but keep patterns + quality gates intact.

## Model Selection Strategy

**Default Model Assignment**:
- **Sonnet 4.5**: Research, planning, analysis, coordination, complex reasoning (17 agents)
- **Haiku 4.5**: Bounded implementation tasks with clear patterns (6 agents)

**Haiku Agents** (cost-optimized, auto-escalate on complexity):
- `mcp-verify-first` - Structured MCP context gathering
- `docs-maintainer` - Markdown editing and changelog updates
- `code-review-implement` - Applying structured review feedback
- `database-migration-specialist` - Schema-focused SQL generation
- `pattern-librarian` - Pattern compliance auditing
- `monitoring-setup` - Telemetry configuration

**When Haiku Escalates**:
- Compile errors requiring deep analysis
- Test failures with unclear root cause
- MCP server errors after retry
- Pattern interpretation ambiguity
- Complex architectural decisions

**Escalation Process**:
1. Haiku agent encounters complexity beyond its capabilities
2. Agent outputs structured escalation message with context
3. User re-runs same agent with `--model sonnet` flag
4. Sonnet receives full context from Haiku's attempt

See `.claude/MODEL_SELECTION_STRATEGY.md` for full rationale and cost analysis.

## Code Quality Pipeline
- **Sequence**: `mcp-verify-first` → `code-reviewer` → `code-review-implement` → `code-reviewer`
- **Why**: Separates diagnosis from execution, ensuring clean reports before and after fixes.
- **Notes**:
  - Capture score deltas between reviews.
  - `code-review-implement` must log commands and remaining todos via `collaboration-handoff`.

## Frontend Delivery
- **Sequence**: `mcp-verify-first` → (optional `ash-resource-architect`) → `frontend-design-enforcer` → `daisyui-expert` / `tailwind-strategist` (as needed) → `test-builder` → (`security-reviewer` for auth-sensitive UI)
- **Highlights**:
  - Enforcer drives integration; specialists supply component/theme and utility/layout guidance.
  - Use Playwright for screenshots/accessibility; coordinate monitoring if instrumentation changes.

## Graph Visualization (Cytoscape)
- **Sequence**: `mcp-verify-first` → `cytoscape-expert` → `test-builder` → `code-reviewer`
- **Highlights**:
  - Ensure node/edge resources align with `ash-resource-template`.
  - Capture browser console output and screenshots to prove stability.

## Backend Resource Development
- **Sequence**: `mcp-verify-first` → `ash-resource-architect` → `test-builder` → `code-reviewer` (or `security-reviewer` if sensitive data)
- **Highlights**:
  - Always generate migrations + tests before handoff.
  - Document policies, calculations, and pending follow-ups.

## End-to-End Feature Slice
- **Sequence**: `mcp-verify-first` → Planning (TodoWrite) → `ash-resource-architect` → `frontend-design-enforcer` → `test-builder` → `code-reviewer` → `security-reviewer`
- **Highlights**:
  - Keep a shared Todo board; update after each agent completes.
  - Cross-reference patterns in final summary for traceability.

## Bug Fix / Incident Response
- **Sequence**: `mcp-verify-first` → `test-builder` (reproduce + tests) → Domain agent (e.g., `ash-resource-architect`/`frontend-design-enforcer`) → `code-reviewer` → `security-reviewer` (if exploit)
- **Highlights**:
  - Use `error-recovery-loop` to document failed attempts.
  - Root cause summary + remediation steps go in final handoff.

## Security Sweep
- **Sequence**: `mcp-verify-first` → `security-reviewer` → Owners (`code-review-implement`/custom fix) → `security-reviewer` (verification pass)
- **Highlights**:
  - Report only findings with confidence ≥8/10.
  - Track mitigation status via TodoWrite tasks.

## Regression Prevention
- **Sequence**: `mcp-verify-first` → `test-builder` (add regression test) → Fix agent → `test-builder` (ensure pass) → `code-reviewer`
- **Highlights**:
  - Commit history stays clean: tests first, fixes second.
  - Document commands and evidence for future incidents.

## Release Readiness
- **Sequence**: `mcp-verify-first` → `dependency-auditor` → `test-builder` (targeted suites) → `release-coordinator` → `docs-maintainer`
- **Highlights**:
  - Dependency checks run before final gates to reduce surprises.
  - `release-coordinator` blocks completion without proof; `docs-maintainer` finalizes public notes.

## Dependency Maintenance
- **Sequence**: `dependency-auditor` → Implementation agent (apply upgrades) → `test-builder` → `release-coordinator`
- **Highlights**:
  - Use break-glass Todo items for risky upgrades; coordinate with release window.
  - Ensure quality gates run after each batch of updates.

## Migration & Backfill
- **Sequence**: `mcp-verify-first` → `database-migration-specialist` → `test-builder` → `release-coordinator`
- **Highlights**:
  - Rollout/rollback instructions accompany every migration.
  - Coordinate with ops for timed deploys, especially for data-heavy scripts.

## Performance Investigation
- **Sequence**: `mcp-verify-first` → `performance-profiler` → Implementation agent (apply optimizations) → `test-builder`/`code-reviewer`
- **Highlights**:
  - Capture before/after benchmarks; keep them for release notes.
  - Re-run profiler after fixes to confirm gains.

## API Evolution
- **Sequence**: `ash-resource-architect` (if schema change) → `api-contract-guardian` → Implementation agent → `docs-maintainer`
- **Highlights**:
  - Guardian ensures specs/tests updated before merge.
  - Documentation and changelog entries follow immediately.

## CI/CD Hardening
- **Sequence**: `ci-cd-optimizer` → Implementation agent (apply workflow changes) → `test-builder` (spot-check) → `release-coordinator`
- **Highlights**:
  - Run optimizer after flaky runs or pipeline additions.
  - Keep optimization diffs small and well-documented for reviewers.

## Observability Uplift
- **Sequence**: `monitoring-setup` → Implementation agent (if code instrumentation needed) → `docs-maintainer`
- **Highlights**:
  - Ensure dashboards/alerts are shared in the handoff.
  - Coordinate with ops/SRE before enabling production alerts.

## Pattern Maintenance
- **Sequence**: `pattern-librarian` → Affected agent owners → `docs-maintainer`
- **Highlights**:
  - Librarian updates `.claude/CHANGELOG.md` and identifies follow-up work.
  - Documentation team mirrors any pattern changes in developer guides.

---

## Decision Trees for Common Scenarios

### New Feature Implementation
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

### Bug Fix with Known Root Cause
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

### Documentation Update
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

### Database Migration
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

### Code Review Implementation
```
START (have review report)
  ↓
code-review-implement (Haiku)
  ↓
Did compile succeed? → NO → Escalate to Sonnet
  ↓ YES
Did tests pass? → NO → Escalate to Sonnet
  ↓ YES
code-reviewer (Sonnet) for verification
  ↓
DONE
```

### Pattern Compliance Audit
```
START
  ↓
pattern-librarian (Haiku)
  ↓
Found version conflicts? → YES → Escalate to Sonnet
  ↓ NO
docs-maintainer (Haiku) for changelog
  ↓
DONE
```

## Recognizing Escalation Signals

**Visual Indicator**: All Haiku agents output escalation messages in this format:
```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: [specific category]
**Details**: [what went wrong]
**What I Attempted**: [what was tried]
**Why Escalation Needed**: [why Sonnet is required]
**Suggested Action**: Re-run [agent-name] with Sonnet model
**Context for Sonnet**: [specific context to preserve]
```

**When You See This**:
1. Copy the escalation context
2. Re-run: `@agent-name --model sonnet` (if Claude Code supports flag)
3. Or manually invoke agent with Sonnet in a new conversation
4. Paste escalation context for continuity

**Cost vs Quality Decision**:
- **Try Haiku first** when task is repetitive, well-structured, or follows established patterns
- **Start with Sonnet** when task requires architectural decisions, complex reasoning, or involves ambiguous requirements
- **Accept escalation** when Haiku encounters its limits - this is expected and intentional
