---
title: Phase Zero Context
updated: 2025-10-02
tags:
  - core
---

# Phase Zero Context Pattern

## Purpose
Guarantee every agent discovers the real project structure before producing guidance. This is the first step in any workflow that touches code, tests, docs, or architecture.

## Mandatory Workflow

1. **Detect Umbrella Structure**
   ```bash
   ls apps/
   # Store detected core + web app names
   ```

2. **Identify Domain Module Pattern**
   ```
   mcp__ash_ai__list_ash_resources
   # Record the fully-qualified domain module (e.g., Blog.Domain, XTweak.Core)
   ```

3. **Verify Modules Exist**
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}"
   # Replace with the value from step 2
   ```

4. **Optional Deep Dives** (select as needed)
   - List actions: `mcp__tidewave__project_eval code: "{DetectedDomain}.User.__ash_config__(:actions)"`
   - Search for generators: `mcp__ash_ai__list_generators`
   - Inspect logs for context: `mcp__tidewave__get_logs level: "error"`

5. **Persist Context**
   - Store `{detected_core_app}`, `{detected_web_app}`, `{detected_domain}` in session memory or a Todo list.
   - All subsequent examples and commands must substitute these detected values.

## Usage Notes
- Never proceed if any detection step fails; request clarification instead.
- Re-run Phase Zero whenever the project context might have changed (new umbrella app, different repo, etc.).
- Pair with `placeholder-basics` to ensure replacements happen correctly.

## Snippet

```markdown
> Pattern: phase-zero-context
> 1. `ls apps/`
> 2. `mcp__ash_ai__list_ash_resources`
> 3. `mcp__tidewave__project_eval` with detected modules
> 4. Store values → use in all outputs
```

## Change Log
- – Consolidated from legacy Phase 0 detection pattern with clarified optional steps.
