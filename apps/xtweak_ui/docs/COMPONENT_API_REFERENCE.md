# xTweak UI Component API Reference

Complete API documentation for all xTweak UI components. Each component lists all available props, slots, and examples.

---

## Table of Contents

1. [Button](#button)
2. [Badge](#badge)
3. [Avatar](#avatar)
4. [Card](#card)
5. [Alert](#alert)
6. [Divider](#divider)

---

## Button

**Module**: `XTweakUI.Components.Button`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/button.ex`

Versatile button component with multiple variants, colors, sizes, and states.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | string | `"solid"` | Visual style: `solid`, `outline`, `soft`, `ghost`, `link` |
| `color` | string | `"primary"` | Color scheme: `primary`, `secondary`, `success`, `warning`, `error`, `neutral` |
| `size` | string | `"md"` | Size: `xs`, `sm`, `md`, `lg`, `xl` |
| `loading` | boolean | `false` | Show loading spinner (disables interaction) |
| `disabled` | boolean | `false` | Disable button |
| `icon` | string | `nil` | Hero icon name for leading icon |
| `trailing_icon` | string | `nil` | Hero icon name for trailing icon |
| `block` | boolean | `false` | Full width button |
| `square` | boolean | `false` | Icon-only button (no text) |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Slots

| Slot | Required | Description |
|------|----------|-------------|
| `:inner_block` | No | Button text/content |

### Examples

```heex
<!-- Basic button -->
<.button>Click me</.button>

<!-- With color and variant -->
<.button color="success" variant="outline">
  Save
</.button>

<!-- With icon -->
<.button icon="hero-check" color="primary">
  Confirm
</.button>

<!-- Loading state -->
<.button loading>Saving...</.button>

<!-- Disabled button -->
<.button disabled>Cannot click</.button>

<!-- Full width -->
<.button block variant="soft">
  Full Width Action
</.button>

<!-- Icon-only (square) -->
<.button square icon="hero-heart" size="lg" />

<!-- Trailing icon -->
<.button trailing_icon="hero-arrow-right">
  Next
</.button>
```

### Accessibility

- Semantic `<button>` element
- Proper focus management
- Loading state shows visual feedback
- Disabled state prevents interaction
- Text content or aria-label for screen readers

---

## Badge

**Module**: `XTweakUI.Components.Badge`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/badge.ex`

Compact component for labels, status indicators, and counts.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | string | `"solid"` | Style: `solid`, `outline`, `soft`, `subtle` |
| `color` | string | `"gray"` | Color: `gray`, `primary`, `success`, `warning`, `error` |
| `size` | string | `"md"` | Size: `xs`, `sm`, `md`, `lg` |
| `label` | string | `nil` | Badge text (alternative to inner_block) |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Slots

| Slot | Required | Description |
|------|----------|-------------|
| `:inner_block` | No | Badge content |

### Examples

```heex
<!-- Simple badge -->
<.badge>New</.badge>

<!-- With color -->
<.badge color="success">Active</.badge>

<!-- With variant -->
<.badge variant="outline" color="warning">
  Pending
</.badge>

<!-- Size variants -->
<.badge size="xs">3</.badge>
<.badge size="sm">10</.badge>
<.badge size="lg">99+</.badge>

<!-- Status indicators -->
<.badge color="success" variant="soft">Active</.badge>
<.badge color="error" variant="soft">Inactive</.badge>

<!-- Tags -->
<.badge variant="outline" color="primary">Feature</.badge>
<.badge variant="outline" color="warning">Enhancement</.badge>

<!-- With label attribute -->
<.badge label="Featured" color="primary" />

<!-- Combined use -->
<div class="flex items-center gap-2">
  <span>Messages</span>
  <.badge color="primary">5</.badge>
</div>
```

### Accessibility

- Screen-reader compatible
- Proper color contrast (WCAG AA)
- Semantic HTML structure
- Color + additional context (not color alone)

---

## Avatar

**Module**: `XTweakUI.Components.Avatar`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/avatar.ex`

User profile image with intelligent fallback support.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `src` | string | `nil` | Image URL to display |
| `alt` | string | `nil` | Alt text or name for initials generation |
| `text` | string | `nil` | Custom text fallback (overrides alt) |
| `icon` | string | `nil` | Hero icon name for fallback |
| `size` | string | `"md"` | Size: `3xs`, `2xs`, `xs`, `sm`, `md`, `lg`, `xl`, `2xl`, `3xl` |
| `chip` | map | `nil` | Status indicator (keys: `color`, `position`) |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Chip Options

**Color**: `"success"`, `"warning"`, `"error"`, `"gray"`, `"primary"`, etc.
**Position**: `"top-left"`, `"top-right"`, `"bottom-left"`, `"bottom-right"`

### Examples

```heex
<!-- With image -->
<.avatar src="https://github.com/user.png" alt="User Name" />

<!-- With image and status chip -->
<.avatar
  src="https://github.com/user.png"
  alt="User Name"
  size="lg"
  chip={%{color: "success", position: "bottom-right"}}
/>

<!-- Initials fallback (from alt) -->
<.avatar alt="John Doe" size="md" />

<!-- Custom text -->
<.avatar text="AB" size="lg" />
<.avatar text="+5" size="md" />

<!-- Icon fallback -->
<.avatar icon="hero-user" />
<.avatar icon="hero-user-group" size="xl" />

<!-- Size variants -->
<.avatar alt="3XS" size="3xs" />
<.avatar alt="XS" size="xs" />
<.avatar alt="MD" size="md" />
<.avatar alt="XL" size="xl" />
<.avatar alt="3XL" size="3xl" />

<!-- Status indicators -->
<.avatar alt="User" chip={%{color: "success", position: "bottom-right"}} />
<.avatar alt="User" chip={%{color: "warning", position: "top-right"}} />
<.avatar alt="User" chip={%{color: "error", position: "bottom-left"}} />

<!-- User profile -->
<div class="flex items-center gap-3">
  <.avatar alt="John Doe" size="lg" />
  <div>
    <p class="font-medium">John Doe</p>
    <p class="text-sm text-gray-500">john@example.com</p>
  </div>
</div>

<!-- Avatar group -->
<div class="flex -space-x-2">
  <.avatar alt="User 1" class="ring-2 ring-white" />
  <.avatar alt="User 2" class="ring-2 ring-white" />
  <.avatar alt="User 3" class="ring-2 ring-white" />
  <.avatar text="+5" class="ring-2 ring-white" />
</div>
```

### Fallback Priority

1. **Image** (`src` prop): Displays if valid URL
2. **Text** (`text` prop): Displays custom text
3. **Initials** (`alt` prop): Generates initials from name
4. **Icon** (`icon` prop): Displays Hero icon
5. **Default**: Gray placeholder

### Accessibility

- Alt text for images (required for semantics)
- Proper initials generation from names
- Icon fallbacks are decorative
- Accessible color indicator for status chips

---

## Card

**Module**: `XTweakUI.Components.Card`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/card.ex`

Container component for grouping related content with optional sections.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | string | `"outline"` | Style: `outline`, `solid`, `soft`, `subtle` |
| `padding` | string | `"md"` | Padding: `none`, `sm`, `md`, `lg` |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Slots

| Slot | Required | Description |
|------|----------|-------------|
| `:header` | No | Card header (optional) |
| `:inner_block` | Yes | Card body (main content) |
| `:footer` | No | Card footer (optional) |

### Examples

```heex
<!-- Basic card -->
<.card>
  <p>Simple card content</p>
</.card>

<!-- Card with header -->
<.card>
  <:header>
    <h3>Card Title</h3>
  </:header>
  <p>Body content here</p>
</.card>

<!-- Card with footer -->
<.card>
  <p>Content with actions</p>
  <:footer>
    <div class="flex justify-end gap-2">
      <.button variant="outline" size="sm">Cancel</.button>
      <.button size="sm">Save</.button>
    </div>
  </:footer>
</.card>

<!-- Full card (header + body + footer) -->
<.card>
  <:header>
    <div class="flex justify-between items-center">
      <h3>User Info</h3>
      <.badge color="success">Active</.badge>
    </div>
  </:header>
  <div class="space-y-3">
    <div class="flex items-center gap-3">
      <.avatar alt="John Doe" size="lg" />
      <div>
        <p class="font-medium">John Doe</p>
        <p class="text-sm text-gray-500">john@example.com</p>
      </div>
    </div>
  </div>
  <:footer>
    <div class="flex gap-2">
      <.button variant="outline" size="sm">View Profile</.button>
      <.button size="sm">Message</.button>
    </div>
  </:footer>
</.card>

<!-- Variant examples -->
<.card variant="outline">Outline card</.card>
<.card variant="solid">Solid card</.card>
<.card variant="soft">Soft card</.card>
<.card variant="subtle">Subtle card</.card>

<!-- Padding examples -->
<.card padding="sm">Small padding</.card>
<.card padding="md">Medium padding (default)</.card>
<.card padding="lg">Large padding</.card>
<.card padding="none">
  <img src="/image.jpg" class="w-full" />
  <div class="p-4">No padding container</div>
</.card>

<!-- Dashboard card -->
<.card>
  <:header>
    <div class="flex justify-between">
      <h4 class="font-semibold">Total Revenue</h4>
      <.badge color="success" variant="soft">+12%</.badge>
    </div>
  </:header>
  <div>
    <p class="text-3xl font-bold">$45,231</p>
    <p class="text-sm text-gray-500">vs. $40,391 last month</p>
  </div>
</.card>

<!-- Article card -->
<.card>
  <:header>
    <div class="flex gap-2">
      <.badge color="primary" size="xs">Featured</.badge>
      <.badge color="gray" size="xs" variant="outline">Article</.badge>
    </div>
  </:header>
  <h4 class="text-lg font-semibold mb-2">Getting Started with Phoenix</h4>
  <p class="text-sm text-gray-600">Learn how to build modern web applications...</p>
  <:footer>
    <div class="text-sm text-gray-500">
      <span>5 min read</span>
      <span>Jan 15, 2025</span>
    </div>
  </:footer>
</.card>
```

### Accessibility

- Semantic HTML structure
- Proper heading hierarchy
- Clear section separation
- Accessible form controls in cards

---

## Alert

**Module**: `XTweakUI.Components.Alert`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/alert.ex`

Contextual feedback messages with accessibility features.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `color` | string | `"info"` | Severity: `info`, `success`, `warning`, `error`, `primary`, `secondary`, `neutral` |
| `variant` | string | `"soft"` | Style: `soft`, `solid`, `outline`, `subtle` |
| `orientation` | string | `"vertical"` | Layout: `vertical` (actions below), `horizontal` (actions inline) |
| `icon` | string | `nil` | Custom Hero icon (defaults per severity) |
| `close` | boolean | `false` | Show close button |
| `close_icon` | string | `"hero-x-mark"` | Custom close icon |
| `on_close` | string/function | `nil` | JS command or callback for close |
| `id` | string | `nil` | Unique ID for dismissible state tracking |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Slots

| Slot | Required | Description |
|------|----------|-------------|
| `:title` | No | Alert heading |
| `:inner_block` | No | Alert description/body |
| `:actions` | No | Action buttons or links |

### Default Icons

- **info**: `hero-information-circle`
- **success**: `hero-check-circle`
- **warning**: `hero-exclamation-triangle`
- **error**: `hero-exclamation-circle`

### Examples

```heex
<!-- Simple alert -->
<.alert color="info">
  Informational message.
</.alert>

<!-- Alert with title -->
<.alert color="success">
  <:title>Success!</:title>
  Your changes have been saved.
</.alert>

<!-- Alert with title and description -->
<.alert color="warning">
  <:title>Warning</:title>
  This action cannot be undone.
</.alert>

<!-- Alert with actions (vertical) -->
<.alert color="warning">
  <:title>Update Available</:title>
  <:description>
    A new version is available. Update now?
  </:description>
  <:actions>
    <.button size="xs" variant="soft">Skip</.button>
    <.button size="xs" color="warning">Update</.button>
  </:actions>
</.alert>

<!-- Horizontal layout with actions -->
<.alert color="info" orientation="horizontal">
  <:title>New Feature</:title>
  Check out our latest updates!
  <:actions>
    <.button size="xs" variant="link">Learn more →</.button>
  </:actions>
</.alert>

<!-- Dismissible alert -->
<.alert color="success" close id="success-1">
  <:title>Success!</:title>
  Your profile has been updated.
</.alert>

<!-- Custom icon -->
<.alert color="primary" icon="hero-rocket-launch">
  <:title>New Feature!</:title>
  Exciting features are now available.
</.alert>

<!-- Severity variants -->
<.alert color="info">Information</.alert>
<.alert color="success">Success</.alert>
<.alert color="warning">Warning</.alert>
<.alert color="error">Error</.alert>

<!-- Style variants -->
<.alert color="info" variant="soft">Soft style</.alert>
<.alert color="info" variant="solid">Solid style</.alert>
<.alert color="info" variant="outline">Outline style</.alert>
<.alert color="info" variant="subtle">Subtle style</.alert>

<!-- Form validation error -->
<.alert color="error" variant="soft">
  <:title>Validation Error</:title>
  <ul class="list-disc list-inside mt-2">
    <li>Email is required</li>
    <li>Password must be 8+ characters</li>
  </ul>
</.alert>

<!-- Promotional banner -->
<.alert color="info" variant="outline" orientation="horizontal">
  🎉 New year sale! Get 20% off premium plans.
  <:actions>
    <.button size="xs" variant="link">Shop now →</.button>
  </:actions>
</.alert>

<!-- With custom ID for state tracking -->
<.alert id="banner-2025" color="info" close>
  Welcome to 2025! We're excited to have you here.
</.alert>
```

### Accessibility Features

| Feature | Implementation |
|---------|-----------------|
| **Semantic role** | `role="alert"` on all alerts |
| **Live regions** | `aria-live="polite"` for info/success (non-urgent) |
| | `aria-live="assertive"` for warning/error (urgent) |
| **Close button** | `aria-label="Close alert"` |
| **Icons** | Decorative (`aria-hidden="true"`) with text context |
| **Color usage** | Icons + text (not color alone) for distinction |
| **Keyboard access** | Full keyboard support for actions |

---

## Divider

**Module**: `XTweakUI.Components.Divider`
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/divider.ex`

Visual separator for content (horizontal or vertical).

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `orientation` | string | `"horizontal"` | Direction: `horizontal`, `vertical` |
| `label` | string | `nil` | Text to display in divider center |
| `icon` | string | `nil` | Hero icon name (instead of label) |
| `size` | string | `"md"` | Thickness: `xs` (1px), `sm` (2px), `md` (3px), `lg` (4px), `xl` (5px) |
| `type` | string | `"solid"` | Border style: `solid`, `dashed`, `dotted` |
| `color` | string | `"neutral"` | Color: `neutral`, `primary`, `success`, `info`, `warning`, `error` |
| `class` | string | `""` | Additional CSS classes |
| `rest` | map | `{}` | Additional HTML attributes |

### Examples

```heex
<!-- Basic horizontal divider -->
<.divider />

<!-- With label -->
<.divider label="OR" />
<.divider label="Section 1" />

<!-- With icon -->
<.divider icon="hero-star" />

<!-- Size variants -->
<.divider size="xs" />
<.divider size="sm" />
<.divider size="md" />
<.divider size="lg" />
<.divider size="xl" />

<!-- Border type variants -->
<.divider type="solid" />
<.divider type="dashed" />
<.divider type="dotted" />

<!-- Color variants -->
<.divider color="neutral" />
<.divider color="primary" />
<.divider color="success" />
<.divider color="warning" />
<.divider color="error" />

<!-- Combined styles -->
<.divider label="Primary" color="primary" size="lg" />
<.divider label="Warning" color="warning" type="dashed" />
<.divider icon="hero-heart" color="error" size="md" />

<!-- Vertical divider (requires container height) -->
<div class="flex items-center h-32 gap-4">
  <p>Left</p>
  <.divider orientation="vertical" class="h-full" />
  <p>Right</p>
</div>

<!-- Vertical with label -->
<div class="flex items-center h-48 gap-6">
  <div>Section 1</div>
  <.divider orientation="vertical" label="OR" class="h-full" />
  <div>Section 2</div>
</div>

<!-- Form sections -->
<.divider label="Personal Information" color="primary" />
<form class="space-y-4">
  <!-- Name and email fields -->
</form>
<.divider label="Address" color="primary" />
<form class="space-y-4">
  <!-- Address fields -->
</form>

<!-- Login options -->
<.button block variant="outline">Sign in with Google</.button>
<.button block variant="outline">Sign in with GitHub</.button>
<.divider label="OR" />
<!-- Email/password form -->

<!-- List separation -->
<.divider />
<div class="p-4">Item 1</div>
<.divider />
<div class="p-4">Item 2</div>

<!-- Card sections -->
<.card padding="none">
  <div class="p-6">Section 1</div>
  <.divider />
  <div class="p-6">Section 2</div>
</.card>
```

### Accessibility

- Semantic `<hr>` element for horizontal dividers
- Proper spacing around dividers
- Text labels are readable
- Icon fallbacks with clear visual distinction

---

## Prop Type Reference

### Common Types

| Type | Examples |
|------|----------|
| **string** | `color="primary"`, `variant="solid"` |
| **boolean** | `disabled`, `loading`, `close` |
| **map** | `chip={%{color: "success", position: "bottom-right"}}` |

### Color Values

**Primary Colors**: `primary`, `secondary`
**Status Colors**: `success`, `warning`, `error`, `info`
**Neutral**: `gray`, `neutral`

### Size Values

**Compact**: `xs`, `sm`
**Standard**: `md`
**Large**: `lg`, `xl`
**Extra Large**: `2xl`, `3xl`

### Variant Values

**Main**: `solid`, `outline`, `soft`, `ghost`, `link`
**Alternative**: `subtle` (Badge, Card, Alert, Divider)

---

## Global Attributes

All components accept standard HTML attributes via the `rest` parameter:

```heex
<!-- Data attributes -->
<.badge data-test-id="status-badge">Active</.badge>

<!-- Event listeners -->
<.button phx-click="handle_click">Click</.button>

<!-- Other HTML attributes -->
<.card id="main-card" data-toggle="modal">
  Content
</.card>
```

---

## CSS Classes

All components accept custom CSS classes:

```heex
<!-- Custom styling -->
<.button class="custom-button-style">
  Click
</.button>

<!-- Tailwind utilities -->
<.badge class="shadow-lg rounded-full">
  Badge
</.badge>
```

---

## Testing

Each component has comprehensive tests:

```bash
# Run all component tests
mix test apps/xtweak_ui/test/xtweak_ui/components/

# Run specific component tests
mix test apps/xtweak_ui/test/xtweak_ui/components/badge_test.exs
```

See test files for usage examples and edge cases.

---

## Additional Resources

- **Showcase**: `http://localhost:4000/showcase` (interactive demo)
- **Module Docs**: Use `iex> h XTweakUI.Components.ComponentName.component`
- **Nuxt UI Inspiration**: https://ui.nuxt.com/
- **Hero Icons**: https://heroicons.com/
- **Tailwind CSS**: https://tailwindcss.com/

---

## Changelog

### Sprint 2 (v0.2.0)
- Added Badge component
- Added Avatar component
- Added Card component
- Added Alert component (with accessibility features)
- Added Divider component

### Sprint 1 (v0.1.0)
- Initial Button component
- Theme system (light/dark mode)
- Tailwind CSS integration

---

**Last Updated**: November 1, 2025
**API Stability**: Experimental (subject to change)
