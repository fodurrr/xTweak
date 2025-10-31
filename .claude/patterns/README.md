---
title: Pattern Library Index
updated: 2025-10-31
---

# Claude Pattern Library

Patterns are the contract between agents and documentation. Every agent declares the patterns it uses so anyone can trace behaviour quickly. Start every engagement by loading the "Core Stack" in this order, then add any optional patterns that match the task domain.

## Core Stack

| Pattern | File | Purpose |
| --- | --- | --- |
| Placeholder Basics | `placeholder-basics.md` | Explains placeholder syntax once; agents link instead of repeating prose |
| Phase Zero Context | `phase-zero-context.md` | Mandatory detection workflow before any project-specific action |
| MCP Tool Discipline | `mcp-tool-discipline.md` | Canonical rules for verifying with MCP/tools-first |
| Self-Check Core | `self-check-core.md` | Short pre-flight checklist all agents embed; includes model-specific workflows |
| Dual Example Bridge | `dual-example-bridge.md` | Structure for showing generic + concrete examples |

## Specialized Patterns

| Pattern | File | When to Attach |
| --- | --- | --- |
| Ash Resource Template | `ash-resource-template.md` | Resource design, migrations, Ash policies |
| Error Recovery Loop | `error-recovery-loop.md` | Any workflow that retries or heals after failures |
| Error Recovery (Haiku) | `error-recovery-haiku.md` | Haiku agents only; escalation guidance for bounded tasks |
| Context Handling | `context-handling.md` | Long-running tasks that manage chat and todo state |
| Collaboration Handoff | `collaboration-handoff.md` | When agents produce artifacts for teammates or future sessions |

## Usage Rules

- Patterns declare assumptions, inputs, and outputs. Agents reference them with the `## Pattern Stack` section to stay discoverable.
- Keep patterns concise (under ~200 lines) and move examples to `dual-example-bridge.md` unless they are domain-specific.
- Patterns supersede duplicated prose inside agents—link to them, do not restate them.

## Maintenance Checklist

- Update pattern `updated` timestamps when content changes.
- Remove unused patterns after confirming no agents reference them.
- Keep at least one example agent referencing every specialized pattern so new authors can discover usage quickly.
