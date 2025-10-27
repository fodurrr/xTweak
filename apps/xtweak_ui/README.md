# XTweakUI

Reusable Phoenix LiveView component library for the xTweak infrastructure template.

## Description

This app contains shared UI components built with Phoenix LiveView and styled with DaisyUI. These components provide a consistent design system across all xTweak web applications.

## Features

- **Reusable Components**: Button, Card, Modal, Alert, and more
- **DaisyUI Integration**: Semantic CSS classes with theme support
- **LiveView Native**: Built for Phoenix LiveView with slots and assigns
- **Type-Safe**: Leverages Phoenix.Component for compile-time validation
- **Accessible**: ARIA attributes and keyboard navigation included

## Components

### Button
Flexible button component with multiple variants and sizes.

```elixir
<.button variant="primary" size="lg">
  Click Me
</.button>
```

**Variants**: primary, secondary, accent, ghost, link, info, success, warning, error
**Sizes**: xs, sm, md (default), lg

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

Components use DaisyUI theme variables. Customize in your `tailwind.config.js`:

```javascript
module.exports = {
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#570df8",
          "secondary": "#f000b8",
          // ... more colors
        },
      },
    ],
  },
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
3. **Support DaisyUI variants** where applicable
4. **Include documentation** with examples
5. **Add tests** for component rendering
6. **Follow accessibility** best practices (ARIA, keyboard nav)

## Dependencies

- **Phoenix.Component** - Component framework
- **Phoenix.LiveView** - Real-time updates
- **DaisyUI** - CSS component library
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
5. Follow DaisyUI naming conventions

---

**Note**: This component library is designed for the xTweak infrastructure template. Adapt and extend it to fit your project's needs.
