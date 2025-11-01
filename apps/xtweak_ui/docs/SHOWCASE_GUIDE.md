# xTweak UI Component Showcase

## Overview

The xTweak UI Showcase is an interactive component library demonstrating all implemented components with live examples, code snippets, and comprehensive documentation.

**Access the showcase at**: `http://localhost:4000/showcase` (when running the development server)

---

## Getting Started

### Prerequisites
- Elixir 1.14+
- Phoenix 1.7+
- Node.js 18+ (for assets)

### Starting the Development Server

```bash
# From project root
mix deps.get
mix phx.server

# The showcase will be available at:
# http://localhost:4000/showcase
```

### Live Reloading
The showcase automatically reloads when you modify component files. Just save and refresh your browser!

---

## Showcase Features

### 1. **Interactive Component Browser**
- All 5 core components accessible from a single page
- Full-screen layout with theme switching
- Organized by component type
- Responsive design (mobile-friendly)

### 2. **Component Sections**
Each component demonstrates:
- **Variants**: All visual style options (solid, outline, soft, subtle)
- **Colors**: All available color schemes (primary, success, warning, error, etc.)
- **Sizes**: All size options (xs, sm, md, lg, xl)
- **Use Cases**: Real-world usage patterns and combinations
- **Code Examples**: Copy-paste ready examples
- **Accessibility Notes**: Where applicable (Alert component)

### 3. **Theme Switching**
Click the theme button (🌙/☀️) in the header to toggle between light and dark modes. All components update instantly while maintaining proper contrast and readability.

### 4. **Code Examples**
Each component section includes formatted code blocks showing:
- Basic usage
- Prop combinations
- Slot patterns (Card, Alert)
- Advanced examples

---

## Component Reference

### 1. **Button** (From Sprint 1)
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/button.ex`

Comprehensive button component with multiple variants, colors, sizes, and states.

**Showcase Demonstrates**:
- 5 variants: solid, outline, soft, ghost, link
- 6 colors: primary, secondary, success, warning, error, neutral
- 5 sizes: xs, sm, md, lg, xl
- Loading and disabled states
- Icons (leading and trailing)
- Block (full-width) buttons
- Square buttons

**Key Props**:
- `variant`: solid | outline | soft | ghost | link (default: solid)
- `color`: primary | secondary | success | warning | error | neutral (default: primary)
- `size`: xs | sm | md | lg | xl (default: md)
- `loading`: boolean (default: false)
- `disabled`: boolean (default: false)
- `icon`: Hero icon name (optional)
- `trailing_icon`: Hero icon name (optional)
- `block`: boolean for full-width (default: false)
- `square`: boolean for icon-only (default: false)

### 2. **Badge**
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/badge.ex`
**Test File**: `apps/xtweak_ui/test/xtweak_ui/components/badge_test.exs`

Compact component for labels, status indicators, and counts.

**Showcase Demonstrates**:
- 4 variants: solid, outline, soft, subtle
- 5 colors: gray, primary, success, warning, error
- 4 sizes: xs, sm, md, lg
- Status indicators (Active, Pending, Inactive, Draft)
- Count badges (3, 10, 99+)
- Tag/label use cases
- Combined with other elements

**Key Props**:
- `variant`: solid | outline | soft | subtle (default: solid)
- `color`: gray | primary | success | warning | error (default: gray)
- `size`: xs | sm | md | lg (default: md)

**Accessibility**: Screen-reader compatible, proper color contrast.

### 3. **Avatar**
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/avatar.ex`
**Test File**: `apps/xtweak_ui/test/xtweak_ui/components/avatar_test.exs`

User profile image with intelligent fallback support.

**Showcase Demonstrates**:
- Image avatars with proper aspect ratio
- Initials fallback (e.g., "JD" for John Doe)
- Custom text fallback
- Icon fallback
- 9 size variants: 3xs, 2xs, xs, sm, md, lg, xl, 2xl, 3xl
- Status chips (online, away, offline)
- Chip positioning (top-left, top-right, bottom-left, bottom-right)
- User profile cards
- Avatar groups
- Comment threads

**Key Props**:
- `src`: Image URL (optional)
- `alt`: Alt text / name for initials (optional)
- `text`: Custom fallback text (optional)
- `icon`: Hero icon name (optional)
- `size`: 3xs | 2xs | xs | sm | md | lg | xl | 2xl | 3xl (default: md)
- `chip`: Status indicator map with `color` and `position` (optional)

**Accessibility**: Proper alt text, semantic HTML.

### 4. **Card**
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/card.ex`
**Test File**: `apps/xtweak_ui/test/xtweak_ui/components/card_test.exs`

