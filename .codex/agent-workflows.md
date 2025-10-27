# Codex Agent Workflows (Pattern-First)

Each flow assumes the **Core Pattern Stack** is loaded and `mcp-verify-first` has supplied verified context. Adjust as needed but keep patterns + quality gates intact.

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
  - Librarian updates `.codex/CHANGELOG.md` and identifies follow-up work.
  - Documentation team mirrors any pattern changes in developer guides.
