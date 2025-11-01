---
title: Phase Zero Context
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

4. **Load Applicable Architecture Rules** (NEW - MANDATORY)
   Based on task domain, read relevant files from `/usage-rules/`:

   | Task Type | Required Rules |
   |-----------|---------------|
   | Backend/Ash Resource | `/usage-rules/ash.md`, `/usage-rules/ash_postgres.md` |
   | LiveView/Frontend | `/usage-rules/heex.md`, `/usage-rules/ash_phoenix.md` |
   | Template Work | `/usage-rules/heex.md` |
   | Generators | `/usage-rules/igniter.md` |
   | All Tasks | `/usage-rules.md` (overview) |

   **Store** list of loaded rules for verification.

5. **Optional Deep Dives** (select as needed)
   - List actions: `mcp__tidewave__project_eval code: "{DetectedDomain}.User.__ash_config__(:actions)"`
   - Search for generators: `mcp__ash_ai__list_generators`
   - Inspect logs for context: `mcp__tidewave__get_logs level: "error"`

6. **Persist Context**
   - Store `{detected_core_app}`, `{detected_web_app}`, `{detected_ui_app}`, `{detected_domain}` in session memory or a Todo list.
   - Store list of loaded architecture rules
   - All subsequent examples and commands must substitute these detected values.

7. **Output Confirmation** (NEW - MANDATORY)
   ```markdown
   ✅ Phase Zero Complete
   - Apps: [detected apps]
   - Domain: [detected domain]
   - Resources: [count] found
   - Architecture Rules Loaded: [list files read]
   ```

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