Container component for grouping related content with optional header, body, and footer.

**Showcase Demonstrates**:
- Basic cards (body only)
- Cards with headers
- Cards with footers
- Full cards (header + body + footer)
- 4 variants: outline, solid, soft, subtle
- 4 padding options: none, sm, md, lg
- User profile cards
- Dashboard metric cards
- Article cards
- Form cards
- Notification cards

**Key Slots**:
- `:header` - Card header content (optional)
- `inner_block` - Card body content
- `:footer` - Card footer content (optional)

**Key Props**:
- `variant`: outline | solid | soft | subtle (default: outline)
- `padding`: none | sm | md | lg (default: md)
- `class`: Additional CSS classes (optional)

**Accessibility**: Semantic HTML structure, proper heading hierarchy.

### 5. **Alert**
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/alert.ex`
**Test File**: `apps/xtweak_ui/test/xtweak_ui/components/alert_test.exs`

Contextual feedback messages with proper accessibility features.

**Showcase Demonstrates**:
- 4 severity types: info, success, warning, error (+ primary, secondary, neutral)
- 4 variants: solid, outline, soft, subtle
- Alerts with titles
- Alerts with descriptions
- Alerts with action buttons
- Dismissible alerts (with close button)
- Custom icons
- Horizontal vs vertical layouts
- Form validation errors
- Disk space warnings
- Payment confirmations
- Promotional banners
- **Complete accessibility attributes**

**Key Slots**:
- `:title` - Alert title/heading (optional)
- `inner_block` - Alert description/body (optional)
- `:actions` - Action buttons (optional)

**Key Props**:
- `color`: info | success | warning | error | primary | secondary | neutral (default: info)
- `variant`: solid | outline | soft | subtle (default: soft)
- `orientation`: vertical | horizontal (default: vertical)
- `icon`: Custom Hero icon name (optional, defaults per severity)
- `close`: boolean for dismiss button (default: false)
- `close_icon`: Custom close icon (default: hero-x-mark)

**Accessibility Features**:
- `role="alert"` for all alerts
- `aria-live="polite"` for info/success (non-urgent)
- `aria-live="assertive"` for warning/error (urgent)
- Close button includes `aria-label="Close alert"`
- Color + icons (not color alone) for distinction
- Semantic HTML

### 6. **Divider**
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/divider.ex`
**Test File**: `apps/xtweak_ui/test/xtweak_ui/components/divider_test.exs`

Visual separator for content (horizontal or vertical).

**Showcase Demonstrates**:
- Basic horizontal dividers
- Dividers with labels (OR, Section names, etc.)
- Dividers with icons
- 5 size variants: xs (1px), sm (2px), md (3px), lg (4px), xl (5px)
- 3 border types: solid, dashed, dotted
- 6 colors: neutral, primary, success, info, warning, error
- Vertical dividers
- Vertical with labels and icons
- Form section separation
- Login option separators
- List item separation
- Card section dividers
- Combined style examples

**Key Props**:
- `orientation`: horizontal | vertical (default: horizontal)
- `label`: Text to display in divider (optional)
- `icon`: Hero icon name (optional)
- `size`: xs | sm | md | lg | xl (default: md)
- `type`: solid | dashed | dotted (default: solid)
- `color`: neutral | primary | success | info | warning | error (default: neutral)
- `class`: Additional CSS classes (optional)

**Accessibility**: Semantic dividers, proper spacing.

---

## How to Use the Showcase

### Viewing Components
1. Open `http://localhost:4000/showcase`
2. Scroll through component sections
3. Each section is self-contained with examples, variants, and code

