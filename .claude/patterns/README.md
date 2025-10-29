---
title: Pattern Library Index
version: 1.1.0
updated: 2025-10-30
---

# Claude Pattern Library

Patterns are the contract between agents and documentation. Every agent declares the patterns it uses so anyone can trace behaviour quickly. Start every engagement by loading the "Core Stack" in this order, then add any optional patterns that match the task domain.

## Core Stack

| Pattern | File | Version | Purpose |
| --- | --- | --- | --- |
| Placeholder Basics | `placeholder-basics.md` | 1.0.0 | Explains placeholder syntax once; agents link instead of repeating prose |
| Phase Zero Context | `phase-zero-context.md` | 1.0.0 | Mandatory detection workflow before any project-specific action |
| MCP Tool Discipline | `mcp-tool-discipline.md` | 1.0.0 | Canonical rules for verifying with MCP/tools-first |
| Self-Check Core | `self-check-core.md` | 1.1.0 | Short pre-flight checklist all agents embed; includes model-specific workflows |
| Dual Example Bridge | `dual-example-bridge.md` | 1.0.0 | Structure for showing generic + concrete examples |

## Specialized Patterns

| Pattern | File | Version | When to Attach |
| --- | --- | --- | --- |
| Ash Resource Template | `ash-resource-template.md` | 1.0.0 | Resource design, migrations, Ash policies |
| Error Recovery Loop | `error-recovery-loop.md` | 1.0.0 | Any workflow that retries or heals after failures |
| Error Recovery (Haiku) | `error-recovery-haiku.md` | 1.0.0 | Haiku agents only; escalation guidance for bounded tasks |
| Context Handling | `context-handling.md` | 1.0.0 | Long-running tasks that manage chat and todo state |
| Collaboration Handoff | `collaboration-handoff.md` | 1.0.0 | When agents produce artifacts for teammates or future sessions |

## Usage Rules

- Patterns declare assumptions, inputs, and outputs. Agents reference them with the `## Pattern Stack` section to stay discoverable.
- Patterns are versioned. Whenever you change behaviour, bump the `version` field and note it in the change log.
- Keep patterns concise (under ~200 lines) and move examples to `dual-example-bridge.md` unless they are domain-specific.
- Patterns supersede duplicated prose inside agents—link to them, do not restate them.

## Maintenance Checklist

- Update pattern `updated` timestamps when content changes.
- Record changes in `.claude/CHANGELOG.md`.
- Remove unused patterns after confirming no agents reference them.
- Keep at least one example agent referencing every specialized pattern so new authors can discover usage quickly.
