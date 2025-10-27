# Codex Agent Reports

This directory stores detailed execution reports from Codex agents.

## Purpose

When Codex agents complete significant work (audits, reviews, analysis), they should generate timestamped markdown reports here for future reference and traceability.

## Naming Convention

Reports should follow this pattern:
```
YYYY-MM-DD-[agent-name]-[task-summary].md
```

**Examples:**
- `2025-10-27-dependency-auditor-phased-upgrade.md`
- `2025-10-28-security-reviewer-auth-policy-audit.md`
- `2025-11-01-performance-profiler-liveview-optimization.md`

## Report Structure

Each report should include:
- **Date & Agent**: Timestamp and agent identifier
- **Task Summary**: Brief description of what was requested
- **Context**: Detected project state (apps, domains, versions)
- **Findings**: Detailed analysis results
- **Actions Taken**: Commands executed, files modified
- **Evidence**: Command outputs, test results, metrics
- **Recommendations**: Follow-up work and next steps
- **Validation**: Quality gate results

## Integration with Agent Workflows

Agents should reference their reports in handoff summaries using relative paths:
```markdown
See detailed analysis: `.codex/agent-reports/2025-10-27-dependency-auditor-phased-upgrade.md`
```

## Maintenance

- Keep reports for at least 90 days
- Archive older reports annually
- Cross-reference with `.codex/CHANGELOG.md` for major milestones