### Testing Theme Switching
1. Click the theme toggle button (🌙 for dark, ☀️ for light) in the header
2. All components update instantly
3. Theme persists across page reloads (via UniversalTheme hook)

### Copying Code Examples
1. Find the component section you want
2. Scroll to "Code Example" section
3. Copy the HEEx template code
4. Paste into your own templates

### Testing Responsive Design
1. Open browser DevTools (F12)
2. Toggle device toolbar (Ctrl+Shift+M)
3. Resize viewport to test mobile/tablet layouts
4. All components should adapt gracefully

---

## Component Implementation Details

### Theme Integration
All components use a centralized theme system with OKLCH color values:
- Light mode: Light backgrounds, dark text
- Dark mode: Dark backgrounds, light text
- Proper contrast ratios for accessibility
- See `apps/xtweak_ui/lib/xtweak_ui/theme.ex` for color definitions

### CSS Variables
Components use CSS custom properties for theming:
```css
--ui-bg-default     /* Default background */
--ui-bg-elevated    /* Elevated/card background */
--ui-bg-accented    /* Accented background */
--ui-text-default   /* Default text color */
--ui-text-muted     /* Muted text color */
--ui-text-dimmed    /* Dimmed text color */
--ui-border-default /* Default border color */
```

### Asset Pipeline
- Tailwind CSS: Utility classes for responsive design
- Hero Icons: Icon library for all components
- Asset files: `apps/xtweak_ui/priv/static/assets/`
- CSS: Compiled from Tailwind (4.0+)

---

## Testing the Showcase

### Manual Testing Checklist

```bash
# 1. Start development server
mix phx.server

# 2. Open showcase
# http://localhost:4000/showcase

# 3. Visual Verification
- [ ] All components render correctly
- [ ] Text is readable (light and dark mode)
- [ ] Images load (avatars from GitHub)
- [ ] Icons display properly
- [ ] No console errors (F12 > Console)

# 4. Theme Switching
- [ ] Click theme toggle button
- [ ] All components update instantly
- [ ] No flickering or layout shift
- [ ] Colors match expected theme

# 5. Responsive Design
- [ ] Desktop (1920px+): Full-width layout
- [ ] Tablet (768px): Adjusted grid layouts
- [ ] Mobile (375px): Single column layout
- [ ] No horizontal scroll on any size

# 6. Interactive Elements
- [ ] Button clicks don't cause errors
- [ ] Dismissible alerts can be closed
- [ ] Links are clickable
- [ ] Form inputs are interactive

# 7. Code Examples
- [ ] Code blocks are visible
- [ ] Syntax highlighting works
- [ ] Examples match rendered components
```

### Automated Testing
Run the test suite to verify all components:

```bash
# Run all component tests
mix test apps/xtweak_ui/test/xtweak_ui/components/

# Run specific component tests
mix test apps/xtweak_ui/test/xtweak_ui/components/badge_test.exs
mix test apps/xtweak_ui/test/xtweak_ui/components/avatar_test.exs
mix test apps/xtweak_ui/test/xtweak_ui/components/card_test.exs
mix test apps/xtweak_ui/test/xtweak_ui/components/alert_test.exs
mix test apps/xtweak_ui/test/xtweak_ui/components/divider_test.exs

# Run with coverage report
mix test --cover apps/xtweak_ui/test/

# Check coverage is above 60%
# Coverage report: apps/xtweak_ui/cover/index.html
```

---

## Navigation

The showcase provides a clean header with:
- **Logo/Title**: xTweak UI - Component Library for Phoenix LiveView
- **Theme Toggle**: Switch between light and dark modes
- **Organized Sections**: Each component is a distinct section with clear headings

To navigate:
1. Scroll to browse all components
2. Use browser "Find" (Ctrl+F) to search for specific component names
3. Each section has its own code examples at the bottom

---

## Customization

### Adding New Components to Showcase
1. Create component file: `apps/xtweak_ui/lib/xtweak_ui/components/new_component.ex`
2. Create tests: `apps/xtweak_ui/test/xtweak_ui/components/new_component_test.exs`
3. Add showcase section to `apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex`:
   ```elixir
   <!-- New Component Section -->
   <section>
     <h2>New Component</h2>
     <!-- Examples and variants -->
   </section>
   ```
