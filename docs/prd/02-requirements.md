# Requirements Document: Nuxt UI → Phoenix/Elixir Port

**Document Version**: 1.0.0
**Date**: 2025-10-29
**Status**: ✅ Approved
**Author**: Peter Fodor (with Claude Code assistance)

---

## Table of Contents

1. [Functional Requirements](#1-functional-requirements)
2. [Non-Functional Requirements](#2-non-functional-requirements)
3. [Component-Specific Requirements](#3-component-specific-requirements)
4. [Integration Requirements](#4-integration-requirements)
5. [Constraints & Assumptions](#5-constraints-assumptions)

---

## 1. Functional Requirements

### FR-1: Component Library

**FR-1.1: Component Completeness**
- **Requirement**: Implement 105 components per inventory (04-component-inventory.md)
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN the component inventory list
  WHEN all phases are complete (Phase 4, Week 24)
  THEN 105 components are implemented and documented
  AND each component has >80% test coverage
  AND each component has ExDoc documentation
  ```

**FR-1.2: API Parity with Nuxt UI**
- **Requirement**: Match Nuxt UI API (props, slots, events) for each component
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN a Nuxt UI component (e.g., Button)
  WHEN researched via Nuxt UI MCP Server
  THEN Phoenix component implements ALL props
  AND Phoenix component implements ALL slots
  AND Phoenix component implements ALL events (where applicable)
  AND API differences are documented with rationale
  ```

**FR-1.3: Variant Support**
- **Requirement**: Support all variants per component (solid, outline, soft, ghost, link where applicable)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN a component with variants (e.g., Button)
  WHEN variant prop is set to "outline"
  THEN component renders with outline styling
  AND visual appearance matches Nuxt UI variant
  AND all variants are tested with visual regression
  ```

**FR-1.4: Size Support**
- **Requirement**: Support all sizes (xs, sm, md, lg, xl where applicable)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN a component with sizes (e.g., Button)
  WHEN size prop is set to "lg"
  THEN component renders with large sizing
  AND spacing, padding, font-size scale appropriately
  AND all sizes tested across all variants
  ```

**FR-1.5: Color Theme Support**
- **Requirement**: Support all colors (primary, secondary, success, warning, error, gray)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN a component with color prop
  WHEN color is set to "success"
  THEN component uses success color scale (--color-success-*)
  AND color works in light and dark themes
  AND color contrast meets WCAG AA standards
  ```

---

### FR-2: Theming System

**FR-2.1: Runtime Theme Switching**
- **Requirement**: Light/dark theme switching without page reload
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN a user on a page with theme="light"
  WHEN user clicks theme toggle
  THEN data-theme attribute updates to "dark" on <html>
  AND all components update colors within 100ms
  AND theme preference persists (localStorage or session)
  AND no flash of unstyled content (FOUC)
  ```

**FR-2.2: Custom Color Schemes**
- **Requirement**: Configure custom colors via config/config.exs
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN config/config.exs with custom primary color
  WHEN application starts
  THEN XTweakUI.Theme.get() returns custom configuration
  AND components use custom color values
  AND custom colors override default theme
  ```

**FR-2.3: Component-Level Defaults**
- **Requirement**: Override component defaults per application
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN config sets button default variant to "outline"
  WHEN <.button> is used without variant prop
  THEN button renders with outline variant
  AND explicit variant prop overrides default
  ```

**FR-2.4: CSS Variable-Based Theming**
- **Requirement**: All colors use CSS variables (--color-primary-500, etc.)
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN Tailwind classes like "bg-primary-500"
  WHEN compiled to CSS
  THEN CSS uses var(--color-primary-500)
  AND CSS variables defined in :root
  AND CSS variables overridden in :root[data-theme="dark"]
  ```

---

### FR-3: Asset Pipeline

**FR-3.1: Build CSS from Tailwind**
- **Requirement**: mix assets.build generates app.css
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN asset pipeline configured
  WHEN developer runs "mix assets.build"
  THEN app.css generated in priv/static/assets/
  AND file size < 30KB (Phase 1), < 80KB (Phase 4) gzipped
  AND CSS contains only used Tailwind classes
  AND build completes in < 5 seconds
  ```

**FR-3.2: Watch Mode**
- **Requirement**: mix assets.watch for development
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN watch mode running (mix assets.watch)
  WHEN developer edits HEEx template
  THEN CSS rebuilds automatically within 2 seconds
  AND browser live-reloads (Phoenix LiveReload)
  AND no manual rebuild required
  ```

**FR-3.3: Production Minification**
- **Requirement**: mix assets.deploy for production
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN production build (mix assets.deploy)
  WHEN CSS is generated
  THEN CSS is minified (NODE_ENV=production)
  AND file size < 80KB gzipped
  AND no development-only classes included
  ```

**FR-3.4: Purge Unused CSS**
- **Requirement**: Tailwind purges unused classes
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN Tailwind content paths configured
  WHEN CSS is built
  THEN unused classes are removed
  AND only classes in ../lib/**/*.{ex,heex} included
  AND safelist protects dynamic classes
  ```

---

### FR-4: Phoenix Integration

**FR-4.1: Phoenix.Component Usage**
- **Requirement**: All components use Phoenix.Component (attr, slot, render_slot)
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN any xTweak UI component
  WHEN inspected
  THEN uses "use Phoenix.Component"
  AND uses attr/2 for props
  AND uses slot/2 for slots
  AND uses render_slot/2 for rendering
  ```

**FR-4.2: Phoenix.HTML.Form Integration**
- **Requirement**: Form components integrate with Phoenix.HTML.Form
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN a form component (Input, Select, etc.)
  WHEN used with Phoenix.HTML.Form field
  THEN component renders correct name attribute
  AND component shows validation errors
  AND component works with changesets
  ```

**FR-4.3: LiveView Event Handlers**
- **Requirement**: Components support phx-click, phx-change, etc.
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN a component with event handler prop
  WHEN prop set to event name (e.g., "handle_click")
  THEN component renders phx-click={@on_click}
  AND LiveView handle_event/3 receives event
  AND event payload includes component data
  ```

**FR-4.4: Heroicons Support**
- **Requirement**: Icon component uses Heroicons (already in Phoenix 1.7+)
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN Icon component
  WHEN name="hero-magnifying-glass"
  THEN Heroicons SVG renders
  AND icon respects size classes
  AND icon inherits text color
  ```

---

### FR-5: JavaScript Interactivity

**FR-5.1: LiveView.JS for Show/Hide**
- **Requirement**: Modal, Tabs use LiveView.JS commands
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN Modal component
  WHEN show_modal(js, id) called
  THEN LiveView.JS.show() executed
  AND no JavaScript bundle required
  AND works without Alpine.js
  ```

**FR-5.2: Alpine.js for Local State**
- **Requirement**: Dropdown, Popover use Alpine.js (Tier 3)
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN Dropdown component
  WHEN rendered
  THEN uses x-data="{ open: false }"
  AND uses x-show="open" for visibility
  AND uses x-on:click.outside="open = false"
  AND Alpine.js bundle < 20KB gzipped
  ```

**FR-5.3: LiveView Hooks for Complex Widgets**
- **Requirement**: DatePicker, ColorPicker use LiveView Hooks
- **Priority**: 🟢 Medium (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN ColorPicker component
  WHEN mounted
  THEN LiveView Hook initializes JS library
  AND Hook syncs state with LiveView assigns
  AND Hook pushes updates to server
  ```

**FR-5.4: Minimal JavaScript Footprint**
- **Requirement**: JavaScript bundle < 20KB (Phase 1-2)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN Phase 2 completion
  WHEN JavaScript bundle measured
  THEN total JS < 20KB gzipped
  AND only Alpine.js included (if Tier 3 components present)
  AND no unnecessary dependencies
  ```

---

### FR-6: Documentation

**FR-6.1: @moduledoc for Components**
- **Requirement**: Every component has @moduledoc
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN any component module
  WHEN inspected
  THEN @moduledoc present
  AND moduledoc includes description
  AND moduledoc includes 3+ examples
  AND moduledoc documents accessibility features
  ```

**FR-6.2: Usage Examples**
- **Requirement**: 3+ usage examples per component
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN component @moduledoc
  WHEN examples section inspected
  THEN minimum 3 examples present
  AND examples show common use cases
  AND examples use valid HEEx syntax
  ```

**FR-6.3: Live Showcase**
- **Requirement**: Live showcase in xtweak_docs
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN xtweak_docs app running
  WHEN navigating to /showcase
  THEN all components demonstrated
  AND interactive examples provided
  AND code examples visible
  AND theme switcher functional
  ```

**FR-6.4: ExDoc API Reference**
- **Requirement**: ExDoc generates API documentation
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN "mix docs" command
  WHEN executed
  THEN ExDoc generates HTML docs
  AND 100% module coverage
  AND 100% function documentation
  AND docs published to hexdocs.pm (Phase 4)
  ```

---

## 2. Non-Functional Requirements

### NFR-1: Performance

**NFR-1.1: Component Render Time**
- **Requirement**: Component render < 100ms (95th percentile)
- **Priority**: 🟡 High
- **Measurement**: mix profile.fprof
- **Acceptance Criteria**:
  ```
  GIVEN performance test suite
  WHEN measuring Button component render
  THEN 95th percentile < 100ms
  AND average render time < 50ms
  AND no blocking operations
  ```

**NFR-1.2: CSS Bundle Size**
- **Requirement**: CSS < 80KB gzipped (Phase 4)
- **Priority**: 🟡 High
- **Measurement**: gzip -c app.css | wc -c
- **Acceptance Criteria**:
  ```
  GIVEN production CSS build
  WHEN measuring file size
  THEN gzipped size < 80KB
  AND Phase 1: < 30KB
  AND Phase 2: < 50KB
  AND Phase 3: < 70KB
  ```

**NFR-1.3: JavaScript Bundle Size**
- **Requirement**: JS < 30KB gzipped (Phase 4)
- **Priority**: 🟢 Medium
- **Measurement**: webpack-bundle-analyzer or esbuild --metafile
- **Acceptance Criteria**:
  ```
  GIVEN production JS build
  WHEN measuring file size
  THEN gzipped size < 30KB (excluding Phoenix/LiveView core)
  AND Phase 1: 0-5KB
  AND Phase 2: 10-15KB
  ```

**NFR-1.4: Theme Switch Latency**
- **Requirement**: Theme switch < 100ms
- **Priority**: 🟢 Medium
- **Measurement**: Lighthouse, Playwright performance traces
- **Acceptance Criteria**:
  ```
  GIVEN theme toggle clicked
  WHEN measuring repaint time
  THEN CSS variables update < 50ms
  AND visual update complete < 100ms
  AND no layout shift (CLS = 0)
  ```

**NFR-1.5: Lighthouse Performance Score**
- **Requirement**: Lighthouse score > 90
- **Priority**: 🟢 Medium
- **Measurement**: Lighthouse CI
- **Acceptance Criteria**:
  ```
  GIVEN showcase page
  WHEN Lighthouse audit run
  THEN Performance score > 90
  AND Accessibility score > 95
  AND Best Practices score > 90
  ```

---

### NFR-2: Accessibility

**NFR-2.1: WCAG AA Compliance**
- **Requirement**: All components meet WCAG AA standards
- **Priority**: 🔴 Critical
- **Measurement**: Playwright MCP (axe-core), manual testing
- **Acceptance Criteria**:
  ```
  GIVEN any component
  WHEN axe-core audit run
  THEN zero critical violations
  AND zero serious violations
  AND moderate violations < 3 (with documented exceptions)
  ```

**NFR-2.2: Keyboard Navigation**
- **Requirement**: All interactive components keyboard-accessible
- **Priority**: 🔴 Critical
- **Measurement**: Manual testing, Playwright
- **Acceptance Criteria**:
  ```
  GIVEN interactive component (Button, Input, Modal, etc.)
  WHEN using keyboard only (Tab, Enter, Space, Escape)
  THEN all functionality accessible
  AND focus order logical
  AND focus indicators visible (outline)
  AND no keyboard traps
  ```

**NFR-2.3: Screen Reader Compatibility**
- **Requirement**: Components work with screen readers
- **Priority**: 🔴 Critical
- **Measurement**: Manual testing (VoiceOver, NVDA)
- **Acceptance Criteria**:
  ```
  GIVEN any component
  WHEN tested with screen reader (VoiceOver, NVDA, JAWS)
  THEN component purpose announced
  AND state changes announced (e.g., "button pressed")
  AND ARIA roles/labels appropriate
  AND no silent failures
  ```

**NFR-2.4: Color Contrast**
- **Requirement**: Color contrast ≥ 4.5:1 (text), ≥ 3:1 (UI components)
- **Priority**: 🔴 Critical
- **Measurement**: axe-core, manual checks
- **Acceptance Criteria**:
  ```
  GIVEN component with text
  WHEN contrast measured
  THEN text contrast ≥ 4.5:1
  AND UI component contrast ≥ 3:1
  AND both light and dark themes pass
  ```

**NFR-2.5: Focus Indicators**
- **Requirement**: Visible focus outline on all interactive elements
- **Priority**: 🔴 Critical
- **Measurement**: Visual inspection, Playwright
- **Acceptance Criteria**:
  ```
  GIVEN interactive element
  WHEN focused via keyboard
  THEN focus indicator visible
  AND contrast ≥ 3:1 with background
  AND indicator not hidden by outline: none
  ```

---

### NFR-3: Code Quality

**NFR-3.1: Test Coverage**
- **Requirement**: Test coverage ≥ 90% (Phase 4)
- **Priority**: 🟡 High
- **Measurement**: ExCoveralls
- **Acceptance Criteria**:
  ```
  GIVEN "mix test --cover" output
  WHEN Phase 4 complete
  THEN overall coverage ≥ 90%
  AND Phase 1: ≥ 60%
  AND Phase 2: ≥ 80%
  AND Phase 3: ≥ 85%
  ```

**NFR-3.2: Zero Credo Warnings**
- **Requirement**: Credo strict mode passes
- **Priority**: 🟡 High
- **Measurement**: mix credo --strict
- **Acceptance Criteria**:
  ```
  GIVEN "mix credo --strict" command
  WHEN executed
  THEN zero warnings
  AND zero errors
  AND zero code smells
  ```

**NFR-3.3: Zero Dialyzer Warnings**
- **Requirement**: Dialyzer static analysis passes
- **Priority**: 🟢 Medium (Phase 3+)
- **Measurement**: mix dialyzer
- **Acceptance Criteria**:
  ```
  GIVEN "mix dialyzer" command
  WHEN executed
  THEN zero warnings
  AND zero errors
  AND @spec annotations present (Phase 4)
  ```

**NFR-3.4: Zero Compiler Warnings**
- **Requirement**: Compilation warnings-as-errors
- **Priority**: 🔴 Critical
- **Measurement**: mix compile --warnings-as-errors
- **Acceptance Criteria**:
  ```
  GIVEN "mix compile --warnings-as-errors"
  WHEN executed
  THEN compilation succeeds
  AND zero warnings
  AND zero deprecation warnings
  ```

**NFR-3.5: Formatted Code**
- **Requirement**: All code follows mix format
- **Priority**: 🔴 Critical
- **Measurement**: mix format --check-formatted
- **Acceptance Criteria**:
  ```
  GIVEN "mix format --check-formatted"
  WHEN executed
  THEN zero unformatted files
  AND CI fails on unformatted code
  ```

---

### NFR-4: Browser Support

**NFR-4.1: Modern Browser Support**
- **Requirement**: Last 2 versions of major browsers
- **Priority**: 🔴 Critical
- **Browsers**: Chrome, Edge, Firefox, Safari
- **Acceptance Criteria**:
  ```
  GIVEN showcase page
  WHEN tested on Chrome (last 2 versions)
  THEN all components render correctly
  AND all interactions work
  AND no console errors
  (Same for Edge, Firefox, Safari)
  ```

**NFR-4.2: Mobile Browser Support**
- **Requirement**: iOS Safari, Chrome Android (last 2 versions)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN showcase page on mobile
  WHEN tested on iOS Safari
  THEN touch interactions work
  AND viewport responsive
  AND no mobile-specific bugs
  ```

**NFR-4.3: No IE11 Support**
- **Requirement**: IE11 not supported (documented)
- **Priority**: 🟢 Low
- **Acceptance Criteria**:
  ```
  GIVEN documentation
  WHEN browser support section viewed
  THEN IE11 explicitly listed as unsupported
  AND no polyfills for IE11
  ```

---

### NFR-5: Maintainability

**NFR-5.1: Consistent Naming Conventions**
- **Requirement**: snake_case (Elixir), kebab-case (CSS)
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN any module/function
  WHEN naming inspected
  THEN Elixir uses snake_case
  AND CSS uses kebab-case
  AND no mixed conventions
  ```

**NFR-5.2: Modular Architecture**
- **Requirement**: 1 component = 1 file
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN component library
  WHEN file structure inspected
  THEN each component in separate file
  AND file name matches module name
  AND no mega-files (>500 lines)
  ```

**NFR-5.3: Reusable Patterns**
- **Requirement**: Shared utilities for common patterns
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN multiple components with similar logic
  WHEN implementation inspected
  THEN shared utilities used (variant_classes/2, size_classes/1)
  AND no duplicated logic
  AND utilities tested independently
  ```

**NFR-5.4: TypeSpec Annotations (Phase 3+)**
- **Requirement**: @spec for public functions
- **Priority**: 🟢 Medium (Phase 3+)
- **Acceptance Criteria**:
  ```
  GIVEN any public function
  WHEN Phase 3+ complete
  THEN @spec annotation present
  AND spec passes Dialyzer
  AND spec documents return types
  ```

---

## 3. Component-Specific Requirements

### Button Component

**REQ-BTN-1: Variants**
- Support 5 variants: solid, outline, soft, ghost, link
- Default: solid

**REQ-BTN-2: Sizes**
- Support 5 sizes: xs, sm, md, lg, xl
- Default: md

**REQ-BTN-3: Colors**
- Support 6 colors: primary, secondary, success, warning, error, gray
- Default: primary

**REQ-BTN-4: Loading State**
- Show spinner when loading={true}
- Disable button when loading
- Spinner inherits button color

**REQ-BTN-5: Disabled State**
- Visual disabled state (opacity-50)
- Cursor not-allowed
- No events when disabled

**REQ-BTN-6: Icon Support**
- Leading icon slot
- Trailing icon slot
- Icon-only mode (no text)

**REQ-BTN-7: Block Mode**
- Full-width button (w-full)
- Optional block prop

**Acceptance Criteria**:
```
GIVEN Button component
WHEN <.button variant="outline" size="lg" color="success" loading={@saving}>
  Save
</.button>
THEN button renders with:
  - Outline variant styling
  - Large size (px-5 py-2.5 text-lg)
  - Success color (border-success-500, text-success-500)
  - Spinner visible (if @saving true)
  - Button disabled (if @saving true)
```

---

### Input Component

**REQ-INP-1: Types**
- Support HTML5 types: text, email, password, number, tel, url, search
- Default: text

**REQ-INP-2: Sizes**
- Support 3 sizes: sm, md, lg
- Default: md

**REQ-INP-3: Leading/Trailing**
- Leading icon/text slot
- Trailing icon/text slot

**REQ-INP-4: Validation**
- Phoenix.HTML.Form integration
- Show errors below input
- Error state styling (border-error-500)

**REQ-INP-5: Disabled/Readonly**
- Disabled state (no input, opacity-50)
- Readonly state (no edit, normal opacity)

**Acceptance Criteria**:
```
GIVEN Input component
WHEN <.input field={@form[:email]} type="email" size="lg" />
THEN input renders with:
  - Email validation
  - Large size styling
  - Error message if validation fails
  - Correct name attribute (user[email])
```

---

### Modal Component

**REQ-MOD-1: Open/Close**
- Show/hide via assign or LiveView.JS
- Close on overlay click
- Close on Escape key

**REQ-MOD-2: Sizes**
- Support 4 sizes: sm, md, lg, xl
- Default: md

**REQ-MOD-3: Slots**
- Header slot
- Body slot (default)
- Footer slot

**REQ-MOD-4: Focus Trap**
- Tab key cycles within modal
- Focus returns to trigger on close

**REQ-MOD-5: Accessibility**
- ARIA role="dialog"
- ARIA aria-modal="true"
- ARIA aria-labelledby (header)

**Acceptance Criteria**:
```
GIVEN Modal component
WHEN <.modal id="confirm" show={@show} size="lg">
  <:header>Confirm Action</:header>
  Are you sure?
  <:footer>
    <.button phx-click={hide_modal("confirm")}>Cancel</.button>
    <.button phx-click="confirm">OK</.button>
  </:footer>
</.modal>
THEN modal:
  - Shows when @show true
  - Large size (max-w-2xl)
  - Header renders with ID
  - Footer buttons functional
  - Closes on overlay click or Escape
```

---

### Dropdown Component

**REQ-DRP-1: Trigger**
- Custom trigger slot
- Click to toggle

**REQ-DRP-2: Positioning**
- Support positions: bottom-start, bottom-end, top-start, top-end
- Default: bottom-start

**REQ-DRP-3: Click Outside**
- Close when clicking outside dropdown
- Alpine.js x-on:click.outside

**REQ-DRP-4: Items**
- Support dropdown items (links, buttons, dividers)
- Keyboard navigation (Arrow keys)

**Acceptance Criteria**:
```
GIVEN Dropdown component
WHEN <.dropdown id="user-menu" position="bottom-end">
  <:trigger>
    <.button>Menu</.button>
  </:trigger>
  <.dropdown_item navigate={~p"/profile"}>Profile</.dropdown_item>
  <.dropdown_item navigate={~p"/settings"}>Settings</.dropdown_item>
  <.dropdown_divider />
  <.dropdown_item navigate={~p"/logout"}>Logout</.dropdown_item>
</.dropdown>
THEN dropdown:
  - Opens on trigger click
  - Positions at bottom-end
  - Closes on click outside
  - Items navigable via keyboard
```

---

### Table Component

**REQ-TBL-1: Columns**
- Define columns with key, label, sortable
- Custom cell rendering

**REQ-TBL-2: Sorting**
- Click column header to sort
- Ascending/descending toggle

**REQ-TBL-3: Pagination**
- Built-in pagination component
- Configurable page size

**REQ-TBL-4: Selection**
- Checkbox column (optional)
- Select all functionality

**Acceptance Criteria**:
```
GIVEN Table component
WHEN <.table rows={@users} sortable>
  <:column key={:name} label="Name" sortable />
  <:column key={:email} label="Email" />
  <:column key={:created_at} label="Created">
    <%= Calendar.strftime(@row.created_at, "%Y-%m-%d") %>
  </:column>
</.table>
THEN table:
  - Renders users data
  - Name column sortable (click header)
  - Email column not sortable
  - Created column uses custom rendering
```

---

## 4. Integration Requirements

### INT-1: xtweak_web Integration

**INT-1.1: Import Components**
- **Requirement**: Import via `use XTweakUI`
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN xtweak_web app
  WHEN web.ex includes "use XTweakUI"
  THEN all components available in LiveViews/templates
  AND no manual imports required
  ```

**INT-1.2: Theme Configuration**
- **Requirement**: Configure theme in config/config.exs
- **Priority**: 🟡 High
- **Acceptance Criteria**:
  ```
  GIVEN config/config.exs with xtweak_ui theme
  WHEN app starts
  THEN components use configured theme
  AND theme overrides defaults
  ```

**INT-1.3: Asset Pipeline Integration**
- **Requirement**: CSS served from xtweak_ui app
- **Priority**: 🔴 Critical
- **Acceptance Criteria**:
  ```
  GIVEN xtweak_web layout
  WHEN includes <link rel="stylesheet" href={~p"/assets/xtweak_ui.css"}>
  THEN xtweak_ui CSS loads
  AND components styled correctly
  ```

**INT-1.4: Showcase Route**
- **Requirement**: /showcase route accessible
- **Priority**: 🟢 Medium
- **Acceptance Criteria**:
  ```
  GIVEN xtweak_web running
  WHEN navigating to /showcase
  THEN showcase page loads
  AND all components demonstrated
  ```

---

### INT-2: Hex.pm Publication (Phase 4)

**INT-2.1: Package Metadata**
- **Requirement**: Complete Hex package metadata
- **Priority**: 🟡 High (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN mix.exs package/0 function
  WHEN inspected
  THEN description present
  AND maintainers listed
  AND licenses specified (MIT)
  AND links present (GitHub, docs, changelog)
  ```

**INT-2.2: README**
- **Requirement**: Comprehensive README.md
- **Priority**: 🟡 High (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN README.md
  WHEN viewed
  THEN installation instructions present
  AND quick start example present
  AND feature list present
  AND documentation links present
  ```

**INT-2.3: CHANGELOG**
- **Requirement**: Semantic versioning changelog
- **Priority**: 🟡 High (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN CHANGELOG.md
  WHEN viewed
  THEN follows Keep a Changelog format
  AND versions use semantic versioning
  AND all notable changes documented
  ```

**INT-2.4: LICENSE**
- **Requirement**: MIT license file
- **Priority**: 🔴 Critical (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN LICENSE file
  WHEN viewed
  THEN MIT license text present
  AND copyright holder correct (Peter Fodor)
  AND year correct (2025)
  ```

**INT-2.5: ExDoc Published**
- **Requirement**: Documentation on hexdocs.pm
- **Priority**: 🟡 High (Phase 4)
- **Acceptance Criteria**:
  ```
  GIVEN package published to Hex.pm
  WHEN docs generated
  THEN hexdocs.pm/xtweak_ui accessible
  AND all modules documented
  AND guides present
  ```

---

## 5. Constraints & Assumptions

### Constraints

**C-1: Technology Stack**
- Must use Elixir 1.19.1+
- Must use Phoenix 1.8+
- Must use Phoenix LiveView 1.1+
- Must use Tailwind CSS 3.4.3+ (Phase 1-2)

**C-2: Pure Tailwind CSS Requirement**
- xTweak UI components MUST use pure Tailwind utilities only
- NO component framework dependencies (DaisyUI, Flowbite, etc.)
- Custom CSS variables for theming (runtime-switchable)
- Rationale: Zero dependencies, matches Nuxt UI philosophy, lightweight bundle

**C-3: Component Approach**
- Cannot reuse existing Button/Card/Alert/Modal components
- Must implement fresh Nuxt UI ports
- Must match Nuxt UI API where possible

**C-4: Browser Support**
- Must support last 2 versions of Chrome, Edge, Firefox, Safari
- No IE11 support required
- Mobile browsers (iOS Safari, Chrome Android) supported

**C-5: Accessibility**
- Must meet WCAG AA standards (not AAA)
- Must support keyboard navigation
- Must work with screen readers

---

### Assumptions

**A-1: Developer Familiarity**
- Developers are familiar with Phoenix LiveView
- Developers understand Phoenix.Component API
- Developers can read Nuxt UI documentation

**A-2: Nuxt UI Stability**
- Nuxt UI API is stable (no major breaking changes during 6-month development)
- Nuxt UI MCP Server remains available
- Nuxt UI documentation is accurate

**A-3: MCP Tool Availability**
- Nuxt UI MCP Server provides accurate documentation
- Tidewave MCP Server available for Elixir/Phoenix verification
- Context7 MCP Server available for other libraries

**A-4: Tailwind Purging**
- Tailwind correctly identifies used classes
- Content paths configured correctly
- No over-purging of dynamic classes

**A-5: Performance Targets**
- Performance targets (< 100ms render, < 80KB CSS) are realistic
- Modern browsers handle CSS variables efficiently
- OKLCH colors render correctly in all browsers

**A-6: Testing Infrastructure**
- Playwright MCP available for visual regression
- CI/CD (GitHub Actions) available
- Sufficient test coverage achievable in timeline

**A-7: Community Adoption**
- Phoenix/LiveView community interested in component library
- Nuxt UI-style API familiar to Vue developers migrating to Elixir
- Open source release will attract contributors

---

## Approval Checklist

- [ ] All functional requirements reviewed by Tech Lead
- [ ] All non-functional requirements reviewed by QA Lead
- [ ] Component-specific requirements reviewed by Product Lead
- [ ] Integration requirements reviewed by DevOps Lead
- [ ] Constraints and assumptions validated
- [ ] Stakeholder sign-off obtained

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-10-29 | 1.0.0 | Initial requirements document | Claude (Sonnet 4.5) |

---

**Document Status**: ✅ Ready for Review
**Next Update**: End of Phase 1 (Week 4)
**Maintained By**: Product Lead + Tech Lead

**Related Documents**:
- [01-technical-specification.md](./01-technical-specification.md) - Technical research
- [03-architecture.md](./03-architecture.md) - System architecture
- [04-component-inventory.md](./04-component-inventory.md) - Component list
- [07-testing-strategy.md](./07-testing-strategy.md) - QA approach
