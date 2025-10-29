# xTweak UI

Component library for Phoenix LiveView, inspired by Nuxt UI.

## Description

A production-ready UI component library for Phoenix LiveView applications. xTweak UI ports the elegant API and design patterns from [Nuxt UI](https://ui.nuxt.com/) to the Elixir/Phoenix ecosystem, providing 100+ components with a consistent, modern design system.

## Features

- **100+ Components**: Comprehensive library covering all common UI patterns
- **Nuxt UI-Inspired API**: Familiar, intuitive component interfaces
- **Pure Tailwind CSS**: Utility-first CSS with OKLCH color space for perceptual uniformity
- **Theme System**: Centralized theming with CSS variables (inspired by Nuxt UI's app.config.ts)
- **Dark Mode**: Built-in light/dark theme support via data attributes
- **LiveView Native**: Built specifically for Phoenix LiveView with slots and assigns
- **Type-Safe**: Leverages Phoenix.Component for compile-time validation
- **Accessible**: WCAG AA compliant with ARIA attributes and keyboard navigation
- **ExDoc Documentation**: Comprehensive documentation with examples

## Components

### Sprint 1: Core Components (Completed)

#### Button
Full-featured button component with Nuxt UI API compatibility.

```elixir
# Basic button
<.button>Click me</.button>

# With color and variant
<.button color="primary" variant="solid" size="md">
  Submit
</.button>

# Loading state
<.button loading>
  Submit
</.button>

# With icons (Heroicons)
<.button icon="hero-check" color="success">
  Save
</.button>

# Full width
<.button block>
  Full Width Button
</.button>
```

**Colors**: primary, secondary, neutral, success, warning, error
**Variants**: solid, outline, soft, ghost, link
**Sizes**: xs, sm, md (default), lg, xl

See the [Nuxt UI Button reference](https://ui.nuxt.com/components/button) for API inspiration.

### Card
Container component with header, body, and actions slots.

```elixir
<.card>
  <:header>Card Title</:header>
  <:body>
    Card content goes here
  </:body>
  <:actions>
    <.button>Action</.button>
  </:actions>
</.card>
```

### Modal
Dialog overlay with backdrop and close functionality.

```elixir
<.modal id="my-modal" show={@show_modal}>
  <:title>Modal Title</:title>
  <:body>
    Modal content
  </:body>
</.modal>
```

### Alert
Notification component with multiple severity levels.

```elixir
<.alert type="success">
  Operation completed successfully!
</.alert>
```

**Types**: info, success, warning, error

## Usage

### Installation

Add to your Phoenix app's dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xtweak_ui, in_umbrella: true}
  ]
end
```

### CSS Integration

xTweak UI uses a theme system based on CSS variables and Tailwind CSS. To properly integrate the styling into your Phoenix application:

#### For Umbrella Apps

**Step 1: Import Theme Variables**

In your application's CSS file, import the xTweak UI theme:

```css
/* apps/your_app/assets/css/app.css */
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

/* Import xTweak UI theme variables */
@import "../../../xtweak_ui/assets/css/theme.css";

/* Your app-specific styles below */
```

**Step 2: Configure Tailwind Content Scanning**

Update your Tailwind config to scan xTweak UI components for CSS classes:

```javascript
// apps/your_app/assets/tailwind.config.js
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/your_app_web/**/*.*ex",
    "../../xtweak_ui/lib/**/*.{ex,exs,heex}"  // Scan UI library components
  ],
  theme: {
    extend: {
      colors: {
        // Map CSS variables to Tailwind utilities
        primary: {
          50: 'var(--color-primary-50)',
          100: 'var(--color-primary-100)',
          200: 'var(--color-primary-200)',
          300: 'var(--color-primary-300)',
          400: 'var(--color-primary-400)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          700: 'var(--color-primary-700)',
          800: 'var(--color-primary-800)',
          900: 'var(--color-primary-900)',
        },
        gray: {
          50: 'var(--color-gray-50)',
          100: 'var(--color-gray-100)',
          200: 'var(--color-gray-200)',
          300: 'var(--color-gray-300)',
          400: 'var(--color-gray-400)',
          500: 'var(--color-gray-500)',
          600: 'var(--color-gray-600)',
          700: 'var(--color-gray-700)',
          800: 'var(--color-gray-800)',
          900: 'var(--color-gray-900)',
        },
        'ui-bg': {
          default: 'var(--ui-bg-default)',
          elevated: 'var(--ui-bg-elevated)',
          accented: 'var(--ui-bg-accented)',
        },
        'ui-text': {
          default: 'var(--ui-text-default)',
          dimmed: 'var(--ui-text-dimmed)',
          muted: 'var(--ui-text-muted)',
          highlighted: 'var(--ui-text-highlighted)',
        },
        'ui-border': {
          default: 'var(--ui-border-default)',
          accented: 'var(--ui-border-accented)',
        }
      }
    }
  }
}
```

**Step 3: Rebuild Assets**

```bash
cd apps/your_app/assets
npm run build
```

#### For Published Hex Package

When xTweak UI is published to Hex, use the dependency path instead:

```css
/* apps/your_app/assets/css/app.css */
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

