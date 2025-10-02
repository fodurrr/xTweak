# Claude Pattern Guide

This guide explains how to combine the reusable patterns in `.claude/patterns/` when building or running agents.

## Core Stack (load in this order)
1. **placeholder-basics** – Introduces placeholder tokens and wrong/right examples.
2. **phase-zero-context** – Detects umbrella apps, domains, and resources before any action.
3. **mcp-tool-discipline** – Enforces tooling-first verification.
4. **self-check-core** – Pre-flight checklist before responses.
5. **dual-example-bridge** – Shows generic + concrete snippets side by side.

## Specialized Patterns
| Pattern | Purpose | Typical Agents |
| --- | --- | --- |
| `ash-resource-template` | Scaffold Ash resources with actions, policies, migrations. | `ash-resource-architect`, `cytoscape-expert`, `database-migration-specialist`, `api-contract-guardian` |
| `error-recovery-loop` | Handle failing commands/tests with structured retries. | Implementation agents, `test-builder`, `code-review-implement`, `release-coordinator`, `dependency-auditor` |
| `context-handling` | Maintain session summaries, Todo lists, handoffs. | Long-running agents (architect, testers, `pattern-librarian`) |
| `collaboration-handoff` | Package results for the next teammate. | All agents ending a session |

## How Agents Reference Patterns
- Each agent lists `pattern-stack` in front matter with `pattern@version` entries.
- When updating a pattern, bump its version and update every agent referencing it.
- Use the short “Pattern:” callouts inside prompts to reinforce critical steps.

## Updating Patterns
1. Edit the pattern file (keep it under ~200 lines, focused on single responsibility).
2. Update `version` and `updated` metadata; describe the change in `.claude/CHANGELOG.md`.
3. Notify agents by updating their `pattern-stack` if the dependency set changes.
4. Run `scripts/check_claude_patterns.exs` to ensure compliance (see below).

## Compliance Script
`scripts/check_claude_patterns.exs` performs lightweight validation:
- Confirms every agent includes `version`, `updated`, and `pattern-stack`.
- Flags patterns referenced without matching files.
- Lists agents missing the core stack.

Run it with:
```bash
mix run scripts/check_claude_patterns.exs
```

Use this guide as the authoritative reference when designing or refactoring agents.
