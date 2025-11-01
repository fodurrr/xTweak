# Visual Regression Testing with Playwright

This document describes the visual regression testing setup for xTweak UI components using Playwright MCP tools.

## Overview

Visual regression tests capture screenshots of UI components in both light and dark themes to establish visual baselines for future regression testing.

## Test Coverage

### Components Tested
- **Badge** - 4 variants, 5 colors, 4 sizes
- **Avatar** - 9 sizes, image/text/icon/initials fallbacks, status chips
- **Card** - 4 variants, 4 padding options, slot combinations
- **Alert** - 7 colors, 4 variants, dismissible states
- **Divider** - Horizontal/vertical, label/icon/avatar, sizes, types, colors

### Screenshot Baseline (12 total)

#### Full Page Screenshots (2)
- `showcase-light-fullpage.png` (1.1M) - Complete showcase in light mode
- `showcase-dark-fullpage.png` (1.2M) - Complete showcase in dark mode

#### Component Section Screenshots (10)

**Light Mode (5)**
- `badge-light.png` (98K) - All Badge variants
- `avatar-light.png` (140K) - All Avatar variants and fallbacks
- `card-light.png` (291K) - All Card variants and padding options
- `alert-light.png` (226K) - All Alert colors and variants
- `divider-light.png` (188K) - All Divider orientations and styles

**Dark Mode (5)**
- `badge-dark.png` (97K) - All Badge variants
- `avatar-dark.png` (136K) - All Avatar variants and fallbacks
- `card-dark.png` (304K) - All Card variants and padding options
- `alert-dark.png` (260K) - All Alert colors and variants
- `divider-dark.png` (187K) - All Divider orientations and styles

## Running Visual Regression Tests

### Prerequisites

1. **Start Phoenix Server**
   ```bash
   mix phx.server
   ```
   Server must be running on `http://localhost:4000`

2. **Playwright MCP Tools Available**
   - Visual tests use Playwright MCP server integration
   - Microsoft Edge browser is configured

### Test Execution Workflow

The visual regression tests follow this workflow:

1. **Navigate to Showcase Page**
   - URL: `http://localhost:4000/showcase`
   - Viewport: 1280x1024 (consistent for all screenshots)

2. **Capture Light Mode**
   - Full page screenshot
   - Individual component section screenshots

3. **Switch to Dark Mode**
   - Click theme toggle button (🌙 Dark → ☀️ Light)

4. **Capture Dark Mode**
   - Full page screenshot
   - Individual component section screenshots

5. **Verify Screenshots**
   - Check all 12 PNG files exist
   - Verify file sizes are reasonable

### Manual Test Execution

To manually run visual regression tests using Playwright MCP tools:

```bash
# 1. Start the Phoenix server
mix phx.server

# 2. Use Playwright MCP tools to:
#    - Navigate to http://localhost:4000/showcase
#    - Set viewport to 1280x1024
#    - Take screenshots in light mode
#    - Click theme switcher
#    - Take screenshots in dark mode
```

## Screenshot Storage

All screenshots are stored in:
```
/home/fodurrr/dev/xTweak/.playwright-mcp/test/screenshots/
```

**Note:** This location is managed by the Playwright MCP server. Screenshots should be copied to a permanent location for version control if needed.

## Updating Baselines

To update visual baselines after intentional component changes:

1. Review the component changes in the showcase
2. Re-run the visual regression tests
3. Compare new screenshots with existing baselines
4. If changes are intentional, replace old baselines with new screenshots
5. Document the reason for baseline update

## Theme Switching Verification

The tests verify that theme switching works correctly by:
- Capturing the theme toggle button state
- Verifying button changes from "🌙 Dark" to "☀️ Light"
- Confirming visual differences between light/dark screenshots

## Known Issues and Fixes

### Issue: Avatar Chip Example in Code Block
**Problem:** The code example showing Avatar with chip attribute caused HEEx template parsing errors because `{%{...}}` syntax was evaluated even inside HTML entities.

**Fix:** Removed the problematic chip example from the code block in `showcase_live.ex` line 515-520.

**Files Modified:**
- `/home/fodurrr/dev/xTweak/apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex`

## Future Enhancements

### Automated Screenshot Comparison
- Integrate screenshot diffing tools (e.g., pixelmatch, looks-same)
- Set acceptable diff thresholds per component
- Automated pass/fail criteria

### CI/CD Integration
- Run visual regression tests on pull requests
- Store baseline screenshots in version control or cloud storage
- Report visual differences in PR comments

### Component-Specific Tests
- Capture individual variant states (e.g., badge-solid-primary.png)
- Test interactive states (hover, focus, active)
- Test responsive breakpoints

### Accessibility Testing
- Combine visual screenshots with accessibility snapshots
- Verify ARIA attributes alongside visual appearance
- Test keyboard navigation states

## Test Maintenance

### When to Update Tests
- New component variants added
- Color palette changes
- Typography or spacing updates
- Theme system modifications

### Baseline Management
- Review baselines quarterly
- Document all baseline changes in git commits
- Keep historical baselines for major version changes

## Related Documentation

- [Showcase Page](/apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex)
- [Component Tests](/apps/xtweak_ui/test/xtweak_ui/components/)
- [Sprint 2 Plan](/AI_docs/prd/06-sprint-plans/phase-1-foundation/sprint-2-core-components.md)