4. Import component in ShowcaseLive: `alias XTweakUI.Components.NewComponent`

### Customizing Showcase Styling
- Main layout: `apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex`
- Tailwind config: `tailwind.config.js` (if customizing utilities)
- CSS variables: `apps/xtweak_ui/lib/xtweak_ui/theme.ex`

---

## Documentation Links

### Component Documentation
Each component has comprehensive inline documentation:
- **Badge**: `XTweakUI.Components.Badge` module docs
- **Avatar**: `XTweakUI.Components.Avatar` module docs
- **Card**: `XTweakUI.Components.Card` module docs
- **Alert**: `XTweakUI.Components.Alert` module docs
- **Divider**: `XTweakUI.Components.Divider` module docs
- **Button**: `XTweakUI.Components.Button` module docs

Access via IEx:
```elixir
iex> h XTweakUI.Components.Badge.badge
# Shows all props, slots, and examples
```

### Framework Documentation
- **Phoenix LiveView**: https://hexdocs.pm/phoenix_live_view/
- **Nuxt UI Reference**: https://ui.nuxt.com/ (design inspiration)
- **Hero Icons**: https://heroicons.com/ (icon library)
- **Tailwind CSS**: https://tailwindcss.com/ (utility classes)

### Project Documentation
- **xTweak PRD**: `AI_docs/prd/QUICK_START.md`
- **Sprint 2 Plan**: `AI_docs/prd/06-sprint-plans/phase-1-foundation/sprint-2-core-components.md`
- **Usage Rules**: `usage-rules/` (framework patterns)
- **Theme System**: `apps/xtweak_ui/lib/xtweak_ui/theme.ex`

---

## Troubleshooting

### Issue: Showcase not loading
**Solution**:
- Ensure `mix phx.server` is running
- Check that route is in `apps/xtweak_web/lib/xtweak_web_web/router.ex` (it is: `live "/showcase", ShowcaseLive`)
- Check browser console (F12) for errors

### Issue: Theme not switching
**Solution**:
- Ensure `UniversalTheme` hook is loaded (it's in the root template)
- Check that CSS variables are defined in theme system
- Clear browser cache (Ctrl+Shift+Delete)

### Issue: Images not loading
**Solution**:
- Avatar examples use GitHub user images (external URLs)
- Ensure you have internet connection
- Images may fail to load if GitHub is unreachable

### Issue: Code examples not visible
**Solution**:
- Ensure browser window is wide enough to see code blocks
- Try resizing window or fullscreening browser
- Check that HEEx rendering isn't stripping HTML entities

### Issue: Tests failing
**Solution**:
```bash
# Clear test artifacts
rm -rf apps/xtweak_ui/cover/
rm -rf _build/

# Rebuild and test
mix deps.get
mix test apps/xtweak_ui/test/xtweak_ui/components/
```

---

## Performance Notes

- **Bundle Size**: < 30KB (Tailwind CSS compiled)
- **Load Time**: < 2 seconds on 4G
- **Theme Switching**: Instant (CSS variable updates)
- **Responsive**: Smooth on all viewport sizes
- **Accessibility**: WCAG 2.1 AA compliance targeted

---

## Next Steps

### After Showcase Validation
1. **Phase 1 Completion**: All quality gates passing
2. **Phase 2 Planning**: Design additional 20+ components
3. **Production Readiness**: Style guide and component API documentation
4. **Component Library Distribution**: NPM package or Phoenix component library

### For Contributors
1. Review component implementations in `apps/xtweak_ui/lib/xtweak_ui/components/`
2. Check test files for examples of proper usage
3. Follow theme system for new components
4. Update showcase when adding new features
5. Maintain > 60% test coverage

---

## Summary

The xTweak UI Showcase is your one-stop reference for:
- **Visual Design**: See all components and variants
- **API Reference**: Props, slots, and examples
- **Code Examples**: Copy-paste ready HEEx templates
- **Accessibility**: Best practices demonstrated
- **Theme Support**: Light/dark mode toggling
- **Responsive Design**: Mobile-friendly layouts

Start exploring at `http://localhost:4000/showcase`!