/* Import xTweak UI theme from deps */
@import "../../../deps/xtweak_ui/assets/css/theme.css";
```

The Tailwind content configuration remains the same (paths resolve correctly for both umbrella and hex packages).

#### Why This Approach?

This integration pattern:
- ✅ **Single source of truth** - Theme variables defined once in xTweak UI
- ✅ **Tree-shaking** - Only CSS for components you use is included
- ✅ **Optimal bundle size** - Single CSS file with no duplication
- ✅ **Works everywhere** - Same pattern for umbrella projects and hex packages
- ✅ **Maintainable** - Theme updates in xTweak UI automatically reflect in your app

### Importing Components

In your LiveView module:

```elixir
defmodule MyAppWeb.MyLive do
  use MyAppWeb, :live_view
  use XTweakUI.Components

  def render(assigns) do
    ~H"""
    <.card>
      <:header>Welcome</:header>
      <:body>
        <.button variant="primary">Get Started</.button>
      </:body>
    </.card>
    """
  end
end
```

Or import globally in `my_app_web.ex`:

```elixir
defmacro live_view do
  quote do
    use Phoenix.LiveView,
      layout: {MyAppWeb.Layouts, :app}

    use XTweakUI.Components  # Add this line

    unquote(html_helpers())
  end
end
```

## Customization

### Theming

Components use CSS variable-based theming. Customize in your theme configuration via CSS variables or Elixir config:

```css
:root {
  --color-primary-500: oklch(60% 0.20 240);
  --color-secondary-500: oklch(50% 0.18 300);
  /* ... more colors */
}
```

### Extending Components

Components are defined in `/lib/xtweak_ui/components/`. To add new components:

1. Create a new file in `lib/xtweak_ui/components/`
2. Define your component using `Phoenix.Component`
3. Add it to `lib/xtweak_ui/components.ex`

Example:

```elixir
# lib/xtweak_ui/components/badge.ex
defmodule XTweakUI.Components.Badge do
  use Phoenix.Component

  attr :variant, :string, default: "neutral"
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={["badge", "badge-#{@variant}", @class]}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
```

Then expose it:

```elixir
# lib/xtweak_ui/components.ex
defmacro __using__(_opts) do
  quote do
    import XTweakUI.Components.Button
    import XTweakUI.Components.Card
    import XTweakUI.Components.Modal
    import XTweakUI.Components.Alert
    import XTweakUI.Components.Badge  # Add new component
  end
end
```

## Testing

```bash
# Run component tests
mix test apps/xtweak_ui/test

# Run specific test file
mix test apps/xtweak_ui/test/xtweak_ui/components/button_test.exs
```

## Component Guidelines

When creating new components:

1. **Use slots** for flexible content areas
2. **Provide sensible defaults** for all attributes
3. **Support Tailwind variants** where applicable
4. **Include documentation** with examples
5. **Add tests** for component rendering
6. **Follow accessibility** best practices (ARIA, keyboard nav)

## Dependencies

- **Phoenix.Component** - Component framework
- **Phoenix.LiveView** - Real-time updates
- **Tailwind CSS** - Utility classes

## Documentation

Generate component documentation:

```bash
mix docs
```

View the generated docs at `doc/index.html`.

## Contributing

When adding components:
1. Match the existing code style
2. Include comprehensive tests
3. Document all attributes and slots
4. Provide usage examples
5. Use semantic naming and clear APIs

---

**Note**: This component library is designed for the xTweak infrastructure template. Adapt and extend it to fit your project's needs.
