---
title: Self-Check Core
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

3. **Architecture Rules Followed?** (NEW - MANDATORY)
   - Verify applicable rules from `/usage-rules/` were loaded and followed
   - For Ash work: Used Ash resources (not Ecto schemas), used code interfaces (not `Ash.get!/2` in LiveViews)
   - For LiveView work: Used modern HEEx directives (`:if`, `:for`, `:let` - NOT `<%= if %>`)
   - For generators: Checked `mcp__ash_ai__list_generators` first
   - Respected umbrella boundaries (core ≠ web deps)

4. **MCP Evidence Captured?**
   - Ensure all claims reference tooling output or explicitly state verification gaps.

5. **Paths & Modules Accurate?**
   - Validate file paths and module names match detected values.

6. **Quality Gates Planned/Executed?**
   - If code changes are proposed, list required commands (`mix format`, `mix credo --strict`, etc.).
   - If code was changed, verify gates were actually run (not just planned)

7. **Next Steps or Follow-ups?**
   - Identify open questions or approvals required before proceeding further.

## Snippet

```markdown
> Pattern: self-check-core
> - Phase Zero done?
> - Placeholders replaced?
> - Architecture rules followed? (Ash-first, modern HEEx, generators-first, umbrella boundaries)
> - MCP evidence cited?
> - Paths/modules accurate?
> - Quality gates run? (if code changed)
> - Outstanding actions captured?
```

## Extension Points
- Append agent-specific checks (e.g., "LiveView UI visually verified?") beneath the core list.
- For automation workflows, integrate with Todo lists generated via `TodoWrite`.

## Model-Specific Workflow Validation

### For Haiku Agents
Before completing a Haiku agent execution, verify:

1. **Stayed Within Scope?**
   - Task remained bounded and implementation-focused
   - No architectural decisions or ambiguous requirements encountered

2. **Escalation Criteria Checked?**
   - If compile errors: documented and escalated?
   - If test failures: root cause clear or escalated?
   - If MCP errors: retried once, then escalated?
   - If pattern unclear: escalated rather than guessed?

3. **Escalation Format Used?**
   - If escalating, used structured `⚠️ HAIKU ESCALATION RECOMMENDED` format
   - Provided specific context for Sonnet continuation

### For Sonnet Agents
Before completing a Sonnet agent execution, verify:

1. **Judgment Calls Documented?**
   - Architectural decisions explained with rationale
   - Trade-offs considered and documented

2. **Complexity Handled?**
   - Ambiguous requirements clarified or addressed
   - Complex patterns applied correctly

3. **Handoff Ready?**
   - If delegating to Haiku agent, scope is clear and bounded
   - Provided structured context via `collaboration-handoff`

