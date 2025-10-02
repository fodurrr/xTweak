---
title: MCP Tool Discipline
version: 1.0.0
updated: 2025-10-02
tags:
  - core
---

# MCP Tool Discipline Pattern

## Purpose
Ensure agents treat MCP tooling as the source of truth. Prevents assumption-driven mistakes by standardising verification steps.

## Core Rules

1. **Tools Before Assumptions**
   - For any claim about the codebase, fetch evidence via MCP (`project_eval`, `get_docs`, `get_logs`, `list_ash_resources`, etc.).
   - If a tool is unavailable or fails, document the failure and ask whether to continue.

2. **Generator-First Mindset**
   - Always check `mcp__ash_ai__list_generators` or relevant Mix tasks before manual implementations.

3. **Logging & Diagnostics**
   - Use `mcp__tidewave__get_logs level: "error"` after running code or tests.
   - Capture outputs and reference them in responses.

4. **Database & Runtime Safety**
   - Interact with the database only via Ash or sanctioned queries (`execute_sql_query` for debugging with confirmation).

5. **Never Start/Stop Phoenix**
   - Document the rule to avoid breaking tool connections.

## Implementation Template

```markdown
> Pattern: mcp-tool-discipline (v1.0.0)
> - All claims must cite MCP evidence (commands + results).
> - Prefer generators; only code manually after verifying none apply.
> - Run quality gates (`mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, targeted `mix test`) before completion.
> - Do not manage the Phoenix server lifecycle.
```

## Recommended Tool Checklist
- `mcp__tidewave__project_eval`
- `mcp__tidewave__get_docs`
- `mcp__tidewave__search_package_docs`
- `mcp__tidewave__get_logs`
- `mcp__ash_ai__list_ash_resources`
- `mcp__ash_ai__list_generators`
- `mcp__tidewave__get_ecto_schemas`
- Optional: Playwright MCP commands when validating UI.

## Change Log
- v1.0.0 – Extracted from CLAUDE.md critical principles and MCP enforcement sections.
