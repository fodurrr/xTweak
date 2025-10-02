---
title: Error Recovery Loop
version: 1.0.0
updated: 2025-10-02
tags:
  - specialized
  - reliability
---

# Error Recovery Loop Pattern

## Purpose
Guide agents through diagnosing failures, applying safe retries, and documenting outcomes. Use for workflows that execute commands, run tests, or interact with external systems.

## Loop Steps

1. **Detect Failure**
   - Capture command output, stack traces, and log snippets.
2. **Classify Severity**
   - Critical (blocks feature) vs. Non-critical (optional improvement).
3. **Formulate Hypothesis**
   - Reference MCP evidence explaining root cause.
4. **Plan Remediation**
   - Outline steps (e.g., adjust config, rerun command, apply patch).
5. **Execute Safely**
   - Apply changes, run relevant commands/tests.
6. **Verify & Document**
   - Record rerun results, note residual risks, update Todo list if unresolved.

## Snippet

```markdown
> Pattern: error-recovery-loop (v1.0.0)
> 1. Capture failure details
> 2. Classify severity (critical / non-critical)
> 3. Form hypothesis backed by MCP evidence
> 4. Plan remediation steps & approvals
> 5. Execute with safeguards
> 6. Verify outcome + log follow-ups
```

## Integrations
- Combine with `self-check-core` to ensure verification before completion.
- Use alongside `TodoWrite` to track outstanding remediation items.

## Change Log
- v1.0.0 – New pattern responding to gap analysis highlighting missing error handling guidance.
