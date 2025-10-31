---
title: MCP Tool Discipline
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
> Pattern: mcp-tool-discipline
> - All claims must cite MCP evidence (commands + results).
> - Prefer generators; only code manually after verifying none apply.
> - Run quality gates (`mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, targeted `mix test`) before completion.
> - Do not manage the Phoenix server lifecycle.
```

## Recommended Tool Checklist
- `mcp__tidewave__project_eval` - Evaluate Elixir code, inspect modules, run Ash queries
- `mcp__tidewave__get_docs` - Get documentation for Elixir modules and functions
- `mcp__tidewave__search_package_docs` - Search Hex documentation for dependencies
- `mcp__tidewave__get_logs` - Retrieve application logs (use `level: "error"` for diagnostics)
- `mcp__ash_ai__list_ash_resources` - Discover all Ash resources in the project
- `mcp__ash_ai__list_generators` - List available Ash generators before manual implementation
- `mcp__tidewave__get_ecto_schemas` - List Ecto schemas (legacy, prefer Ash resources)
- `mcp__context7__resolve-library-id` + `get-library-docs` - Get up-to-date docs for non-Elixir libraries (fallback when specific MCP unavailable)
- `mcp__nuxt-ui-remote__list_components` + `get_component` + `get_component_metadata` - Research UI component APIs and design system specifications
- Optional: `mcp__playwright__*` commands when validating UI in browser

## Change Log
- 2025-10-31 – Removed version numbers from pattern system; added Nuxt UI MCP and Context7 MCP to recommended tool checklist
- 2025-10-02 – Extracted from CLAUDE.md critical principles and MCP enforcement sections
