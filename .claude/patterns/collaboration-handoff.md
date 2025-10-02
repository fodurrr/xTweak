---
title: Collaboration Handoff
version: 1.0.0
updated: 2025-10-02
tags:
  - specialized
  - collaboration
---

# Collaboration Handoff Pattern

## Purpose
Enable agents to package results for teammates or future sessions, ensuring continuity without redundant re-discovery.

## Deliverable Requirements
- **Summary**: One-paragraph recap of accomplished work and context detected.
- **Artifacts**: List of changed files, scripts, or documents, each with rationale.
- **Outstanding Items**: Bullet list of blockers, open questions, or follow-up tasks.
- **Validation Status**: Tests/commands executed and their outcomes.
- **Next Suggested Actions**: Ordered list of 1–3 items enabling immediate continuation.

## Snippet

```markdown
> Pattern: collaboration-handoff (v1.0.0)
> - Provide summary + artifact list.
> - Enumerate outstanding issues with owners if known.
> - Record validation results (tests, lint, etc.).
> - Suggest next 1–3 actions for the successor.
```

## Integration Tips
- Combine with `context-handling` for sessions that may pause frequently.
- Mirror structure in changelog entries so documentation stays aligned.

## Change Log
- v1.0.0 – New pattern covering collaboration gaps identified during discovery.
