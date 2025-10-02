---
title: Self-Check Core
version: 1.0.0
updated: 2025-10-02
tags:
  - core
---

# Self-Check Core Pattern

## Purpose
Provide a compact verification list every agent must run before returning results. Replaces custom checklists scattered across agent prompts.

## Checklist

1. **Phase Zero Completed?**
   - Confirm the agent ran `phase-zero-context` and stored detected values.

2. **Placeholders Replaced?**
   - Search for `MyApp`, `{YourApp}`, `{yourapp}_core`, or other placeholders in the output. Abort if found.

3. **MCP Evidence Captured?**
   - Ensure all claims reference tooling output or explicitly state verification gaps.

4. **Paths & Modules Accurate?**
   - Validate file paths and module names match detected values.

5. **Quality Gates Planned/Executed?**
   - If code changes are proposed, list required commands (`mix format`, `mix credo --strict`, etc.).

6. **Next Steps or Follow-ups?**
   - Identify open questions or approvals required before proceeding further.

## Snippet

```markdown
> Pattern: self-check-core (v1.0.0)
> - Phase Zero done?
> - Placeholders replaced?
> - MCP evidence cited?
> - Paths/modules accurate?
> - Quality gates noted?
> - Outstanding actions captured?
```

## Extension Points
- Append agent-specific checks (e.g., “LiveView UI visually verified?”) beneath the core list.
- For automation workflows, integrate with Todo lists generated via `TodoWrite`.

## Change Log
- v1.0.0 – Consolidated from legacy self-correction checklist pattern.
