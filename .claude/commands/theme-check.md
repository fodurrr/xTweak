---
name: theme-check
description: Run theme compliance audit on UI components to detect hardcoded colors and theme violations
---

# Theme Compliance Audit Command

You are the **Theme Compliance Guard**. Your mission is to audit all xTweak UI components and verify they follow the theming architecture correctly.

## Your Task

Launch the `theme-compliance-guard` agent to perform a comprehensive audit of the component library and generate a detailed compliance report.

## What to Audit

1. **All UI Components** in `apps/xtweak_ui/lib/xtweak_ui/components/`
2. **Theme Configuration** in `apps/xtweak_ui/lib/xtweak_ui/theme.ex`
3. **CSS Variables** in `apps/xtweak_ui/priv/static/assets/app.css`

## Detection Focus

### ❌ Look For Violations:
- Hardcoded Tailwind color classes (bg-green-500, text-red-700, border-blue-500)
- Components not using `Theme.component_config(:component_name)`
- CSS variables used but not defined (var(--color-info))
- Theme config exists but component ignores it

### ✅ Look For Compliance:
- Colors fetched from Theme module
- Proper theme config structure
- CSS variables properly defined (if used)
- Consistent theming patterns

## Execution Steps

1. **Launch the Agent**:
   ```
   Use the Task tool with subagent_type="theme-compliance-guard"
   ```

2. **Agent Instructions**:
   - Scan all component files
   - Read theme.ex configuration
   - Detect hardcoded colors
   - Validate theme usage
   - Check CSS variable definitions
   - Generate detailed compliance report

3. **Report Format**:
   - Executive summary with compliance percentage
   - Per-component detailed findings
   - Violation severity (High/Medium/Low)
   - Specific fix recommendations with code examples
   - Prioritized action plan

## Expected Output

The agent will return a comprehensive markdown report showing:

- **Compliant components** (✅) - no action needed
- **Non-compliant components** (❌) - with specific violations and fixes
- **Warning components** (⚠️) - minor issues or improvements suggested

## Example Usage

```bash
# Run full audit
/theme-check

# The agent will scan all components and return a report like:
#
# Theme Compliance Audit Report
# =============================
# Components Scanned: 6
# Compliant: 2 (33%)
# Non-Compliant: 4 (67%)
#
# ❌ Alert Component - Hardcoded colors (lines 213-309)
# ❌ Button Component - Hardcoded colors (lines 193-277)
# ✅ Card Component - Compliant
# ...
```

## After the Report

1. **Review findings** - Understand each violation
2. **Prioritize fixes** - Start with high severity issues
3. **Implement corrections** - Follow recommended fix patterns
4. **Re-run audit** - Verify compliance improved
5. **Track progress** - Goal is 100% compliance

## Architecture Rules

Components MUST:
- Define all color configurations in `theme.ex`
- Fetch colors via `Theme.component_config(:component_name)`
- NOT hardcode semantic colors (success, error, warning, info, primary, secondary)
- Support theme customization via config/config.exs

Components MAY:
- Use neutral structural colors (gray scales) for layout
- Have dark mode variants for accessibility

## Success Criteria

A compliant component:
✅ Fetches all semantic colors from Theme module
✅ Has complete color config in theme.ex
✅ Supports runtime customization
✅ No hardcoded color helper functions

## Now Execute

Launch the `theme-compliance-guard` agent now and provide me with the full compliance report.
