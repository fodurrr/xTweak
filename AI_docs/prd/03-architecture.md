# Architecture Document: xTweak UI Component Library

**Document Version**: 1.0.0
**Date**: 2025-10-29
**Status**: ✅ Complete
**Author**: Peter Fodor (with Claude Code assistance)

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Umbrella Architecture](#2-umbrella-architecture)
3. [Component Architecture](#3-component-architecture)
4. [Theming System Architecture](#4-theming-system-architecture)
5. [Asset Pipeline Architecture](#5-asset-pipeline-architecture)
6. [JavaScript Architecture](#6-javascript-architecture)
7. [State Management](#7-state-management)
8. [Module Organization](#8-module-organization)
9. [Performance Considerations](#9-performance-considerations)
10. [Deployment Architecture](#10-deployment-architecture)

---

## 1. System Overview

### 1.1 Purpose

xTweak UI is a Phoenix component library that ports the Nuxt UI component API to Elixir/Phoenix LiveView. The architecture prioritizes:

- **API Parity**: 100% compatibility with Nuxt UI component APIs
- **Zero Dependencies**: Pure Tailwind CSS, no component frameworks (no DaisyUI)
- **Hex.pm Distribution**: Standalone package with minimal footprint
- **Developer Experience**: MCP-driven development workflow

### 1.2 Technology Stack

**Core Technologies**:
- **Elixir 1.19.1**: Language runtime
- **Phoenix 1.7+**: Web framework
- **Phoenix.Component**: Component API
- **Tailwind CSS 3.4.3+**: Styling framework (pure utilities only)
- **Alpine.js** (Phase 1): Client-side interactivity

**Build Tooling**:
- **esbuild**: JavaScript bundling
- **tailwindcss**: CSS compilation
- **Mix**: Task automation

**Development Tools**:
- **Nuxt UI MCP Server**: PRIMARY component research tool
- **Tidewave MCP**: Elixir/Phoenix verification
- **Context7 MCP**: Secondary library documentation
- **Playwright MCP**: Visual regression testing

### 1.3 Design Constraints

**CRITICAL**: No DaisyUI Dependency
- ❌ Cannot use DaisyUI classes (`btn`, `btn-primary`)
- ✅ Must use pure Tailwind utilities
- ✅ Custom CSS variables for theming
- **Rationale**: Clean API, no framework lock-in, easier UnoCSS migration later

---

## 2. Umbrella Architecture

### 2.1 Umbrella App Boundaries

```
xTweak/
├── apps/
│   ├── xtweak_core/       # Business logic (Ash domain)
│   ├── xtweak_web/        # Marketing/landing pages
│   ├── xtweak_docs/       # Component documentation
│   └── xtweak_ui/         # Component library ⭐ PRIMARY FOCUS
```

### 2.2 App Responsibilities

**xtweak_core** (Ash Domain Logic):
- Purpose: Business entities (User, Newsletter, etc.)
- Technology: Ash Framework 3.7.6+, Postgres
- Dependency Rules: NO web dependencies
- Interface: Ash.Domain public API only

**xtweak_web** (Phoenix Application):
- Purpose: Marketing website, landing pages
- Technology: Phoenix LiveView, Tailwind CSS
- Dependencies: `xtweak_core` for data access
- Styling: CAN use other frameworks (DaisyUI, etc.) for non-component pages
- **Key Distinction**: Uses xtweak_ui components, but isolated from library internals

**xtweak_docs** (Documentation Site):
- Purpose: Component showcase and documentation
- Technology: Phoenix LiveView, ExDoc integration
- Dependencies: `xtweak_ui` (imports components)
- Styling: Pure Tailwind + xtweak_ui components
- **Live Demo**: https://docs.xtweak.com (future)

**xtweak_ui** (Component Library) ⭐:
- Purpose: Reusable Phoenix components (Hex.pm package)
- Technology: Phoenix.Component, Tailwind CSS
- Dependencies: ZERO application dependencies
- Public API: Module attributes, `use XTweakUI.Theme`
- **Distribution**: Standalone Hex package

### 2.3 Dependency Rules

```
xtweak_core   ← Independent (Ash domain)
     ↑
xtweak_web    ← Depends on core
     ↑
xtweak_ui     ← NO app dependencies (standalone)
     ↑
xtweak_docs   ← Depends on ui (showcase only)
```

**Critical Rule**: `xtweak_ui` MUST NOT depend on:
- `xtweak_core` (business logic)
- `xtweak_web` (application code)
- Any Ash resources or Phoenix routes

**Allowed Dependencies**:
- Phoenix.Component (Phoenix framework)
- Tailwind CSS (build-time)
- (Optional) Alpine.js for interactivity

---

## 3. Component Architecture

### 3.1 Component Module Pattern

Based on Nuxt UI MCP research, components follow this structure:

```elixir
defmodule XTweakUI.Button do
  @moduledoc """
  A button element that can act as a link or trigger an action.

  Ported from Nuxt UI Button component.
  """

  use Phoenix.Component
  import XTweakUI.Theme

  attr :label, :string, default: nil, doc: "Button text label"
  attr :color, :string, default: "primary",
    values: ~w(primary secondary success info warning error neutral)
  attr :variant, :string, default: "solid",
    values: ~w(solid outline soft subtle ghost link)
  attr :size, :string, default: "md",
    values: ~w(xs sm md lg xl)
  attr :icon, :string, default: nil, doc: "Icon name (Heroicons)"
  attr :loading, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :block, :boolean, default: false, doc: "Full width button"
  attr :square, :boolean, default: false, doc: "Equal padding (icon button)"

  # Link attributes (when button acts as link)
  attr :navigate, :string, default: nil, doc: "LiveView navigation"
  attr :patch, :string, default: nil, doc: "LiveView patch"
  attr :href, :string, default: nil, doc: "External link"
  attr :method, :string, default: "get", doc: "HTTP method for href"

  # Passthrough attributes
  attr :rest, :global, include: ~w(form name value autofocus tabindex)

  slot :inner_block, required: false
  slot :leading, doc: "Leading slot for icons/avatars"
  slot :trailing, doc: "Trailing slot for icons/badges"

  def button(assigns) do
    ~H"""
    <.link_or_button {@rest} class={button_classes(@color, @variant, @size, @block, @square, @disabled)}>
      <%= if @leading || @icon do %>
        <span class={leading_classes(@size)}>
          <%= render_slot(@leading) || icon(@icon) %>
        </span>
      <% end %>

      <%= if @loading do %>
        <span class={loading_icon_classes(@size)} aria-label="Loading">
          <.icon name="hero-arrow-path" class="animate-spin" />
        </span>
      <% end %>

      <span class="truncate">
        <%= @label || render_slot(@inner_block) %>
      </span>

      <%= if @trailing do %>
        <span class={trailing_classes(@size)}>
          <%= render_slot(@trailing) %>
        </span>
      <% end %>
    </.link_or_button>
    """
  end

  # Private component helpers
  defp link_or_button(assigns) do
    cond do
      assigns[:navigate] -> ~H"<Phoenix.Component.link navigate={@navigate} {@rest}><%= render_slot(@inner_block) %></Phoenix.Component.link>"
      assigns[:patch] -> ~H"<Phoenix.Component.link patch={@patch} {@rest}><%= render_slot(@inner_block) %></Phoenix.Component.link>"
      assigns[:href] -> ~H"<Phoenix.Component.link href={@href} method={@method} {@rest}><%= render_slot(@inner_block) %></Phoenix.Component.link>"
      true -> ~H"<button type="button" {@rest}><%= render_slot(@inner_block) %></button>"
    end
  end

  defp button_classes(color, variant, size, block, square, disabled) do
    theme_classes("button", %{
      color: color,
      variant: variant,
      size: size,
      block: block,
      square: square,
      disabled: disabled
    })
  end

  # ... other helper functions
end
```

### 3.2 Component Organization

```
apps/xtweak_ui/lib/xtweak_ui/
├── components/
│   ├── button.ex           # Form components
│   ├── input.ex
│   ├── checkbox.ex
│   ├── select.ex
│   ├── modal.ex            # Overlay components
│   ├── dropdown_menu.ex
│   ├── popover.ex
│   ├── toast.ex
│   ├── table.ex            # Data components
│   ├── pagination.ex
│   └── ...
├── theme.ex                # Theme configuration module
├── utils/
│   ├── classes.ex          # Class name utilities
│   ├── colors.ex           # Color utilities
│   └── icons.ex            # Icon helpers
└── xtweak_ui.ex            # Main module (public API)
```

### 3.3 Component API Design Principles

**1. Attribute-Driven Configuration** (Primary)
```heex
<XTweakUI.Button.button
  color="primary"
  variant="solid"
  size="lg"
  icon="hero-rocket-launch"
/>
```

**2. Slot-Based Composition** (Advanced)
```heex
<XTweakUI.Button.button>
  <:leading>
    <.icon name="hero-envelope" />
  </:leading>
  Send Email
  <:trailing>
    <.badge>3</.:badge>
  </:trailing>
</XTweakUI.Button.button>
```

**3. Theme Prop for Overrides** (Expert)
```heex
<XTweakUI.Button.button
  color="primary"
  ui_override={%{
    "base" => "custom-base-class",
    "icon" => "custom-icon-class"
  }}
/>
```

**Key Insight from Nuxt UI MCP Research**:
- Nuxt UI uses a `ui` prop for per-component theme overrides
- Phoenix equivalent: `ui_override` map attribute
- Theme system generates base classes, overrides merge on top

---

## 4. Theming System Architecture

### 4.1 Design Token Strategy

**Inspiration**: Nuxt UI uses `app.config.ts` for theme configuration.
**Phoenix Equivalent**: Elixir module with compile-time configuration.

```elixir
# apps/xtweak_ui/lib/xtweak_ui/theme.ex
defmodule XTweakUI.Theme do
  @moduledoc """
  Theme configuration for xTweak UI components.

  Inspired by Nuxt UI's app.config.ts design token system.
  """

  defmacro __using__(_opts) do
    quote do
      import XTweakUI.Theme
    end
  end

  @doc """
  Returns theme configuration for a component.

  ## Example

      theme_config("button", %{color: "primary", variant: "solid"})
      #=> "bg-primary-500 text-white hover:bg-primary-600 ..."
  """
  def theme_config(component, variants) do
    component
    |> get_component_config()
    |> resolve_variants(variants)
    |> build_class_string()
  end

  # Component-specific configurations
  defp get_component_config("button") do
    %{
      base: "rounded-md font-medium inline-flex items-center disabled:cursor-not-allowed disabled:opacity-75 transition-colors",
      variants: %{
        color: %{
          "primary" => %{
            "solid" => "bg-primary-500 text-white hover:bg-primary-600 focus:ring-2 focus:ring-primary-500",
            "outline" => "border border-primary-500 text-primary-500 hover:bg-primary-50",
            # ... other variants
          },
          "secondary" => %{
            # ... color variants
          }
        },
        size: %{
          "xs" => "px-2 py-1 text-xs gap-1",
          "sm" => "px-2.5 py-1.5 text-xs gap-1.5",
          "md" => "px-2.5 py-1.5 text-sm gap-1.5",
          "lg" => "px-3 py-2 text-sm gap-2",
          "xl" => "px-3 py-2 text-base gap-2"
        }
      }
    }
  end

  # ... other component configs (input, modal, etc.)
end
```

### 4.2 CSS Variable Architecture

**Approach**: Tailwind-native CSS variables (2025 best practice from research).

```css
/* apps/xtweak_ui/assets/css/theme.css */

:root {
  /* Semantic color tokens (light theme) */
  --color-primary: 99 102 241;      /* indigo-500 */
  --color-secondary: 168 85 247;     /* purple-500 */
  --color-success: 34 197 94;        /* green-500 */
  --color-warning: 251 146 60;       /* orange-500 */
  --color-error: 239 68 68;          /* red-500 */

  /* Background tokens */
  --color-bg-default: 255 255 255;   /* white */
  --color-bg-elevated: 249 250 251;  /* gray-50 */
  --color-bg-inverted: 17 24 39;     /* gray-900 */

  /* Text tokens */
  --color-text-default: 17 24 39;    /* gray-900 */
  --color-text-muted: 107 114 128;   /* gray-500 */
  --color-text-inverted: 255 255 255; /* white */

  /* Border tokens */
  --color-border-default: 229 231 235; /* gray-200 */
  --color-border-accented: 209 213 219; /* gray-300 */
}

[data-theme="dark"] {
  /* Dark theme overrides */
  --color-primary: 129 140 248;      /* indigo-400 */
  --color-bg-default: 17 24 39;      /* gray-900 */
  --color-bg-elevated: 31 41 55;     /* gray-800 */
  --color-text-default: 243 244 246; /* gray-100 */
  --color-border-default: 55 65 81;  /* gray-700 */
}
```

**Tailwind Configuration**:
```javascript
// apps/xtweak_ui/assets/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: 'rgb(var(--color-primary) / <alpha-value>)',
        secondary: 'rgb(var(--color-secondary) / <alpha-value>)',
        success: 'rgb(var(--color-success) / <alpha-value>)',
        // ... other semantic colors

        'bg-default': 'rgb(var(--color-bg-default) / <alpha-value>)',
        'text-default': 'rgb(var(--color-text-default) / <alpha-value>)',
        // ... other tokens
      }
    }
  },
  plugins: []
}
```

### 4.3 Runtime Theme Switching

**Research Finding** (from web search): Phoenix LiveView + Tailwind supports 3 approaches:

**Chosen Approach**: Data attribute with JavaScript toggle

**Implementation**:

```javascript
// apps/xtweak_ui/assets/js/theme.js
export const ThemeSwitcher = {
  mounted() {
    // Read from localStorage or system preference
    const savedTheme = localStorage.getItem('theme');
    const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    const theme = savedTheme || systemTheme;

    document.documentElement.setAttribute('data-theme', theme);

    // Listen for manual toggle events from LiveView
    this.handleEvent("toggle-theme", ({ theme }) => {
      document.documentElement.setAttribute('data-theme', theme);
      localStorage.setItem('theme', theme);
    });
  }
}
```

**Phoenix Component**:
```elixir
# apps/xtweak_ui/lib/xtweak_ui/components/theme_toggle.ex
defmodule XTweakUI.ThemeToggle do
  use Phoenix.Component

  attr :size, :string, default: "md", values: ~w(xs sm md lg xl)
  attr :rest, :global

  def theme_toggle(assigns) do
    ~H"""
    <button
      phx-hook="ThemeSwitcher"
      phx-click={JS.push("toggle_theme")}
      class="theme-toggle"
      aria-label="Toggle theme"
      {@rest}
    >
      <span class="dark:hidden">
        <.icon name="hero-sun" class={icon_size(@size)} />
      </span>
      <span class="hidden dark:block">
        <.icon name="hero-moon" class={icon_size(@size)} />
      </span>
    </button>
    """
  end
end
```

**LiveView Handler**:
```elixir
def handle_event("toggle_theme", _params, socket) do
  current_theme = socket.assigns[:theme] || "light"
  new_theme = if current_theme == "light", do: "dark", else: "light"

  {:noreply,
   socket
   |> assign(theme: new_theme)
   |> push_event("toggle-theme", %{theme: new_theme})}
end
```

### 4.4 Theme Override System

**Inspiration**: Nuxt UI's `ui` prop allows per-component customization.

**Phoenix Equivalent**:

```elixir
# Component usage with theme override
<XTweakUI.Button.button
  color="primary"
  ui_override={%{
    base: "custom-base-class !important",
    icon: "custom-icon-size"
  }}
>
  Custom Styled Button
</XTweakUI.Button.button>
```

**Implementation in Component**:
```elixir
def button(assigns) do
  base_classes = theme_classes("button", assigns)
  override_classes = Map.get(assigns, :ui_override, %{})

  final_classes = merge_theme_classes(base_classes, override_classes)

  assigns = assign(assigns, :computed_classes, final_classes)

  ~H"""
  <button class={@computed_classes} {@rest}>
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

---

## 5. Asset Pipeline Architecture

### 5.1 Directory Structure

```
apps/xtweak_ui/
├── assets/
│   ├── css/
│   │   ├── app.css              # Entry point
│   │   ├── theme.css            # CSS variables
│   │   ├── components/          # Component-specific styles
│   │   │   ├── button.css
│   │   │   ├── input.css
│   │   │   └── ...
│   │   └── utilities.css        # Custom utilities
│   ├── js/
│   │   ├── app.js               # Entry point
│   │   ├── hooks/               # Phoenix LiveView hooks
│   │   │   ├── theme.js
│   │   │   ├── dropdown.js
│   │   │   └── modal.js
│   │   └── alpine.js            # Alpine.js setup (Phase 1)
│   ├── tailwind.config.js       # Tailwind configuration
│   └── package.json             # npm dependencies
├── priv/static/
│   └── assets/
│       ├── app.css              # Compiled CSS
│       └── app.js               # Compiled JS
```

### 5.2 Build Process Flow

```
┌─────────────────────────────────────────────────────────────┐
│ Development Mode (mix phx.server)                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Phoenix Watcher starts esbuild + tailwindcss            │
│     ↓                                                       │
│  2. esbuild watches assets/js/*.js                          │
│     ├─> Bundles JavaScript                                  │
│     └─> Outputs to priv/static/assets/app.js               │
│     ↓                                                       │
│  3. tailwindcss watches assets/css/*.css + templates        │
│     ├─> Scans .heex files for class names                   │
│     ├─> Generates CSS                                       │
│     └─> Outputs to priv/static/assets/app.css              │
│     ↓                                                       │
│  4. LiveReload detects changes → Browser reloads            │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Production Build (mix assets.deploy)                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. mix assets.build                                        │
│     ├─> esbuild --minify                                    │
│     └─> tailwindcss --minify                                │
│     ↓                                                       │
│  2. Asset digesting (mix phx.digest)                        │
│     └─> app-[hash].css, app-[hash].js                      │
│     ↓                                                       │
│  3. Hex package includes priv/static/                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.3 Tailwind Configuration

**Critical**: Content paths MUST include component files for class extraction.

```javascript
// apps/xtweak_ui/assets/tailwind.config.js
const plugin = require('tailwindcss/plugin');

module.exports = {
  content: [
    // Component files (CRITICAL for class extraction)
    "../lib/xtweak_ui/**/*.ex",
    "../lib/xtweak_ui/**/*.heex",

    // Documentation examples (if using xtweak_ui in docs)
    "../../xtweak_docs/lib/**/*.ex",
    "../../xtweak_docs/lib/**/*.heex",

    // JavaScript files with dynamic classes
    "./js/**/*.js"
  ],

  // Dark mode via data attribute
  darkMode: ['selector', '[data-theme="dark"]'],

  theme: {
    extend: {
      // CSS variable tokens (see section 4.2)
      colors: {
        primary: 'rgb(var(--color-primary) / <alpha-value>)',
        // ... other colors
      },

      // Custom animations for transitions
      keyframes: {
        'fade-in': {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        },
        'scale-in': {
          '0%': { opacity: '0', transform: 'scale(0.95)' },
          '100%': { opacity: '1', transform: 'scale(1)' }
        },
        'slide-in': {
          '0%': { transform: 'translateY(-10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' }
        }
      },
      animation: {
        'fade-in': 'fade-in 200ms ease-out',
        'scale-in': 'scale-in 200ms ease-out',
        'slide-in': 'slide-in 200ms ease-out'
      }
    }
  },

  plugins: [
    // Custom plugin for component utilities (if needed)
    plugin(function({ addComponents, theme }) {
      addComponents({
        '.btn-base': {
          display: 'inline-flex',
          alignItems: 'center',
          justifyContent: 'center',
          borderRadius: theme('borderRadius.md'),
          fontWeight: theme('fontWeight.medium'),
          transition: 'all 200ms ease-in-out',
        }
      });
    })
  ]
};
```

### 5.4 Mix Integration

**config/config.exs**:
```elixir
config :xtweak_ui, XTweakUI.Endpoint,
  # ... other config
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:xtweak_ui, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:xtweak_ui, ~w(--watch)]}
  ]
```

**mix.exs** (custom tasks):
```elixir
defp aliases do
  [
    "assets.build": ["esbuild xtweak_ui", "tailwind xtweak_ui"],
    "assets.watch": ["assets.build", "assets.watch.parallel"],
    "assets.watch.parallel": [
      "parallel esbuild xtweak_ui --watch, tailwind xtweak_ui --watch"
    ],
    "assets.deploy": [
      "esbuild xtweak_ui --minify",
      "tailwind xtweak_ui --minify",
      "phx.digest"
    ]
  ]
end
```

---

## 6. JavaScript Architecture

### 6.1 Interactivity Tiers

**Phase 1 Strategy**: Minimal JavaScript, Alpine.js for simple interactions.

| Tier | Description | Implementation | Examples |
|------|-------------|----------------|----------|
| **Tier 1** | No JS (Pure CSS) | CSS transitions, :hover, :focus | Button hover, Input focus ring |
| **Tier 2** | LiveView Native | Phoenix LiveView events | Form submission, Table sorting |
| **Tier 3** | Alpine.js | x-data, x-show, x-transition | Dropdown open/close, Modal show/hide |
| **Tier 4** | Custom Hooks | Phoenix.LiveView.JS hooks | Theme switcher, Focus trap |

### 6.2 Alpine.js Integration (Phase 1)

**Why Alpine.js**:
- Lightweight (15KB gzipped)
- Declarative syntax (similar to Vue.js)
- No build step required
- Easy integration with LiveView

**Example: Dropdown Component**:

```heex
<!-- apps/xtweak_ui/lib/xtweak_ui/components/dropdown_menu.ex -->
<div
  x-data="{ open: false }"
  x-on:click.outside="open = false"
  class="relative"
>
  <button
    x-on:click="open = !open"
    class="dropdown-trigger"
    aria-haspopup="true"
    x-bind:aria-expanded="open.toString()"
  >
    <%= render_slot(@trigger) %>
  </button>

  <div
    x-show="open"
    x-transition:enter="transition ease-out duration-200"
    x-transition:enter-start="opacity-0 scale-95"
    x-transition:enter-end="opacity-100 scale-100"
    x-transition:leave="transition ease-in duration-150"
    x-transition:leave-start="opacity-100 scale-100"
    x-transition:leave-end="opacity-0 scale-95"
    class="dropdown-menu"
  >
    <%= render_slot(@inner_block) %>
  </div>
</div>
```

**Asset Setup**:
```javascript
// apps/xtweak_ui/assets/js/app.js
import Alpine from 'alpinejs';

// Make Alpine available globally
window.Alpine = Alpine;

// Initialize Alpine
Alpine.start();
```

### 6.3 Phoenix LiveView Hooks (Phase 1)

**Purpose**: Bridge between LiveView (server) and JavaScript (client).

**Example: Modal Focus Trap**:

```javascript
// apps/xtweak_ui/assets/js/hooks/modal.js
export const ModalHook = {
  mounted() {
    // Get all focusable elements
    this.focusableElements = this.el.querySelectorAll(
      'a[href], button, textarea, input, select, [tabindex]:not([tabindex="-1"])'
    );

    this.firstElement = this.focusableElements[0];
    this.lastElement = this.focusableElements[this.focusableElements.length - 1];

    // Focus first element
    this.firstElement?.focus();

    // Trap focus within modal
    this.el.addEventListener('keydown', this.handleKeydown.bind(this));

    // Lock body scroll
    document.body.style.overflow = 'hidden';
  },

  destroyed() {
    // Restore body scroll
    document.body.style.overflow = '';
  },

  handleKeydown(e) {
    if (e.key === 'Tab') {
      if (e.shiftKey) {
        // Shift+Tab: focus last element if at first
        if (document.activeElement === this.firstElement) {
          e.preventDefault();
          this.lastElement?.focus();
        }
      } else {
        // Tab: focus first element if at last
        if (document.activeElement === this.lastElement) {
          e.preventDefault();
          this.firstElement?.focus();
        }
      }
    } else if (e.key === 'Escape') {
      // Close modal on Escape
      this.pushEvent("close-modal", {});
    }
  }
};
```

**Hook Registration**:
```javascript
// apps/xtweak_ui/assets/js/app.js
import { ModalHook } from './hooks/modal';
import { ThemeSwitcher } from './hooks/theme';

let Hooks = {
  Modal: ModalHook,
  ThemeSwitcher: ThemeSwitcher
};

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken}
});
```

**Usage in Component**:
```heex
<div
  id="modal-overlay"
  phx-hook="Modal"
  class="modal-overlay"
>
  <div class="modal-content">
    <%= render_slot(@inner_block) %>
  </div>
</div>
```

### 6.4 Hook System (Phase 2+)

**Deferred**: Custom JavaScript hook API for advanced interactivity.

**Future Vision**:
```javascript
// Phase 2+ example (NOT implemented in Phase 1)
XTweakUI.hooks.register('custom-chart', {
  mounted() {
    // Initialize chart library (e.g., Chart.js)
  },
  updated() {
    // Update chart with new data
  }
});
```

---

## 7. State Management

### 7.1 State Layers

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: Component-Level State (LiveView Assigns)          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  assign(socket, :theme, "dark")                             │
│  assign(socket, :selected_items, [1, 2, 3])                 │
│                                                             │
│  Scope: Single LiveView process                             │
│  Lifetime: Until LiveView unmounts                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Layer 2: Global State (GenServer + PubSub)                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  XTweakUI.ThemeManager (GenServer)                          │
│    ├─> Tracks active themes across sessions                 │
│    └─> Broadcasts theme changes via PubSub                  │
│                                                             │
│  Phoenix.PubSub.broadcast("theme:changed", %{theme: "dark"})│
│                                                             │
│  Scope: Application-wide                                    │
│  Lifetime: Application lifetime                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Layer 3: Client-Side State (Alpine.js / LocalStorage)       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  x-data="{ dropdownOpen: false }"                           │
│  localStorage.setItem('theme', 'dark')                      │
│                                                             │
│  Scope: Browser tab                                         │
│  Lifetime: Until page reload (x-data) or manual clear (LS) │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 State Synchronization Pattern

**Scenario**: User changes theme in one browser tab, other tabs update.

```
User Tab A                      Server                      User Tab B
    │                              │                              │
    │  [Click theme toggle]        │                              │
    ├──────── push("toggle_theme") ────────>                     │
    │                              │                              │
    │                        [GenServer stores]                   │
    │                              │                              │
    │                  [Broadcast via PubSub]                     │
    │                              │                              │
    │                              ├────────── push_event ──────>│
    │                              │        ("theme-changed")     │
    │                              │                              │
    │<──── push_event ─────────────┤                              │
    │   ("theme-changed")          │                              │
    │                              │                              │
    │  [JS Hook updates data-theme]│       [JS Hook updates data-theme]
    │                              │                              │
```

**Implementation**:

```elixir
# apps/xtweak_ui/lib/xtweak_ui/theme_manager.ex
defmodule XTweakUI.ThemeManager do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_theme(user_id, theme) do
    GenServer.call(__MODULE__, {:set_theme, user_id, theme})
  end

  def handle_call({:set_theme, user_id, theme}, _from, state) do
    # Store theme preference
    new_state = Map.put(state, user_id, theme)

    # Broadcast to all LiveView processes for this user
    Phoenix.PubSub.broadcast(
      XTweakUI.PubSub,
      "user:#{user_id}:theme",
      {:theme_changed, theme}
    )

    {:reply, :ok, new_state}
  end
end
```

**LiveView Integration**:
```elixir
def mount(_params, session, socket) do
  user_id = session["user_id"]

  # Subscribe to theme changes
  Phoenix.PubSub.subscribe(XTweakUI.PubSub, "user:#{user_id}:theme")

  {:ok, assign(socket, theme: get_user_theme(user_id))}
end

def handle_info({:theme_changed, theme}, socket) do
  {:noreply,
   socket
   |> assign(theme: theme)
   |> push_event("theme-changed", %{theme: theme})}
end
```

---

## 8. Module Organization

### 8.1 Public API Surface

**apps/xtweak_ui/lib/xtweak_ui.ex** (Main module):

```elixir
defmodule XTweakUI do
  @moduledoc """
  xTweak UI - Phoenix component library inspired by Nuxt UI.

  ## Installation

  Add to your `mix.exs`:

      {:xtweak_ui, "~> 0.1.0"}

  ## Usage

  Import components in your LiveView:

      use XTweakUI

  Or import specific components:

      import XTweakUI.Button
      import XTweakUI.Input

  ## Configuration

  Configure theme in `config/config.exs`:

      config :xtweak_ui,
        theme: [
          primary_color: "indigo",
          default_size: "md"
        ]
  """

  @doc """
  Imports all xTweak UI components into the calling module.
  """
  defmacro __using__(_opts) do
    quote do
      import XTweakUI.Button
      import XTweakUI.Input
      import XTweakUI.Modal
      import XTweakUI.DropdownMenu
      import XTweakUI.Table
      # ... other components

      import XTweakUI.Theme
      import XTweakUI.Icon
    end
  end
end
```

### 8.2 Private vs Public Modules

**Public Modules** (documented, stable API):
- `XTweakUI` - Main module
- `XTweakUI.Button` - Button component
- `XTweakUI.Input` - Input component
- `XTweakUI.Modal` - Modal component
- `XTweakUI.Theme` - Theme utilities
- `XTweakUI.Icon` - Icon helpers

**Private Modules** (internal, may change):
- `XTweakUI.Utils.Classes` - Class name utilities
- `XTweakUI.Utils.Colors` - Color utilities
- `XTweakUI.Utils.Variants` - Variant resolution

**Convention**: Private modules start with `XTweakUI.Utils.*` or `XTweakUI.Internal.*`.

### 8.3 Versioning Strategy

**Semantic Versioning** (SemVer):
- **MAJOR**: Breaking API changes (e.g., rename props, remove components)
- **MINOR**: New components, new props (backward-compatible)
- **PATCH**: Bug fixes, documentation updates

**Example**:
- `v0.1.0` - Phase 1 (5 components)
- `v0.2.0` - Phase 2 (5 more components)
- `v1.0.0` - Phase 4 (all 105 components, stable API)

---

## 9. Performance Considerations

### 9.1 Render Performance

**Target**: < 100ms component render time (from FR-3.1).

**Optimization Strategies**:

1. **Minimize Assign Copying**
   ```elixir
   # ❌ Bad: Creates new map on every call
   def button(assigns) do
     assigns = Map.merge(assigns, %{classes: compute_classes(assigns)})
     # ...
   end

   # ✅ Good: Use assign/3 for efficient updates
   def button(assigns) do
     assigns = assign(assigns, :classes, compute_classes(assigns))
     # ...
   end
   ```

2. **Cache Theme Classes**
   ```elixir
   # Compile-time theme class generation
   @button_classes %{
     {color: "primary", variant: "solid"} => "bg-primary-500 text-white ...",
     {color: "primary", variant: "outline"} => "border border-primary-500 ..."
   }

   defp theme_classes(color, variant) do
     Map.get(@button_classes, {color: color, variant: variant})
   end
   ```

3. **Avoid Expensive computations in Templates**
   ```heex
   <!-- ❌ Bad: Computed on every render -->
   <button class={compute_button_classes(@color, @variant, @size)}>

   <!-- ✅ Good: Precompute in assigns -->
   <button class={@button_classes}>
   ```

### 9.2 CSS Bundle Size

**Target**: < 80KB gzipped (Phase 4, NFR-1.3).

**Optimization Strategies**:

1. **Tailwind Purge Configuration**
   - Scan all `.ex` and `.heex` files
   - Remove unused CSS classes
   - Result: ~95% smaller bundle

2. **Component-Specific CSS** (optional)
   - Split CSS by component (button.css, input.css)
   - Lazy load via dynamic imports (Phase 3+)

3. **CSS Minification**
   - Run `tailwindcss --minify` in production
   - Result: ~30% smaller bundle

**Bundle Analysis**:
```bash
# Check CSS bundle size
mix assets.deploy
du -h priv/static/assets/app.css

# Expected sizes:
# Development: ~200KB (all utilities)
# Production: ~60KB (purged + minified)
```

### 9.3 JavaScript Bundle Size

**Target**: < 50KB gzipped (Alpine.js baseline).

**Current Bundle**:
- Alpine.js: ~15KB gzipped
- Phoenix LiveView client: ~35KB gzipped
- Custom hooks: ~5KB gzipped
- **Total**: ~55KB (slightly over target, acceptable for Phase 1)

**Future Optimization** (Phase 2+):
- Lazy load Alpine.js components
- Tree-shake unused hooks
- Code-split by route

---

## 10. Deployment Architecture

### 10.1 Hex.pm Package Structure

```
xtweak_ui-0.1.0/
├── lib/
│   └── xtweak_ui/
│       ├── components/
│       ├── theme.ex
│       └── xtweak_ui.ex
├── priv/
│   └── static/
│       └── assets/
│           ├── app.css        # Compiled CSS
│           ├── app.js         # Compiled JS
│           └── app.css.map    # Source maps (dev only)
├── mix.exs
├── README.md
├── CHANGELOG.md
└── LICENSE
```

### 10.2 Hex Package Configuration

**mix.exs**:
```elixir
defp package do
  [
    name: "xtweak_ui",
    description: "Phoenix component library inspired by Nuxt UI. 105 accessible, themeable components built with Tailwind CSS.",
    files: ~w(lib priv .formatter.exs mix.exs README.md LICENSE CHANGELOG.md),
    licenses: ["MIT"],
    links: %{
      "GitHub" => "https://github.com/xtweak/xtweak_ui",
      "Documentation" => "https://hexdocs.pm/xtweak_ui",
      "Showcase" => "https://showcase.xtweak.com"
    },
    maintainers: ["Peter Fodor"]
  ]
end
```

### 10.3 Installation Instructions (for Users)

**Step 1**: Add to `mix.exs`:
```elixir
defp deps do
  [
    {:xtweak_ui, "~> 0.1.0"}
  ]
end
```

**Step 2**: Import components:
```elixir
defmodule MyAppWeb.PageLive do
  use MyAppWeb, :live_view
  use XTweakUI  # Imports all components
end
```

**Step 3**: Configure Tailwind (merge with existing config):
```javascript
// assets/tailwind.config.js
module.exports = {
  content: [
    // ... your existing content paths
    "../deps/xtweak_ui/**/*.ex",  // Add xtweak_ui components
  ],
  // ... rest of config
}
```

**Step 4**: Add CSS to `app.css`:
```css
/* assets/css/app.css */
@import "../../deps/xtweak_ui/priv/static/assets/app.css";

/* Your app styles */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Step 5**: Add JS hooks (if using interactive components):
```javascript
// assets/js/app.js
import { XTweakUI } from "xtweak_ui";

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: XTweakUI.Hooks,  // Include xTweak UI hooks
  params: {_csrf_token: csrfToken}
});
```

---

## Appendix A: Key Architecture Decisions

### A.1 Why No DaisyUI?

**Decision**: Do NOT use DaisyUI classes in xtweak_ui components.

**Rationale**:
1. **Clean Slate**: Nuxt UI uses pure Tailwind, we match their approach
2. **API Clarity**: DaisyUI uses `class="btn btn-primary"`, Nuxt UI uses `color="primary" variant="solid"` (different paradigms)
3. **Zero Dependencies**: Users shouldn't need DaisyUI installed
4. **Future-Proof**: Easier to migrate to UnoCSS later (Phase 3+)

**Note**: `xtweak_web` CAN still use DaisyUI for marketing pages—separation of concerns.

### A.2 Why Alpine.js (Phase 1)?

**Decision**: Use Alpine.js for client-side interactivity in Phase 1.

**Rationale**:
1. **Lightweight**: 15KB gzipped vs React (40KB+)
2. **Declarative**: Similar to Vue.js (Nuxt UI's framework)
3. **No Build Step**: Works with Phoenix asset pipeline
4. **LiveView Compatible**: Designed for server-rendered apps

**Future**: May add custom hook system (Phase 2+) or evaluate other libraries.

### A.3 Why CSS Variables Over Tailwind Config?

**Decision**: Use CSS variables for theming, not just Tailwind config.

**Rationale**:
1. **Runtime Switching**: CSS variables can change without rebuild
2. **User Customization**: Users can override via `<style>` tag
3. **Dark Mode**: Simple `[data-theme="dark"]` selector
4. **Industry Standard**: 2025 best practice (research finding)

---

## Appendix B: MCP-Driven Development Workflow

### B.1 Standard Component Porting Workflow

**MANDATORY before implementing ANY component**:

```bash
# Step 1: Research component API
mcp__nuxt_ui__get_component "Button"

# Step 2: Get detailed metadata
mcp__nuxt_ui__get_component_metadata "Button"

# Step 3: Get code examples
mcp__nuxt_ui__get_example "Button"

# Step 4: Verify Phoenix patterns (if needed)
mcp__tidewave__get_docs "Phoenix.Component"

# Step 5: Implement Phoenix component (guided by research)
```

**Why This Workflow**:
- Ensures 100% API accuracy with current Nuxt UI version
- Avoids guesswork and outdated documentation
- Systematic approach for all 105 components

### B.2 MCP Server Hierarchy

```
Priority 1: Nuxt UI MCP Server ⭐
  └─> Component API research (PRIMARY tool)

Priority 2: Tidewave MCP Server
  └─> Elixir/Phoenix verification

Priority 3: Context7 MCP Server
  └─> Other libraries (Alpine.js, Tailwind plugins)
```

---

## Document Status

✅ **Complete** - All sections documented with research findings
📅 **Last Updated**: 2025-10-29
👤 **Maintained By**: Peter Fodor + Claude Code

**Next Steps**:
1. Review architecture with stakeholders
2. Begin Sprint 1 (Infrastructure + Button component)
3. Validate assumptions with prototype

---
