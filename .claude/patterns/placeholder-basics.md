---
title: Placeholder Basics
version: 1.0.0
updated: 2025-10-02
tags:
  - core
---

# Placeholder Basics Pattern

## Purpose
Explain once how placeholder syntax works so agents never copy literal project names. Agents reference this pattern instead of restating the full explanation in every prompt.

## When to Load
- Any time code examples surface project-specific module names, paths, or app identifiers.
- Required for every agent that might emit code, tests, or shell commands.

## Pattern Instructions

1. **Announce Placeholder Usage**
   - Clarify that all examples use `{Placeholder}` tokens.
   - Enumerate the tokens relevant to the agent (e.g., `{YourApp}`, `{YourApp}Web`, `{YourApp}.Domain`).

2. **Require Phase Zero Result Before Use**
   - Remind the agent to complete the `phase-zero-context` pattern before adapting examples.

3. **Demonstrate Correct vs Incorrect Adaptation**
   - Show a short code fence labeled “WRONG” where literals like `MyApp` are left in place.
   - Follow with a “CORRECT” fence illustrating placeholder replacement using detected values.

4. **Call to Action**
   - Explicitly tell the agent to replace every placeholder with detected values *before* returning any output.

## Boilerplate Snippet

Paste or adapt the following snippet when referencing the pattern:

```markdown
> Pattern: placeholder-basics (v1.0.0)
> - Examples use `{Placeholder}` tokens to stay project-agnostic.
> - Complete Phase Zero to detect actual names, then replace all tokens.
> - Never output `MyApp`, `my_app_core`, or other literals after detection.
```

## Change Log
- v1.0.0 – Initial extraction from legacy placeholder header content.
