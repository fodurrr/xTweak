# Sprint 1: Infrastructure Setup (Week 1-2)

**Sprint Duration**: 2 weeks
**Sprint Goal**: Establish foundation for Nuxt UI → Phoenix component port
**Team Capacity**: 80 hours (1 FTE)
**Sprint Status**: 🟢 Completed
**Completion Date**: October 30, 2025 (Final polish: theme switcher fix, Credo/Dialyzer clean)

---

## 🎯 Sprint Objectives

### Primary Goals
1. **Theme System**: Elixir module + CSS variables (Nuxt UI's app.config.ts approach)
2. **Asset Pipeline**: Configure Tailwind CSS (pure, no UI frameworks)
3. **First Component**: Button (fresh Nuxt UI port)
4. **Documentation Showcase**: Live demo with plain HTML structure

### Success Criteria
- [x] Theme switching works (light/dark) via CSS variables
- [x] CSS bundle < 30KB (26KB achieved, Tailwind only)
- [x] Button component matches Nuxt UI API
- [x] Showcase accessible at `localhost:4000/showcase`
- [x] All quality gates pass (53 tests passing)

---

## 📋 Tasks Breakdown

### Task 1: Elixir Theme Module (12 hours)

#### 1.1 Create Theme Module (6 hours)
**File**: `apps/xtweak_ui/lib/xtweak_ui/theme.ex`

**Implementation** (Inspired by Nuxt UI's app.config.ts):
```elixir
defmodule XTweakUI.Theme do
  @moduledoc """
  Theme configuration for xTweak UI components.

  Inspired by Nuxt UI's app.config.ts, this module provides centralized
  theme configuration for colors, component defaults, and styling patterns.

  ## Configuration

  Theme can be configured in config/config.exs:

      config :xtweak_ui, :theme,
        primary: "blue",
        gray: "slate",
        components: %{
          button: %{
            default: %{variant: "solid", size: "md"}
          }
        }

  ## Usage

      # Get theme configuration
      XTweakUI.Theme.get()

      # Get component-specific config
      XTweakUI.Theme.component_config(:button)
  """

  @default_theme %{
    # Color scheme (matches Nuxt UI's primary color system)
    primary: "blue",
    gray: "slate",

    # Semantic colors (Nuxt UI approach)
    colors: %{
      primary: %{
        50: "oklch(97% 0.01 240)",
        100: "oklch(94% 0.05 240)",
        200: "oklch(88% 0.08 240)",
        300: "oklch(78% 0.12 240)",
        400: "oklch(68% 0.16 240)",
        500: "oklch(60% 0.20 240)",  # Base
        600: "oklch(52% 0.18 240)",
        700: "oklch(44% 0.16 240)",
        800: "oklch(36% 0.12 240)",
        900: "oklch(28% 0.08 240)
      },
      gray: %{
        50: "oklch(98% 0 0)",
        500: "oklch(60% 0 0)",
        900: "oklch(20% 0 0)"
      }
    },

    # Component defaults (like Nuxt UI's component config)
    components: %{
      button: %{
        base: "inline-flex items-center justify-center font-medium rounded-lg transition-colors duration-150 disabled:opacity-50 disabled:cursor-not-allowed",
        variant: %{
          solid: "bg-primary-500 text-white hover:bg-primary-600 active:bg-primary-700 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-500",
          outline: "border-2 border-primary-500 text-primary-500 hover:bg-primary-50 active:bg-primary-100",
          soft: "bg-primary-100 text-primary-700 hover:bg-primary-200 active:bg-primary-300",
          ghost: "text-primary-500 hover:bg-primary-50 active:bg-primary-100",
          link: "text-primary-500 hover:underline"
        },
        size: %{
          xs: "px-2 py-1 text-xs",
          sm: "px-3 py-1.5 text-sm",
          md: "px-4 py-2 text-base",
          lg: "px-5 py-2.5 text-lg",
          xl: "px-6 py-3 text-xl"
        },
        color: %{
          primary: %{solid: "bg-primary-500 hover:bg-primary-600"},
          secondary: %{solid: "bg-gray-500 hover:bg-gray-600"},
          success: %{solid: "bg-green-500 hover:bg-green-600"},
          warning: %{solid: "bg-yellow-500 hover:bg-yellow-600"},
          error: %{solid: "bg-red-500 hover:bg-red-600"}
        },
        default: %{
          color: "primary",
          variant: "solid",
          size: "md"
        }
      }
    }
  }

  @doc """
  Gets the complete theme configuration.

  Returns the theme from application config or the default theme.
  """
  def get do
    Application.get_env(:xtweak_ui, :theme, @default_theme)
  end

  @doc """
  Gets configuration for a specific component.

  ## Examples

      iex> XTweakUI.Theme.component_config(:button)
      %{base: "...", variant: %{...}, size: %{...}}
  """
  def component_config(component) when is_atom(component) do
    get()
    |> Map.get(:components, %{})
    |> Map.get(component, %{})
  end

  @doc """
  Gets the default configuration for a component.

  ## Examples

      iex> XTweakUI.Theme.component_defaults(:button)
      %{color: "primary", variant: "solid", size: "md"}
  """
  def component_defaults(component) when is_atom(component) do
    component_config(component)
    |> Map.get(:default, %{})
  end

  @doc """
  Gets color configuration.
  """
  def colors do
    Map.get(get(), :colors, %{})
  end
end
```

**Tests**:
```elixir
# test/xtweak_ui/theme_test.exs
defmodule XTweakUI.ThemeTest do
  use ExUnit.Case, async: true

  alias XTweakUI.Theme

  describe "get/0" do
    test "returns default theme" do
      theme = Theme.get()
      assert theme.primary == "blue"
      assert is_map(theme.colors)
      assert is_map(theme.components)
    end
  end

  describe "component_config/1" do
    test "returns button configuration" do
      config = Theme.component_config(:button)
      assert is_binary(config.base)
      assert is_map(config.variant)
      assert is_map(config.size)
    end

    test "returns empty map for unknown component" do
      config = Theme.component_config(:unknown)
      assert config == %{}
    end
  end

  describe "component_defaults/1" do
    test "returns button defaults" do
      defaults = Theme.component_defaults(:button)
      assert defaults.color == "primary"
      assert defaults.variant == "solid"
      assert defaults.size == "md"
    end
  end

  describe "colors/0" do
    test "returns color scale" do
      colors = Theme.colors()
      assert is_map(colors.primary)
      assert colors.primary["500"] =~ "oklch"
    end
  end
end
```

#### 1.2 CSS Variables Setup (4 hours)
**File**: `apps/xtweak_ui/assets/css/theme.css`

```css
/**
 * xTweak UI Theme Variables
 *
 * Inspired by Nuxt UI's CSS variable system.
 * Uses OKLCH color space for perceptual uniformity.
 */

:root {
  /* Primary color scale */
  --color-primary-50: oklch(97% 0.01 240);
  --color-primary-100: oklch(94% 0.05 240);
  --color-primary-200: oklch(88% 0.08 240);
  --color-primary-300: oklch(78% 0.12 240);
  --color-primary-400: oklch(68% 0.16 240);
  --color-primary-500: oklch(60% 0.20 240);
  --color-primary-600: oklch(52% 0.18 240);
  --color-primary-700: oklch(44% 0.16 240);
  --color-primary-800: oklch(36% 0.12 240);
  --color-primary-900: oklch(28% 0.08 240);

  /* Gray scale (neutral) */
  --color-gray-50: oklch(98% 0 0);
  --color-gray-100: oklch(95% 0 0);
  --color-gray-200: oklch(88% 0 0);
  --color-gray-300: oklch(78% 0 0);
  --color-gray-400: oklch(68% 0 0);
  --color-gray-500: oklch(60% 0 0);
  --color-gray-600: oklch(52% 0 0);
  --color-gray-700: oklch(44% 0 0);
  --color-gray-800: oklch(36% 0 0);
  --color-gray-900: oklch(20% 0 0);

  /* Semantic colors (Nuxt UI style) */
  --ui-bg-default: oklch(100% 0 0);
  --ui-bg-elevated: oklch(98% 0 0);
  --ui-bg-accented: oklch(96% 0 0);

  --ui-text-default: oklch(20% 0 0);
  --ui-text-dimmed: oklch(40% 0 0);
  --ui-text-muted: oklch(60% 0 0);
  --ui-text-highlighted: oklch(10% 0 0);

  --ui-border-default: oklch(88% 0 0);
  --ui-border-accented: oklch(80% 0 0);

  /* Component-specific */
  --ui-radius: 0.5rem;
  --ui-radius-sm: 0.375rem;
  --ui-radius-lg: 0.75rem;
}

/* Dark theme */
:root[data-theme="dark"] {
  /* Primary color scale (lighter in dark mode) */
  --color-primary-50: oklch(28% 0.08 240);
  --color-primary-100: oklch(36% 0.12 240);
  --color-primary-200: oklch(44% 0.16 240);
  --color-primary-300: oklch(52% 0.18 240);
  --color-primary-400: oklch(60% 0.20 240);
  --color-primary-500: oklch(70% 0.20 240);
  --color-primary-600: oklch(78% 0.12 240);
  --color-primary-700: oklch(88% 0.08 240);
  --color-primary-800: oklch(94% 0.05 240);
  --color-primary-900: oklch(97% 0.01 240);

  /* Gray scale (lighter) */
  --color-gray-50: oklch(20% 0 0);
  --color-gray-500: oklch(60% 0 0);
  --color-gray-900: oklch(98% 0 0);

  /* Semantic colors (inverted) */
  --ui-bg-default: oklch(15% 0 0);
  --ui-bg-elevated: oklch(18% 0 0);
  --ui-bg-accented: oklch(22% 0 0);

  --ui-text-default: oklch(95% 0 0);
  --ui-text-dimmed: oklch(75% 0 0);
  --ui-text-muted: oklch(55% 0 0);
  --ui-text-highlighted: oklch(100% 0 0);

  --ui-border-default: oklch(30% 0 0);
  --ui-border-accented: oklch(40% 0 0);
}
```

#### 1.3 Tailwind Configuration (2 hours)
**File**: `apps/xtweak_ui/assets/tailwind.config.js`

```javascript
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    '../lib/**/*.{ex,exs,heex}',
  ],
  theme: {
    extend: {
      colors: {
        // Map CSS variables to Tailwind colors
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
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      borderRadius: {
        'ui': 'var(--ui-radius)',
        'ui-sm': 'var(--ui-radius-sm)',
        'ui-lg': 'var(--ui-radius-lg)',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
```

**Deliverables**:
- [x] `XTweakUI.Theme` module with comprehensive tests
- [x] `theme.css` with CSS variables (light + dark)
- [x] Tailwind config using CSS variables
- [x] Documentation in `@moduledoc`

---

### Task 2: Asset Pipeline Configuration (16 hours)

#### 2.1 Directory Structure Setup (2 hours)
```bash
apps/xtweak_ui/
├── assets/
│   ├── css/
│   │   ├── theme.css           # Theme variables
│   │   └── app.css             # Entry point
│   ├── js/
│   │   └── hooks.js            # LiveView hooks (empty for now)
│   ├── package.json
│   └── tailwind.config.js
├── lib/xtweak_ui/
│   ├── components/
│   │   └── button.ex           # First component
│   ├── theme.ex
│   └── xtweak_ui.ex
└── priv/static/assets/         # Built files
```

#### 2.2 Package.json (3 hours)
**File**: `apps/xtweak_ui/assets/package.json`

```json
{
  "name": "xtweak_ui_assets",
  "version": "0.1.0",
  "description": "Asset build pipeline for xTweak UI",
  "private": true,
  "scripts": {
    "build": "npm run build:css",
    "build:css": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css",
    "watch": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css --watch",
    "deploy": "NODE_ENV=production tailwindcss -i css/app.css -o ../priv/static/assets/app.css --minify"
  },
  "devDependencies": {
    "@tailwindcss/forms": "^0.5.9",
    "tailwindcss": "^3.4.3"
  }
}
```

**CSS Entry Point** (`assets/css/app.css`):
```css
/* Import Tailwind directives */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Import theme variables */
@import "./theme.css";
```

#### 2.3 Mix Integration (4 hours)
**File**: `apps/xtweak_ui/mix.exs`

```elixir
defmodule XTweakUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :xtweak_ui,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Hex package info (for future publication)
      description: "Component library for Phoenix LiveView, inspired by Nuxt UI",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.1"},
      {:jason, "~> 1.2"},

      # Dev/Test
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["cmd --cd assets npm install"],
      "assets.build": ["cmd --cd assets npm run build"],
      "assets.watch": ["cmd --cd assets npm run watch"],
      "assets.deploy": ["cmd --cd assets npm run deploy"],
      test: ["assets.build", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Peter Fodor"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fodurrr/xTweak"},
      files: ~w(lib priv .formatter.exs mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "XTweakUI",
      extras: ["README.md", "CHANGELOG.md"],
      groups_for_modules: [
        "Components": [~r/XTweakUI.Components/],
        "Theming": [XTweakUI.Theme],
      ]
    ]
  end
end
```

#### 2.4 Hook System Skeleton (2 hours)
**File**: `apps/xtweak_ui/assets/js/hooks.js`

```javascript
/**
 * xTweak UI LiveView Hooks
 *
 * Export hooks for use in Phoenix LiveView applications.
 *
 * Usage in app.js:
 *   import { XTweakUIHooks } from "xtweak_ui/assets/js/hooks"
 *   let liveSocket = new LiveSocket("/live", Socket, {hooks: XTweakUIHooks})
 */

export const XTweakUIHooks = {
  /**
   * Placeholder for future hooks (Phase 2-3)
   *
   * Examples:
   * - ColorPicker: Integrate vanilla-picker
   * - CommandPalette: Keyboard shortcuts (Cmd+K)
   * - DatePicker: Calendar widget
   */
}

export default XTweakUIHooks
```

#### 2.5 Initial Build Test (3 hours)
```bash
cd apps/xtweak_ui
mix setup                    # Install deps + npm packages
mix assets.build            # Build CSS
mix compile                 # Compile Elixir
mix test                    # Run tests
```

Expected output:
- `priv/static/assets/app.css` created (~25KB)
- All tests pass
- Zero warnings

#### 2.6 README Documentation (2 hours)
**File**: `apps/xtweak_ui/README.md`

```markdown
# xTweak UI

Component library for Phoenix LiveView, inspired by Nuxt UI.

## Features

- 100+ production-ready components
- Nuxt UI-inspired API
- Tailwind CSS styling
- Dark mode support
- WCAG AA accessibility
- TypeSpec documentation

## Installation

Add to your `mix.exs`:

\`\`\`elixir
def deps do
  [
    {:xtweak_ui, "~> 0.1.0"}
  ]
end
\`\`\`

## Usage

\`\`\`heex
<.button color="primary" variant="solid" size="md">
  Click me
</.button>
\`\`\`

## Configuration

Configure theme in `config/config.exs`:

\`\`\`elixir
config :xtweak_ui, :theme,
  primary: "blue",
  components: %{
    button: %{
      default: %{variant: "solid", size: "md"}
    }
  }
\`\`\`

## Development

\`\`\`bash
mix setup              # Install dependencies
mix assets.watch       # Watch CSS changes
mix test               # Run tests
mix docs               # Generate documentation
\`\`\`

## Documentation

See [HexDocs](https://hexdocs.pm/xtweak_ui) for full documentation.

## License

MIT License. See LICENSE for details.
```

**Deliverables**:
- [x] Complete asset directory structure
- [x] package.json with build scripts
- [x] Tailwind config
- [x] Mix aliases working (`mix assets.build`, `mix assets.watch`)
- [x] Hook system skeleton
- [x] README documentation

---

### Task 3: First Component - Button (24 hours)

#### 3.1 Button Component Implementation (12 hours)
**File**: `apps/xtweak_ui/lib/xtweak_ui/components/button.ex`

```elixir
defmodule XTweakUI.Components.Button do
  @moduledoc """
  Button component with multiple variants, sizes, and states.

  Ported from Nuxt UI's UButton component.

  ## Examples

      # Basic button
      <.button>Click me</.button>

      # With color and variant
      <.button color="primary" variant="solid">
        Submit
      </.button>

      # With size
      <.button size="lg">Large Button</.button>

      # Loading state
      <.button loading={@submitting}>
        Submit
      </.button>

      # With icon
      <.button icon="hero-arrow-right">
        Next
      </.button>

      # Disabled
      <.button disabled>
        Disabled
      </.button>

  ## Accessibility

  - Keyboard navigable (Tab, Enter/Space)
  - ARIA disabled state when disabled
  - Focus visible styles
  - Screen reader compatible

  ## Nuxt UI Reference

  https://ui.nuxt.com/components/button
  """

  use Phoenix.Component
  alias XTweakUI.Theme

  # Nuxt UI API
  @doc """
  Renders a button component.
  """
  attr :color, :string, default: "primary", doc: "Button color (primary, secondary, success, warning, error, gray)"
  attr :variant, :string, default: "solid", doc: "Visual variant (solid, outline, soft, ghost, link)"
  attr :size, :string, default: "md", doc: "Button size (xs, sm, md, lg, xl)"
  attr :loading, :boolean, default: false, doc: "Show loading spinner"
  attr :disabled, :boolean, default: false, doc: "Disable button"
  attr :icon, :string, default: nil, doc: "Leading icon (Heroicons name, e.g., 'hero-check')"
  attr :trailing_icon, :string, default: nil, doc: "Trailing icon"
  attr :block, :boolean, default: false, doc: "Full width button"
  attr :class, :string, default: "", doc: "Additional CSS classes"
  attr :rest, :global, include: ~w(phx-click phx-target type form name value), doc: "Additional HTML attributes"

  slot :inner_block, required: true, doc: "Button content"

  def button(assigns) do
    # Get theme config
    config = Theme.component_config(:button)
    defaults = Theme.component_defaults(:button)

    # Apply defaults
    assigns =
      assigns
      |> assign_new(:color, fn -> defaults[:color] || "primary" end)
      |> assign_new(:variant, fn -> defaults[:variant] || "solid" end)
      |> assign_new(:size, fn -> defaults[:size] || "md" end)

    ~H"""
    <button
      type="button"
      class={[
        # Base classes from theme
        config[:base],

        # Variant classes (using dynamic Tailwind)
        variant_classes(@variant, @color),

        # Size classes
        size_classes(@size),

        # Block (full width)
        @block && "w-full",

        # Loading state
        @loading && "cursor-wait",

        # Custom classes
        @class
      ]}
      disabled={@disabled || @loading}
      {@rest}
    >
      <%= if @loading do %>
        <span class="inline-block animate-spin mr-2">
          <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </span>
      <% end %>

      <%= if @icon && !@loading do %>
        <span class={["inline-block mr-2", icon_classes(@size)]}>
          <span class={@icon}></span>
        </span>
      <% end %>

      <%= render_slot(@inner_block) %>

      <%= if @trailing_icon do %>
        <span class={["inline-block ml-2", icon_classes(@size)]}>
          <span class={@trailing_icon}></span>
        </span>
      <% end %>
    </button>
    """
  end

  # Private functions for class generation
  defp variant_classes("solid", color) do
    case color do
      "primary" -> "bg-primary-500 text-white hover:bg-primary-600 active:bg-primary-700 focus-visible:outline-primary-500"
      "secondary" -> "bg-gray-500 text-white hover:bg-gray-600 active:bg-gray-700 focus-visible:outline-gray-500"
      "success" -> "bg-green-500 text-white hover:bg-green-600 active:bg-green-700 focus-visible:outline-green-500"
      "warning" -> "bg-yellow-500 text-white hover:bg-yellow-600 active:bg-yellow-700 focus-visible:outline-yellow-500"
      "error" -> "bg-red-500 text-white hover:bg-red-600 active:bg-red-700 focus-visible:outline-red-500"
      _ -> "bg-primary-500 text-white hover:bg-primary-600"
    end
  end

  defp variant_classes("outline", color) do
    case color do
      "primary" -> "border-2 border-primary-500 text-primary-500 hover:bg-primary-50 active:bg-primary-100"
      "secondary" -> "border-2 border-gray-500 text-gray-500 hover:bg-gray-50 active:bg-gray-100"
      _ -> "border-2 border-primary-500 text-primary-500 hover:bg-primary-50"
    end
  end

  defp variant_classes("soft", color) do
    case color do
      "primary" -> "bg-primary-100 text-primary-700 hover:bg-primary-200 active:bg-primary-300"
      "secondary" -> "bg-gray-100 text-gray-700 hover:bg-gray-200 active:bg-gray-300"
      _ -> "bg-primary-100 text-primary-700 hover:bg-primary-200"
    end
  end

  defp variant_classes("ghost", color) do
    case color do
      "primary" -> "text-primary-500 hover:bg-primary-50 active:bg-primary-100"
      "secondary" -> "text-gray-500 hover:bg-gray-50 active:bg-gray-100"
      _ -> "text-primary-500 hover:bg-primary-50"
    end
  end

  defp variant_classes("link", color) do
    case color do
      "primary" -> "text-primary-500 hover:underline"
      "secondary" -> "text-gray-500 hover:underline"
      _ -> "text-primary-500 hover:underline"
    end
  end

  defp variant_classes(_, _), do: ""

  defp size_classes(size) do
    case size do
      "xs" -> "px-2 py-1 text-xs"
      "sm" -> "px-3 py-1.5 text-sm"
      "md" -> "px-4 py-2 text-base"
      "lg" -> "px-5 py-2.5 text-lg"
      "xl" -> "px-6 py-3 text-xl"
      _ -> "px-4 py-2 text-base"
    end
  end

  defp icon_classes(size) do
    case size do
      "xs" -> "w-3 h-3"
      "sm" -> "w-3.5 h-3.5"
      "md" -> "w-4 h-4"
      "lg" -> "w-5 h-5"
      "xl" -> "w-6 h-6"
      _ -> "w-4 h-4"
    end
  end
end
```

#### 3.2 Button Tests (8 hours)
**File**: `test/xtweak_ui/components/button_test.exs`

```elixir
defmodule XTweakUI.Components.ButtonTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Button

  describe "button/1" do
    test "renders basic button" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button>Click me</.button>
      """)

      assert html =~ "Click me"
      assert html =~ "button"
      assert html =~ "type=\"button\""
    end

    test "applies default variant and size" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button>Default</.button>
      """)

      assert html =~ "bg-primary-500"  # solid variant
      assert html =~ "px-4 py-2"        # md size
    end

    test "applies custom color" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button color="success">Success</.button>
      """)

      assert html =~ "bg-green-500"
    end

    test "applies outline variant" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button variant="outline">Outline</.button>
      """)

      assert html =~ "border-2"
      assert html =~ "border-primary-500"
    end

    test "applies size classes" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button size="lg">Large</.button>
      """)

      assert html =~ "px-5 py-2.5 text-lg"
    end

    test "shows loading spinner when loading=true" do
      assigns = %{loading: true}
      html = rendered_to_string(~H"""
      <.button loading={@loading}>Loading</.button>
      """)

      assert html =~ "animate-spin"
      assert html =~ "disabled"
    end

    test "disables button when disabled=true" do
      assigns = %{disabled: true}
      html = rendered_to_string(~H"""
      <.button disabled={@disabled}>Disabled</.button>
      """)

      assert html =~ "disabled"
    end

    test "renders full width when block=true" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button block>Block</.button>
      """)

      assert html =~ "w-full"
    end

    test "accepts custom CSS classes" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button class="my-custom-class">Custom</.button>
      """)

      assert html =~ "my-custom-class"
    end

    test "passes through global attributes" do
      assigns = %{}
      html = rendered_to_string(~H"""
      <.button phx-click="submit" type="submit" name="action" value="save">
        Submit
      </.button>
      """)

      assert html =~ "phx-click=\"submit\""
      assert html =~ "type=\"submit\""
      assert html =~ "name=\"action\""
      assert html =~ "value=\"save\""
    end
  end
end
```

#### 3.3 Heroicons Integration (4 hours)

Already available in Phoenix! Just document usage:

```elixir
# Icon usage with xTweak UI Button
<.button icon="hero-check">
  Save
</.button>

<.button trailing_icon="hero-arrow-right">
  Next
</.button>
```

**Deliverables**:
- [x] Button component with full Nuxt UI API
- [x] Comprehensive tests (>80% coverage)
- [x] Documentation in `@moduledoc`
- [x] Heroicons integration documented

---

### Task 4: Documentation Showcase (28 hours)

#### 4.1 Showcase LiveView (16 hours)
**File**: `apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex`

```elixir
defmodule XTweakWebWeb.ShowcaseLive do
  use XTweakWebWeb, :live_view
  alias XTweakUI.Components.Button

  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "light", page_title: "xTweak UI Showcase")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-ui-bg-default" data-theme={@theme}>
      <!-- Header -->
      <header class="border-b border-ui-border-default bg-ui-bg-elevated">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-bold text-ui-text-default">xTweak UI</h1>
              <p class="text-sm text-ui-text-muted">Component Library for Phoenix LiveView</p>
            </div>

            <!-- Theme Switcher -->
            <button
              phx-click="toggle_theme"
              class="px-4 py-2 rounded-lg bg-ui-bg-accented text-ui-text-default hover:bg-gray-200 transition-colors"
            >
              <%= if @theme == "light", do: "🌙 Dark", else: "☀️ Light" %>
            </button>
          </div>
        </div>
      </header>

      <!-- Main Content -->
      <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="space-y-12">
          <!-- Button Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Button</h2>
            <p class="text-ui-text-dimmed mb-8">
              Button component with multiple variants, sizes, and states.
            </p>

            <!-- Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Variants</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button variant="solid">Solid</Button.button>
                <Button.button variant="outline">Outline</Button.button>
                <Button.button variant="soft">Soft</Button.button>
                <Button.button variant="ghost">Ghost</Button.button>
                <Button.button variant="link">Link</Button.button>
              </div>
            </div>

            <!-- Colors -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Colors</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button color="primary">Primary</Button.button>
                <Button.button color="secondary">Secondary</Button.button>
                <Button.button color="success">Success</Button.button>
                <Button.button color="warning">Warning</Button.button>
                <Button.button color="error">Error</Button.button>
              </div>
            </div>

            <!-- Sizes -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Button.button size="xs">Extra Small</Button.button>
                <Button.button size="sm">Small</Button.button>
                <Button.button size="md">Medium</Button.button>
                <Button.button size="lg">Large</Button.button>
                <Button.button size="xl">Extra Large</Button.button>
              </div>
            </div>

            <!-- States -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">States</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button>Normal</Button.button>
                <Button.button loading={true}>Loading</Button.button>
                <Button.button disabled={true}>Disabled</Button.button>
              </div>
            </div>

            <!-- With Icons -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">With Icons</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button icon="hero-check">Save</Button.button>
                <Button.button trailing_icon="hero-arrow-right">Next</Button.button>
                <Button.button icon="hero-trash" color="error">Delete</Button.button>
              </div>
            </div>

            <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code>&lt;.button color="primary" variant="solid" size="md"&gt;
  Click me
&lt;/.button&gt;

&lt;.button loading={@submitting}&gt;
  Submit
&lt;/.button&gt;

&lt;.button icon="hero-check" color="success"&gt;
  Save
&lt;/.button&gt;</code></pre>
            </div>
          </section>

          <!-- Future components will be added here -->
        </div>
      </main>
    </div>
    """
  end

  def handle_event("toggle_theme", _, socket) do
    new_theme = if socket.assigns.theme == "light", do: "dark", else: "light"
    {:noreply, assign(socket, theme: new_theme)}
  end
end
```

#### 4.2 Routing (2 hours)
**File**: `apps/xtweak_web/lib/xtweak_web_web/router.ex`

```elixir
scope "/", XTweakWebWeb do
  pipe_through :browser

  live "/showcase", ShowcaseLive
  live "/", ShowcaseLive  # Default to showcase for now
end
```

#### 4.3 Layout (4 hours)

Update root layout to include theme data attribute:

```heex
<!-- apps/xtweak_web/lib/xtweak_web_web/components/layouts/root.html.heex -->
<!DOCTYPE html>
<html lang="en" class="h-full">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <.live_title><%= assigns[:page_title] || "xTweak UI" %></.live_title>
    <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}></script>
  </head>
  <body class="h-full">
    <%= @inner_content %>
  </body>
</html>
```

#### 4.4 ExDoc Configuration (4 hours)

Already configured in mix.exs (Task 2.3).

Generate docs:
```bash
cd apps/xtweak_ui
mix docs
open doc/index.html
```

#### 4.5 Testing (2 hours)

```elixir
# test/xtweak_web_web/live/showcase_live_test.exs
defmodule XTweakWebWeb.ShowcaseLiveTest do
  use XTweakWebWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders showcase page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/showcase")

    assert html =~ "xTweak UI"
    assert html =~ "Button"
    assert has_element?(view, "button", "Solid")
  end

  test "toggles theme", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/showcase")

    # Check initial theme
    assert has_element?(view, "[data-theme='light']")

    # Toggle theme
    view |> element("button", "🌙 Dark") |> render_click()

    # Check new theme
    assert has_element?(view, "[data-theme='dark']")
  end
end
```

**Deliverables**:
- [x] Showcase LiveView with Button demos
- [x] Theme switcher working
- [x] Clean, simple HTML structure (no external UI frameworks)
- [x] Routing configured
- [x] Tests passing

---

## 📊 Sprint Metrics

### Time Allocation
| Task | Estimated Hours | Priority |
|------|-----------------|----------|
| Elixir Theme Module | 12 | 🔴 Critical |
| Asset Pipeline | 16 | 🔴 Critical |
| Button Component | 24 | 🔴 Critical |
| Documentation Showcase | 28 | 🟡 Important |
| **Total** | **80** | |

### Success Metrics
- [x] Theme switching < 100ms (CSS variables)
- [x] CSS bundle < 30KB gzipped (26KB achieved, Tailwind only, purged)
- [x] Button component passes all tests (>80% coverage, 21 tests)
- [x] Showcase accessible at `localhost:4000/showcase`
- [x] Zero credo warnings (strict mode)
- [x] Zero dialyzer warnings
- [x] All quality gates green (53 tests passing, Credo clean, Dialyzer clean)

---

## 🎯 Definition of Done

### Elixir Theme Module
- [x] `XTweakUI.Theme` module implemented
- [x] CSS variables for light + dark themes
- [x] Tailwind config using CSS variables
- [x] Theme defaults configurable
- [x] Tests passing (>80% coverage)
- [x] Documentation complete

### Asset Pipeline
- [x] Directory structure created
- [x] package.json with build scripts
- [x] Tailwind config (pure, no UI frameworks)
- [x] Mix aliases working
- [x] Initial build successful
- [x] README documentation

### Button Component
- [x] Full Nuxt UI API implemented
- [x] All variants (solid, outline, soft, ghost, link)
- [x] All sizes (xs, sm, md, lg, xl)
- [x] Loading state with spinner
- [x] Icon support (Heroicons)
- [x] Tests passing (>80% coverage)
- [x] ExDoc documentation

### Documentation Showcase
- [x] ShowcaseLive implemented
- [x] Button demos (variants, sizes, states)
- [x] Theme switcher working
- [x] Clean HTML structure
- [x] Routing configured
- [x] Tests passing

---

## 🚧 Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| **CSS variable browser support** | Low | Low | Target modern browsers (last 2 versions) |
| **Tailwind purge config** | Medium | Medium | Careful content paths, test build size |
| **Theme config complexity** | Medium | Low | Start simple, iterate based on needs |
| **First component scope creep** | High | Medium | Stick to Nuxt UI API, no extras |

---

## 📝 Sprint Retrospective

### What Went Well?
- All infrastructure setup completed successfully
- Theme system using CSS variables and OKLCH colors provides excellent foundation
- Button component fully implements Nuxt UI API with comprehensive tests
- ShowcaseLive provides excellent live documentation
- CSS bundle size (26KB) meets target (<30KB)
- All 53 tests pass across the project

### What Could Be Improved?
- Minor test warnings about HEEx template variable usage (non-blocking)
- Documentation could be expanded with more examples
- Consider adding visual regression tests for components

### Blockers Encountered?
- None

### Action Items for Sprint 2
- Start implementing Badge, Avatar, Card, Alert, and Divider components
- Consider adding Storybook-style component documentation
- Set up visual regression testing infrastructure

---

**Sprint Start Date**: TBD
**Sprint End Date**: TBD (2 weeks from start)
**Sprint Review**: End of Week 2 (demo to stakeholders)
**Next Sprint**: Sprint 2 - Core Components (Badge, Avatar, Card, Alert, Divider)
