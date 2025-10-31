---
title: Context Handling
updated: 2025-10-02
tags:
  - specialized
  - collaboration
---

# Context Handling Pattern

## Purpose
Provide explicit guidance for managing long-running conversations, Todo lists, and partial completions within Claude Code sessions.

## Responsibilities

1. **Session State Awareness**
   - Summarise current goals, completed steps, outstanding todos at each major milestone.

2. **Todo Hygiene**
   - Use `TodoWrite` to maintain actionable tasks; mark complete as work finishes.

3. **Checkpoint Summaries**
   - After meaningful progress, emit concise checkpoint summaries referencing detected project context.

4. **Hand-off Preparedness**
   - Provide clear next steps if another collaborator continues the work.

5. **Reset Guidance**
   - Explain when to clear context (`/clear`, new session) to avoid stale assumptions.

## Snippet

```markdown
> Pattern: context-handling
> - Maintain Todo list via TodoWrite.
> - Summarize progress + open issues at checkpoints.
> - Provide hand-off notes before pausing.
> - Recommend context reset if project or repo changes.
```

## Change Log
- – Introduced to formalize context management expectations for agents performing multi-step tasks.
