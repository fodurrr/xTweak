# Technical Specification: Nuxt UI → Phoenix/Elixir Port

**Document Version**: 1.0.0
**Date**: 2025-10-29
**Status**: ✅ Approved
**Author**: Peter Fodor (with Claude Code assistance)

---

## Table of Contents

1. [Nuxt UI Deep Dive](#1-nuxt-ui-deep-dive)
2. [Phoenix/LiveView Patterns](#2-phoenixliveview-patterns)
3. [CSS Framework Comparison](#3-css-framework-comparison)
4. [Asset Pipeline Architecture](#4-asset-pipeline-architecture)
5. [Gap Analysis](#5-gap-analysis)
6. [MCP Tool Workflow](#6-mcp-tool-workflow)
7. [Testing Strategy Overview](#7-testing-strategy-overview)
8. [Documentation Requirements](#8-documentation-requirements)

---

## 1. Nuxt UI Deep Dive

### 1.1 Nuxt UI Architecture Analysis

**Overview**: Nuxt UI is a Vue.js component library built on Tailwind CSS, providing 100+ production-ready components with a cohesive design system.

#### Component Organization

Nuxt UI organizes components into logical categories:

```
Components/
├── Elements (14)
│   ├── Avatar, AvatarGroup
│   ├── Badge, Icon
│   ├── Button, ButtonGroup
│   ├── Kbd, Chip
│   └── ...
│
├── Forms (12)
│   ├── Form, FormGroup
│   ├── Input, Textarea
│   ├── Select, SelectMenu
│   ├── Checkbox, Radio, RadioGroup, Toggle
│   ├── Range, InputMenu
│   └── ...
│
├── Navigation (12)
│   ├── Accordion, AccordionItem
│   ├── Tabs, VerticalNavigation
│   ├── Breadcrumb, Pagination
│   ├── Link, CommandPalette
│   └── ...
│
├── Overlays (9)
│   ├── Modal, Slideover
│   ├── Popover, Tooltip
│   ├── ContextMenu, Notification
│   └── ...
│
├── Data (9)
│   ├── Table, Card
│   ├── Alert, Progress
│   ├── Skeleton, Meter
│   └── ...
│
└── Layout (5)
    ├── Container, Divider
    ├── Separator, Skeleton
    └── ...
```

**Key Pattern**: All components follow a consistent API structure:
- **Props**: `color`, `variant`, `size` (where applicable)
- **Slots**: `leading`, `trailing`, `header`, `footer` (contextual)
- **Events**: Standard Vue events (`@click`, `@change`, `@input`)
- **Composables**: `useToast()`, `useModal()`, `useNotifications()` for global state

#### Props System

**Color Prop Pattern**:
```javascript
// Nuxt UI Button
color: {
  type: String,
  default: 'primary',
  validator: (val) => ['primary', 'secondary', 'success', 'warning', 'error', 'gray'].includes(val)
}
```

**Phoenix Equivalent**:
```elixir
attr :color, :string, default: "primary", values: ["primary", "secondary", "success", "warning", "error", "gray"]
```

**Variant Prop Pattern**:
```javascript
// Nuxt UI Button
variant: {
  type: String,
  default: 'solid',
  validator: (val) => ['solid', 'outline', 'soft', 'ghost', 'link'].includes(val)
}
```

**Size Prop Pattern**:
```javascript
// Nuxt UI Button
size: {
  type: String,
  default: 'md',
  validator: (val) => ['xs', 'sm', 'md', 'lg', 'xl'].includes(val)
}
```

#### Slot Patterns

**Leading/Trailing Slots** (common in buttons, inputs):
```vue
<UButton>
  <template #leading>
    <UIcon name="i-heroicons-magnifying-glass" />
  </template>
  Search
  <template #trailing>
    <UKbd>⌘K</UKbd>
  </template>
</UButton>
```

**Phoenix Equivalent**:
```elixir
<.button>
  <:leading>
    <.icon name="hero-magnifying-glass" />
  </:leading>
  Search
  <:trailing>
    <.kbd>⌘K</.kbd>
  </:trailing>
</.button>
```

#### Composables Architecture

**Nuxt UI Composables** (global state management):
```javascript
// Toast composable
const toast = useToast()
toast.add({ title: 'Success!', color: 'success' })

// Modal composable
const modal = useModal()
modal.open(ConfirmDialog, { title: 'Confirm Action' })

// Notifications composable
const notifications = useNotifications()
notifications.add({ title: 'New message', icon: 'i-heroicons-bell' })
```

**Phoenix Equivalent** (GenServer + PubSub):
```elixir
# Toast GenServer
XTweakUI.Toast.show("Success!", color: :success)

# Modal LiveView component
send_update(XTweakUI.Components.Modal, id: :confirm_dialog, open: true, title: "Confirm Action")

# Notifications PubSub
Phoenix.PubSub.broadcast(XTweakWeb.PubSub, "notifications", {:new_notification, %{title: "New message"}})
```

#### Theming System (app.config.ts)

**Nuxt UI Configuration**:
```typescript
// app.config.ts
export default defineAppConfig({
  ui: {
    primary: 'blue',
    gray: 'slate',
    colors: ['primary', 'secondary', 'success', 'warning', 'error'],
    button: {
      default: {
        color: 'primary',
        variant: 'solid',
        size: 'md'
      },
      rounded: 'rounded-lg'
    }
  }
})
```

**Phoenix Equivalent** (XTweakUI.Theme module):
```elixir
# config/config.exs
config :xtweak_ui, :theme,
  primary: "blue",
  gray: "slate",
  components: %{
    button: %{
      default: %{color: "primary", variant: "solid", size: "md"},
      rounded: "rounded-lg"
    }
  }

# lib/xtweak_ui/theme.ex
defmodule XTweakUI.Theme do
  def get, do: Application.get_env(:xtweak_ui, :theme, @default_theme)
  def component_config(component), do: get()[:components][component] || %{}
end
```

---

### 1.2 Color System (OKLCH)

**Why Nuxt UI Uses OKLCH**:
1. **Perceptual Uniformity**: Colors at same lightness look equally bright to human eye
2. **Wide Gamut**: Access to more vivid colors than RGB/HSL
3. **Predictable Lightness**: Lightness value directly corresponds to perceived brightness
4. **Better Dark Mode**: Easier to generate dark mode variants (adjust lightness, keep hue/chroma)

**OKLCH Syntax**:
```css
oklch(Lightness% Chroma Hue)

/* Examples */
oklch(60% 0.20 240)  /* Medium blue */
oklch(97% 0.01 240)  /* Very light blue (50) */
oklch(28% 0.08 240)  /* Very dark blue (900) */
```

**Color Scale Generation** (50-900):
```css
:root {
  /* Blue scale (240° hue) */
  --color-primary-50: oklch(97% 0.01 240);
  --color-primary-100: oklch(93% 0.04 240);
  --color-primary-200: oklch(87% 0.08 240);
  --color-primary-300: oklch(78% 0.12 240);
  --color-primary-400: oklch(68% 0.16 240);
  --color-primary-500: oklch(60% 0.20 240);  /* Base */
  --color-primary-600: oklch(52% 0.18 240);
  --color-primary-700: oklch(44% 0.14 240);
  --color-primary-800: oklch(36% 0.10 240);
  --color-primary-900: oklch(28% 0.08 240);
  --color-primary-950: oklch(20% 0.04 240);
}
```

**Semantic Color Tokens**:
```css
:root {
  /* Semantic colors */
  --color-primary-500: oklch(60% 0.20 240);     /* Blue */
  --color-success-500: oklch(62% 0.18 142);     /* Green */
  --color-warning-500: oklch(70% 0.16 85);      /* Yellow/Orange */
  --color-error-500: oklch(58% 0.22 27);        /* Red */
  --color-gray-500: oklch(50% 0.02 240);        /* Neutral gray */
}
```

**Dark Mode Strategy** (CSS variable inversion):
```css
:root {
  --ui-bg-default: oklch(100% 0 0);  /* White */
  --ui-text-default: oklch(20% 0 0);  /* Near black */
}

:root[data-theme="dark"] {
  --ui-bg-default: oklch(15% 0 0);   /* Near black */
  --ui-text-default: oklch(95% 0 0);  /* Near white */

  /* Adjust primary colors for dark mode */
  --color-primary-500: oklch(70% 0.20 240);  /* Lighter for visibility */
}
```

**Advantages for Phoenix Port**:
- CSS variables map directly to Tailwind config
- No JavaScript required for theme switching (just data-theme attribute)
- Predictable color generation (can automate scale generation)

---

### 1.3 Component Complexity Classification

We classify components into 4 tiers based on interactivity requirements:

#### Tier 1: CSS-Only Components (Phoenix.Component)

**Characteristics**: No JavaScript, pure server-rendered, static styling

**Examples**:
- Button (unless loading state animated)
- Badge
- Card
- Avatar
- Divider
- Container
- Alert (static)
- Progress (static value)

**Implementation**:
```elixir
defmodule XTweakUI.Components.Badge do
  use Phoenix.Component

  attr :color, :string, default: "primary"
  attr :variant, :string, default: "solid"
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={badge_classes(@color, @variant)}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp badge_classes(color, variant) do
    # Pure CSS class generation
  end
end
```

**Advantages**: Zero JavaScript, fastest rendering, SEO-friendly

---

#### Tier 2: LiveView.JS Components (Server-Driven UI)

**Characteristics**: Client-side show/hide/toggle, but triggered by server

**Examples**:
- Modal (show/hide)
- Tabs (show selected panel)
- Accordion (expand/collapse)
- Slideover (slide in/out)
- Disclosure (toggle content)

**Implementation** (Modal example):
```elixir
defmodule XTweakUI.Components.Modal do
  use Phoenix.Component
  import Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      class="fixed inset-0 z-50"
      style={if @show, do: "", else: "display: none;"}
    >
      <div class="modal-backdrop" phx-click={hide_modal(@id)}></div>
      <div class="modal-content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def show_modal(js \\ %JS{}, id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.add_class("modal-open", to: "body")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}")
    |> JS.remove_class("modal-open", to: "body")
  end
end

# Usage in LiveView
<.modal id="confirm-dialog" show={@modal_open}>
  <p>Are you sure?</p>
  <.button phx-click={hide_modal("confirm-dialog")}>Cancel</.button>
</.modal>

<.button phx-click={show_modal("confirm-dialog")}>Open Modal</.button>
```

**Advantages**: Server-driven (secure), minimal JavaScript, works without Alpine.js

---

#### Tier 3: Alpine.js Components (Local State)

**Characteristics**: Requires client-side state (open/closed, selected item, position)

**Examples**:
- Dropdown (open state, click outside)
- Popover (positioning, open state)
- Tooltip (hover state, positioning)
- ContextMenu (right-click menu)
- CommandPalette (search state, keyboard navigation)

**Implementation** (Dropdown example):
```elixir
defmodule XTweakUI.Components.Dropdown do
  use Phoenix.Component

  attr :id, :string, required: true
  slot :trigger, required: true
  slot :inner_block, required: true

  def dropdown(assigns) do
    ~H"""
    <div x-data="{ open: false }" class="relative">
      <div x-on:click="open = !open">
        <%= render_slot(@trigger) %>
      </div>

      <div
        x-show="open"
        x-on:click.outside="open = false"
        x-transition
        class="absolute mt-2 w-56 rounded-md shadow-lg"
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end

# Usage
<.dropdown id="user-menu">
  <:trigger>
    <.button>Menu</.button>
  </:trigger>

  <.link href="/profile">Profile</.link>
  <.link href="/settings">Settings</.link>
  <.link href="/logout">Logout</.link>
</.dropdown>
```

**Advantages**: Declarative, minimal JS, good for local UI state

**Dependency**: Requires Alpine.js (~15KB gzipped)

---

#### Tier 4: LiveView Hooks (Complex Widgets)

**Characteristics**: Requires 3rd-party libraries, complex initialization, bidirectional state sync

**Examples**:
- DatePicker (date selection library)
- ColorPicker (color selector widget)
- RichTextEditor (Tiptap, ProseMirror)
- Charts (Chart.js, Plotly)
- ImageCropper (Cropper.js)
- CodeEditor (CodeMirror, Monaco)

**Implementation** (ColorPicker example):
```elixir
# Component
defmodule XTweakUI.Components.ColorPicker do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :value, :string, default: "#000000"
  attr :on_change, :string, required: true

  def color_picker(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ColorPicker"
      data-color={@value}
      data-on-change={@on_change}
    >
      <div class="color-preview" style={"background-color: #{@value}"}></div>
    </div>
    """
  end
end

# Hook (assets/js/hooks.js)
export const XTweakUIHooks = {
  ColorPicker: {
    mounted() {
      const picker = new Picker({
        parent: this.el,
        color: this.el.dataset.color,
        onChange: (color) => {
          // Push color back to LiveView
          this.pushEvent(this.el.dataset.onChange, { color: color.hex })
        }
      })
      this.picker = picker
    },

    updated() {
      // Sync with LiveView assigns
      const newColor = this.el.dataset.color
      if (this.picker.getColor() !== newColor) {
        this.picker.setColor(newColor)
      }
    },

    destroyed() {
      this.picker.destroy()
    }
  }
}

# LiveView
def mount(_params, _session, socket) do
  {:ok, assign(socket, color: "#ff0000")}
end

def handle_event("color_changed", %{"color" => color}, socket) do
  {:noreply, assign(socket, color: color)}
end

# Template
<.color_picker
  id="bg-color"
  value={@color}
  on_change="color_changed"
/>
```

**Advantages**: Leverage existing JavaScript ecosystem
**Disadvantages**: More complex, larger bundle size, state sync overhead

---

## 2. Phoenix/LiveView Patterns

### 2.1 Phoenix.Component API Mapping

**Nuxt UI → Phoenix Component Translation Guide**

#### Props → Attributes

**Nuxt UI**:
```javascript
export default {
  props: {
    color: {
      type: String,
      default: 'primary',
      validator: (val) => ['primary', 'secondary'].includes(val)
    },
    size: {
      type: String,
      default: 'md'
    },
    disabled: {
      type: Boolean,
      default: false
    }
  }
}
```

**Phoenix.Component**:
```elixir
attr :color, :string, default: "primary", values: ["primary", "secondary"]
attr :size, :string, default: "md"
attr :disabled, :boolean, default: false
```

**Type Mapping**:
| Nuxt UI Type | Phoenix Type | Notes |
|--------------|--------------|-------|
| `String` | `:string` | Direct mapping |
| `Number` | `:integer`, `:float` | Choose based on context |
| `Boolean` | `:boolean` | Direct mapping |
| `Array` | `:list` | Phoenix validates as list |
| `Object` | `:map` | Phoenix validates as map |
| `Function` | `:string` | Pass event name, not function |

---

#### Slots → Slots

**Nuxt UI**:
```vue
<template>
  <button>
    <slot name="leading" />
    <slot />  <!-- Default slot -->
    <slot name="trailing" />
  </button>
</template>

<!-- Usage -->
<UButton>
  <template #leading><Icon /></template>
  Click me
  <template #trailing><Badge /></template>
</UButton>
```

**Phoenix.Component**:
```elixir
slot :leading
slot :inner_block, required: true
slot :trailing

def button(assigns) do
  ~H"""
  <button>
    <%= render_slot(@leading) %>
    <%= render_slot(@inner_block) %>
    <%= render_slot(@trailing) %>
  </button>
  """
end

# Usage
<.button>
  <:leading><.icon /></:leading>
  Click me
  <:trailing><.badge /></:trailing>
</.button>
```

**Slot Props (Scoped Slots)**:

**Nuxt UI**:
```vue
<template>
  <div>
    <slot name="item" :item="item" :index="index" />
  </div>
</template>

<!-- Usage -->
<UList>
  <template #item="{ item, index }">
    {{ index }}: {{ item.name }}
  </template>
</UList>
```

**Phoenix.Component**:
```elixir
slot :item, required: true do
  attr :item, :map
  attr :index, :integer
end

def list(assigns) do
  ~H"""
  <div>
    <%= for {item, index} <- Enum.with_index(@items) do %>
      <%= render_slot(@item, %{item: item, index: index}) %>
    <% end %>
  </div>
  """
end

# Usage
<.list items={@items}>
  <:item :let={%{item: item, index: index}}>
    <%= index %>: <%= item.name %>
  </:item>
</.list>
```

---

#### v-model → phx-change Events

**Nuxt UI** (two-way binding):
```vue
<template>
  <input :value="modelValue" @input="$emit('update:modelValue', $event.target.value)" />
</template>

<!-- Usage -->
<UInput v-model="username" />
```

**Phoenix.Component** (one-way flow):
```elixir
attr :value, :string, default: ""
attr :name, :string, required: true
attr :on_change, :string, default: nil

def input(assigns) do
  ~H"""
  <input
    type="text"
    name={@name}
    value={@value}
    phx-change={@on_change}
  />
  """
end

# LiveView
def mount(_params, _session, socket) do
  {:ok, assign(socket, username: "")}
end

def handle_event("update_username", %{"value" => value}, socket) do
  {:noreply, assign(socket, username: value)}
end

# Template
<.input
  name="username"
  value={@username}
  on_change="update_username"
/>
```

**Alternative: Phoenix.HTML.Form** (preferred for forms):
```elixir
<.simple_form for={@form} phx-change="validate" phx-submit="save">
  <.input field={@form[:username]} label="Username" />
</.simple_form>
```

---

#### Event Handlers → phx-* Attributes

**Nuxt UI**:
```vue
<button @click="handleClick" @mouseenter="handleHover">
  Click me
</button>

<script setup>
const handleClick = () => { /* ... */ }
const handleHover = () => { /* ... */ }
</script>
```

**Phoenix.Component**:
```elixir
<button
  phx-click="handle_click"
  phx-mouseenter="handle_hover"
  phx-value-id={@id}
>
  Click me
</button>

# LiveView
def handle_event("handle_click", %{"id" => id}, socket) do
  # Handle click
  {:noreply, socket}
end

def handle_event("handle_hover", %{"id" => id}, socket) do
  # Handle hover
  {:noreply, socket}
end
```

**Common phx-* Events**:
- `phx-click` - Click event
- `phx-submit` - Form submit
- `phx-change` - Input change
- `phx-blur` - Input blur
- `phx-focus` - Input focus
- `phx-keydown`, `phx-keyup` - Keyboard events
- `phx-window-keydown` - Global keyboard events

---

### 2.2 State Management Strategies

#### Server-Side State (LiveView Assigns)

**When to Use**:
- Data from database
- User session data
- Form state
- Global app state

**Pattern**:
```elixir
def mount(_params, session, socket) do
  user = get_user(session["user_id"])

  socket =
    socket
    |> assign(:user, user)
    |> assign(:theme, user.preferences.theme)
    |> assign(:notifications_count, count_unread_notifications(user))

  {:ok, socket}
end

def handle_event("update_theme", %{"theme" => theme}, socket) do
  # Update in database
  update_user_theme(socket.assigns.user, theme)

  # Update socket assigns
  {:noreply, assign(socket, theme: theme)}
end
```

**Advantages**:
- Source of truth on server (secure)
- Automatic state synchronization across browser tabs (via PubSub)
- Easy to test (no browser required)

---

#### Client-Side State (LiveView.JS Commands)

**When to Use**:
- UI-only state (modal open/closed, tab selection)
- No server validation needed
- Want to avoid round-trip latency

**Pattern**:
```elixir
# Component
def modal(assigns) do
  ~H"""
  <div id={@id} style="display: none;">
    <%= render_slot(@inner_block) %>
  </div>
  """
end

def show_modal(js \\ %JS{}, id) do
  js
  |> JS.show(to: "##{id}")
  |> JS.add_class("modal-open", to: "body")
end

# Usage
<.button phx-click={show_modal("confirm-dialog")}>
  Open Modal
</.button>
```

**Advantages**:
- Instant UI response (no server round-trip)
- Reduces server load
- Works offline (until needs server data)

---

#### Local State (Alpine.js)

**When to Use**:
- Complex client-side logic (dropdown click-outside, tooltip positioning)
- Multiple related UI states
- Need reactivity without server communication

**Pattern**:
```heex
<div x-data="{ open: false, selected: null }">
  <button x-on:click="open = !open">
    Toggle
  </button>

  <div x-show="open" x-on:click.outside="open = false">
    <button x-on:click="selected = 'option1'">Option 1</button>
    <button x-on:click="selected = 'option2'">Option 2</button>
  </div>

  <p x-show="selected">Selected: <span x-text="selected"></span></p>
</div>
```

**Advantages**:
- Declarative (like Vue)
- Minimal JavaScript knowledge required
- Good for local UI interactions

---

#### Global State (GenServer + PubSub)

**When to Use**:
- Cross-page state (toast notifications, global modals)
- Real-time updates (new message notifications)
- State shared across multiple LiveView processes

**Pattern**:
```elixir
# GenServer
defmodule XTweakUI.Toast do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def show(message, opts \\ []) do
    toast = %{
      id: generate_id(),
      message: message,
      color: opts[:color] || "primary",
      timeout: opts[:timeout] || 5000
    }

    # Broadcast to all LiveViews
    Phoenix.PubSub.broadcast(
      XTweakWeb.PubSub,
      "toast",
      {:show_toast, toast}
    )
  end
end

# LiveView (root layout)
def mount(_params, _session, socket) do
  if connected?(socket) do
    Phoenix.PubSub.subscribe(XTweakWeb.PubSub, "toast")
  end

  {:ok, assign(socket, toasts: [])}
end

def handle_info({:show_toast, toast}, socket) do
  {:noreply, assign(socket, toasts: [toast | socket.assigns.toasts])}
end

# Usage from anywhere
XTweakUI.Toast.show("Profile updated successfully!", color: "success")
```

**Advantages**:
- Decoupled (any process can trigger toasts)
- Real-time across all connected clients
- Reliable (GenServer supervision)

---

### 2.3 Interactivity Tiering Strategy

**Decision Framework**: Choose the right tier for each component

```
┌─────────────────────────────────────────────────────────┐
│ Decision Tree: Component Interactivity                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Does it need JavaScript?                                │
│ ├─ No ────────────────────────► Tier 1: Phoenix.Component│
│ └─ Yes                                                   │
│    │                                                     │
│    Does it need client-side state?                      │
│    ├─ No ────────────────────► Tier 2: LiveView.JS     │
│    └─ Yes                                               │
│       │                                                 │
│       Is state local to component?                      │
│       ├─ Yes ──────────────► Tier 3: Alpine.js         │
│       └─ No (or needs 3rd-party lib)                   │
│          │                                              │
│          ───────────────────► Tier 4: LiveView Hooks   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Examples by Tier**:

| Tier | Component Examples | Implementation |
|------|-------------------|----------------|
| **1** | Badge, Card, Avatar, Divider | Pure HEEx + CSS |
| **2** | Modal, Tabs, Accordion | Phoenix.Component + LiveView.JS |
| **3** | Dropdown, Popover, Tooltip | Phoenix.Component + Alpine.js |
| **4** | DatePicker, ColorPicker, Chart | Phoenix.Component + LiveView Hooks + JS libraries |

**Migration Path**: Start with higher tiers, optimize down if possible
- Phase 1-2: Implement all with Tier 3/4 (Alpine.js/Hooks)
- Phase 3: Optimize Tier 3 → Tier 2 where possible (remove Alpine.js dependency)
- Phase 4: Profile and optimize for performance

---

## 3. CSS Framework Comparison

### 3.1 Tailwind CSS (Phase 1-2 Choice)

**Chosen for**: Proven Phoenix integration, large ecosystem, Nuxt UI baseline

#### Advantages

1. **Proven Phoenix Integration**
   - Official Phoenix 1.7+ guides use Tailwind
   - Mix integration well-documented
   - Community knowledge abundant

2. **JIT Compiler Performance**
   - Build time: ~100-200ms for small projects
   - Only includes used classes
   - On-demand arbitrary values (`w-[137px]`)

3. **Plugin Ecosystem**
   - `@tailwindcss/forms` - Better form defaults
   - `@tailwindcss/typography` - Prose styling
   - `@tailwindcss/aspect-ratio` - Responsive media

4. **Nuxt UI Baseline**
   - Nuxt UI built on Tailwind
   - Direct class name mapping
   - Easier initial port

#### Configuration

**tailwind.config.js**:
```javascript
module.exports = {
  content: [
    '../lib/**/*.{ex,exs,heex}',  // Scan Phoenix templates
    '../priv/static/**/*.html'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: 'var(--color-primary-50)',
          500: 'var(--color-primary-500)',
          900: 'var(--color-primary-900)',
          // ... full scale
        }
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
```

**Build Commands**:
```bash
# Development
npx tailwindcss -i css/app.css -o ../priv/static/assets/app.css --watch

# Production
NODE_ENV=production npx tailwindcss -i css/app.css -o ../priv/static/assets/app.css --minify
```

#### Bundle Size

**Realistic Targets**:
- Phase 1 (5 components): ~25-30KB gzipped
- Phase 2 (20 components): ~40-50KB gzipped
- Phase 4 (100+ components): ~70-80KB gzipped

**Optimization Strategies**:
1. Purge unused classes (automatic in JIT mode)
2. Minimize custom CSS (use Tailwind utilities)
3. Group repeated patterns into components

---

### 3.2 UnoCSS (Phase 3 Evaluation)

**Considered for**: Performance gains, smaller bundle size

#### Advantages

1. **Performance** (claimed 5x faster than Tailwind)
   - Zero-runtime compilation
   - Regex-based engine (faster than PostCSS)
   - Instant builds for large projects

2. **Smaller Bundle Size** (claimed 20-30% reduction)
   - More efficient CSS generation
   - Better de-duplication

3. **Flexibility**
   - Tailwind-compatible (can migrate gradually)
   - Custom shortcuts/rules
   - Variant groups

#### Disadvantages

1. **Phoenix Integration** (experimental)
   - No official Phoenix guides
   - Community examples limited
   - May require custom Mix tasks

2. **Ecosystem** (smaller than Tailwind)
   - Fewer plugins
   - Less community support
   - Breaking changes more frequent

3. **Migration Risk**
   - Need to test all 100+ components
   - Class name differences possible
   - Build pipeline changes

#### Decision Criteria (Phase 3 Evaluation)

**Go/No-Go Evaluation**: Test with 3 components (Button, Input, Modal)

| Metric | Target | Weight |
|--------|--------|--------|
| **Build Time Improvement** | >30% faster | 🔴 Critical |
| **Bundle Size Reduction** | >20% smaller | 🟡 Important |
| **Phoenix Integration Complexity** | <4 hours setup | 🟡 Important |
| **Breaking Changes** | Zero visual regressions | 🔴 Critical |
| **Developer Experience** | Same or better | 🟢 Nice-to-have |

**Decision**:
- ✅ **GO** if: >30% build time improvement AND zero breaking changes
- ❌ **NO-GO** if: Any critical regressions OR >4 hours setup

**Fallback**: Stay with Tailwind CSS (zero risk)

---

### 3.3 CSS Framework Strategy: Pure Tailwind

**Decision**: xTweak UI uses ONLY pure Tailwind CSS utilities

#### Rationale

1. **Clean Slate Philosophy**
   - Goal: Port Nuxt UI API exactly to Phoenix
   - Nuxt UI uses pure Tailwind utilities → xTweak UI matches this approach
   - Build component library from the ground up with predictable, utility-first styling

2. **Zero Dependencies**
   - xTweak UI should be standalone and lightweight
   - No additional CSS frameworks required
   - Easier to migrate to UnoCSS later (Phase 3+)

3. **API Clarity**
   - Nuxt UI: `color="primary" variant="solid"` (attribute-driven)
   - xTweak UI follows Nuxt UI's attribute-driven approach
   - Component props directly control styling behavior

4. **Bundle Size Control**
   - Pure Tailwind + CSS variables: ~60KB gzipped (purged)
   - Goal: Minimize bundle size for Hex package users
   - No framework overhead

#### Implementation Approach

**xtweak_ui** (Component Library - Hex Package):
- ✅ Pure Tailwind utilities only (`bg-primary-500`, `text-white`, `hover:bg-primary-600`)
- ✅ Custom CSS variables for theming (`--color-primary`, `--color-bg-default`)
- ✅ Component-specific styles via Tailwind `@apply` (minimal usage)
- ✅ Gradual component rollout as they're ported from Nuxt UI

**Other xTweak Apps** (Internal Development):
- `xtweak_web`: Uses plain HTML + Tailwind initially, migrates to xTweak UI components as available
- `xtweak_docs`: Showcases xTweak UI components with pure Tailwind base
- `xtweak_core`: No CSS dependencies (backend only)

#### CSS Architecture Pattern

**Component Styles Example** (Button):
```elixir
# lib/xtweak_ui/button.ex
defp button_classes(color, variant, size) do
  base = "rounded-md font-medium inline-flex items-center transition-colors"

  color_variant = case {color, variant} do
    {"primary", "solid"} -> "bg-primary-500 text-white hover:bg-primary-600"
    {"primary", "outline"} -> "border border-primary-500 text-primary-500 hover:bg-primary-50"
    # ... all color/variant combinations
  end

  size_classes = case size do
    "xs" -> "px-2 py-1 text-xs gap-1"
    "sm" -> "px-2.5 py-1.5 text-xs gap-1.5"
    "md" -> "px-2.5 py-1.5 text-sm gap-1.5"
    # ... all sizes
  end

  "#{base} #{color_variant} #{size_classes}"
end
```

**CSS Variables** (Theming):
```css
/* priv/static/assets/theme.css */
:root {
  --color-primary: 99 102 241;    /* indigo-500 */
  --color-success: 34 197 94;     /* green-500 */
  --color-error: 239 68 68;       /* red-500 */
  /* ... all semantic tokens */
}

[data-theme="dark"] {
  --color-primary: 129 140 248;   /* indigo-400 */
  /* ... dark theme overrides */
}
```

**Tailwind Configuration**:
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: 'rgb(var(--color-primary) / <alpha-value>)',
        // ... other semantic colors
      }
    }
  },
  plugins: [] // Pure Tailwind, no plugins
}
```

#### Benefits of Pure Tailwind Approach

1. **Consistency**: Matches Nuxt UI's styling philosophy
2. **Lightweight**: Minimal CSS footprint (~60KB gzipped)
3. **Flexibility**: Users can customize via CSS variables
4. **Future-Proof**: Easy migration to UnoCSS (Phase 3+)
5. **No Conflicts**: No CSS specificity battles with other frameworks

---

## 4. Asset Pipeline Architecture

### 4.1 Build System

**Philosophy**: Simple, maintainable, fast

**Chosen Approach**: Tailwind CLI (no webpack/esbuild complexity for CSS)

#### Build Process Flow

```
┌─────────────────────────────────────────────────────────┐
│ Asset Pipeline Flow                                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ 1. Developer writes HEEx with Tailwind classes          │
│    ↓                                                     │
│ 2. Run: mix assets.build                                │
│    ↓                                                     │
│ 3. Mix executes: npm run build (in assets/ dir)         │
│    ↓                                                     │
│ 4. Tailwind CLI scans: ../lib/**/*.{ex,heex}            │
│    ↓                                                     │
│ 5. Generates CSS with only used classes                 │
│    ↓                                                     │
│ 6. Outputs: ../priv/static/assets/app.css               │
│    ↓                                                     │
│ 7. Phoenix serves: /assets/app.css                      │
│    ↓                                                     │
│ 8. Browser loads CSS                                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

#### package.json

**apps/xtweak_ui/assets/package.json**:
```json
{
  "name": "xtweak_ui_assets",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "build": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css",
    "watch": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css --watch",
    "deploy": "NODE_ENV=production tailwindcss -i css/app.css -o ../priv/static/assets/app.css --minify"
  },
  "devDependencies": {
    "@tailwindcss/forms": "^0.5.9",
    "tailwindcss": "^3.4.3"
  }
}
```

#### Mix Integration

**apps/xtweak_ui/mix.exs**:
```elixir
defmodule XTweakUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :xtweak_ui,
      # ... other config
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      "assets.build": ["cmd --cd assets npm run build"],
      "assets.watch": ["cmd --cd assets npm run watch"],
      "assets.deploy": ["cmd --cd assets npm run deploy"],
      "assets.install": ["cmd --cd assets npm install"]
    ]
  end
end
```

**Usage**:
```bash
# Install dependencies (first time)
mix assets.install

# Development (watch mode)
mix assets.watch

# Build once
mix assets.build

# Production build
mix assets.deploy
```

#### CSS Output Location

**apps/xtweak_ui/priv/static/assets/app.css**

This location ensures:
- Phoenix serves from `/assets/app.css`
- File included in Hex package (priv/ directory)
- Version control (committed, provides fallback)

---

### 4.2 JavaScript Strategy

**Philosophy**: Minimal JavaScript, LiveView-first

#### JavaScript Footprint Targets

| Phase | Target Size (gzipped) | Contents |
|-------|----------------------|----------|
| **Phase 1** | 0-5KB | Zero JS (CSS-only components) |
| **Phase 2** | 10-15KB | Alpine.js (~15KB) |
| **Phase 3** | 20-30KB | Alpine.js + small libraries (@floating-ui/dom ~7KB) |
| **Phase 4** | 30-50KB | Full suite (hooks for DatePicker, Charts, etc.) |

#### Hook System (Phase 2+)

**apps/xtweak_ui/assets/js/hooks.js**:
```javascript
// XTweakUI LiveView Hooks
export const XTweakUIHooks = {
  // Phase 3: Tooltip positioning
  Tooltip: {
    mounted() {
      // Initialize @floating-ui/dom
    }
  },

  // Phase 4: Color picker
  ColorPicker: {
    mounted() {
      // Initialize vanilla-picker
    }
  },

  // Phase 4: Date picker
  DatePicker: {
    mounted() {
      // Initialize date picker library
    }
  }
}
```

**apps/xtweak_ui/assets/js/app.js**:
```javascript
import { XTweakUIHooks } from "./hooks"

// Export for use in Phoenix app
window.XTweakUIHooks = XTweakUIHooks
```

**Usage in xtweak_web**:
```javascript
// apps/xtweak_web/assets/js/app.js
import { XTweakUIHooks } from "xtweak_ui/assets/js/hooks"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...XTweakUIHooks }
})
```

#### External Libraries

**Phase 2-3**:
- Alpine.js (~15KB gzipped) - Local state management

**Phase 3**:
- @floating-ui/dom (~7KB gzipped) - Popover/tooltip positioning

**Phase 4** (as needed):
- dayjs (~3KB gzipped) - Date formatting (alternative: Elixir-side with Timex)
- vanilla-picker (~8KB gzipped) - Color picker
- Chart.js (~50KB gzipped) - Charts (OR use Elixir library Contex)

**Decision Gate**: Evaluate if JS library is necessary or can be done server-side

---

### 4.3 Theme System

**Architecture**: Elixir config + CSS variables + Tailwind integration

#### Configuration Flow

```
config/config.exs
  ↓ (Application.get_env/2)
XTweakUI.Theme.get()
  ↓ (component_config/1)
Component receives theme defaults
  ↓ (assigns merge)
Final component attributes
  ↓ (render)
Tailwind classes (bg-primary-500, etc.)
  ↓ (CSS variables)
OKLCH colors rendered
```

#### Elixir Theme Module

**apps/xtweak_ui/lib/xtweak_ui/theme.ex**:
```elixir
defmodule XTweakUI.Theme do
  @moduledoc """
  Theme configuration for xTweak UI components.

  Inspired by Nuxt UI's app.config.ts, this module provides centralized
  theme configuration for colors, component defaults, and styling patterns.

  ## Configuration

  Set theme in config/config.exs:

      config :xtweak_ui, :theme,
        primary: "blue",
        gray: "slate",
        components: %{
          button: %{
            default: %{color: "primary", variant: "solid", size: "md"}
          }
        }

  ## Usage in Components

      defmodule XTweakUI.Components.Button do
        alias XTweakUI.Theme

        def button(assigns) do
          config = Theme.component_config(:button)
          color = assigns[:color] || config[:default][:color]
          # ...
        end
      end
  """

  @default_theme %{
    primary: "blue",
    gray: "slate",
    colors: %{
      primary: %{
        50: "oklch(97% 0.01 240)",
        100: "oklch(93% 0.04 240)",
        200: "oklch(87% 0.08 240)",
        300: "oklch(78% 0.12 240)",
        400: "oklch(68% 0.16 240)",
        500: "oklch(60% 0.20 240)",
        600: "oklch(52% 0.18 240)",
        700: "oklch(44% 0.14 240)",
        800: "oklch(36% 0.10 240)",
        900: "oklch(28% 0.08 240)",
        950: "oklch(20% 0.04 240)"
      },
      gray: %{
        50: "oklch(98% 0.005 240)",
        # ... full gray scale
      }
    },
    components: %{
      button: %{
        base: "inline-flex items-center justify-center font-medium rounded-lg transition-colors duration-150 disabled:opacity-50 disabled:cursor-not-allowed",
        variant: %{
          solid: "text-white",
          outline: "border-2",
          soft: "bg-opacity-10",
          ghost: "hover:bg-opacity-10",
          link: "underline-offset-4 hover:underline"
        },
        size: %{
          xs: "px-2 py-1 text-xs",
          sm: "px-3 py-1.5 text-sm",
          md: "px-4 py-2 text-base",
          lg: "px-5 py-2.5 text-lg",
          xl: "px-6 py-3 text-xl"
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
  Get the current theme configuration.

  Falls back to default theme if not configured.
  """
  def get do
    Application.get_env(:xtweak_ui, :theme, @default_theme)
  end

  @doc """
  Get configuration for a specific component.

  Returns an empty map if component not configured.
  """
  def component_config(component) when is_atom(component) do
    get()[:components][component] || %{}
  end

  @doc """
  Get color value for a specific shade.
  """
  def color(name, shade) when is_binary(name) and is_integer(shade) do
    get()[:colors][String.to_atom(name)][shade]
  end
end
```

#### CSS Variables

**apps/xtweak_ui/assets/css/theme.css**:
```css
/* Base theme (light mode) */
:root {
  /* Primary color scale */
  --color-primary-50: oklch(97% 0.01 240);
  --color-primary-500: oklch(60% 0.20 240);
  --color-primary-900: oklch(28% 0.08 240);

  /* UI tokens */
  --ui-bg-default: oklch(100% 0 0);
  --ui-bg-subtle: oklch(98% 0.005 240);
  --ui-text-default: oklch(20% 0 0);
  --ui-text-muted: oklch(50% 0.02 240);
  --ui-border-default: oklch(85% 0.01 240);
}

/* Dark theme */
:root[data-theme="dark"] {
  /* Adjust primary for dark mode (lighter for visibility) */
  --color-primary-50: oklch(20% 0.04 240);
  --color-primary-500: oklch(70% 0.20 240);
  --color-primary-900: oklch(97% 0.01 240);

  /* Dark UI tokens */
  --ui-bg-default: oklch(15% 0 0);
  --ui-bg-subtle: oklch(18% 0.005 240);
  --ui-text-default: oklch(95% 0 0);
  --ui-text-muted: oklch(60% 0.02 240);
  --ui-border-default: oklch(25% 0.01 240);
}
```

#### Tailwind Integration

**apps/xtweak_ui/assets/tailwind.config.js**:
```javascript
module.exports = {
  content: ['../lib/**/*.{ex,exs,heex}'],
  theme: {
    extend: {
      colors: {
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
          950: 'var(--color-primary-950)'
        },
        ui: {
          bg: {
            default: 'var(--ui-bg-default)',
            subtle: 'var(--ui-bg-subtle)'
          },
          text: {
            default: 'var(--ui-text-default)',
            muted: 'var(--ui-text-muted)'
          },
          border: {
            default: 'var(--ui-border-default)'
          }
        }
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
```

**Usage in Components**:
```elixir
<button class="bg-primary-500 text-white hover:bg-primary-600">
  Click me
</button>
```

Compiles to:
```css
.bg-primary-500 {
  background-color: var(--color-primary-500);
}
```

Which resolves to:
```css
/* Light mode */
background-color: oklch(60% 0.20 240);

/* Dark mode */
background-color: oklch(70% 0.20 240);
```

#### Runtime Theme Switching

**LiveView**:
```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, theme: "light")}
end

def handle_event("toggle_theme", _, socket) do
  new_theme = if socket.assigns.theme == "light", do: "dark", else: "light"
  {:noreply, assign(socket, theme: new_theme)}
end
```

**Template**:
```heex
<html data-theme={@theme}>
  <body>
    <.button phx-click="toggle_theme">
      Toggle Theme
    </.button>
  </body>
</html>
```

**Result**: All components update colors instantly (CSS variables change)

---

## 5. Gap Analysis

### 5.1 Features NOT Ported (Out of Scope)

These Nuxt UI features will NOT be ported to Phoenix:

1. **Nuxt UI Pro Components** (paid license required)
   - Dashboard templates
   - Landing page components
   - Authentication forms

2. **Vue-Specific Features**
   - Reactive refs (`ref()`, `reactive()`)
   - Computed properties (`computed()`)
   - Watchers (`watch()`, `watchEffect()`)
   - Vue Router integration

3. **Nuxt-Specific Features**
   - `useAsyncData()` - Use Phoenix assigns instead
   - `useFetch()` - Use LiveView events or Ecto queries
   - `definePageMeta()` - Use Phoenix router
   - Server routes - Use Phoenix controllers

4. **JavaScript Routing**
   - Client-side routing - Phoenix handles routing server-side
   - Route transitions - Use LiveView page transitions

5. **Build-Time Optimizations** (Vue/Vite specific)
   - Component tree shaking - Not applicable
   - Auto-imports - Use explicit imports in Elixir

---

### 5.2 Features Adapted for Phoenix

These Nuxt UI patterns are adapted to Phoenix idioms:

#### Composables → GenServer + PubSub

**Nuxt UI**:
```javascript
const toast = useToast()
toast.add({ title: 'Success!' })

const modal = useModal()
modal.open(MyComponent)

const notifications = useNotifications()
notifications.add({ title: 'New message' })
```

**Phoenix Equivalent**:
```elixir
# Toast
XTweakUI.Toast.show("Success!")

# Modal (via LiveView update)
send_update(XTweakUI.Components.Modal, id: :my_modal, open: true)

# Notifications (via PubSub)
Phoenix.PubSub.broadcast(XTweakWeb.PubSub, "notifications:#{user_id}", {:new_notification, %{title: "New message"}})
```

---

#### v-model → phx-change + Server Assigns

**Nuxt UI**:
```vue
<UInput v-model="username" />
<!-- Two-way binding -->
```

**Phoenix Equivalent**:
```elixir
<.input
  field={@form[:username]}
  value={@username}
  phx-change="update_username"
/>
<!-- One-way flow: view → event → server → view -->

def handle_event("update_username", %{"value" => value}, socket) do
  {:noreply, assign(socket, username: value)}
end
```

---

#### Client-Side Validation → Phoenix.HTML.Form + LiveView

**Nuxt UI** (Vuelidate/Yup):
```javascript
const schema = yup.object({
  email: yup.string().email().required()
})
```

**Phoenix Equivalent** (Ecto changeset):
```elixir
def changeset(user, attrs) do
  user
  |> cast(attrs, [:email])
  |> validate_required([:email])
  |> validate_format(:email, ~r/@/)
end

# LiveView
def handle_event("validate", %{"user" => params}, socket) do
  changeset =
    %User{}
    |> User.changeset(params)
    |> Map.put(:action, :validate)

  {:noreply, assign(socket, form: to_form(changeset))}
end
```

---

#### Route Awareness → Phoenix Router Helpers

**Nuxt UI**:
```vue
<UButton :to="{ name: 'profile' }" active-class="active">
  Profile
</UButton>
<!-- Detects current route -->
```

**Phoenix Equivalent**:
```elixir
<.link
  navigate={~p"/profile"}
  class={if @current_path == "/profile", do: "active", else: ""}
>
  Profile
</.link>

# Get current path in mount/3
def mount(_params, _session, socket) do
  {:ok, assign(socket, current_path: socket.assigns.live_action)}
end
```

---

### 5.3 Unique Phoenix Advantages

These features are BETTER in Phoenix than Nuxt UI:

1. **Server-Rendered by Default**
   - All components SEO-friendly (no hydration needed)
   - Faster time-to-interactive (no JavaScript bundle download)
   - Works without JavaScript (progressive enhancement)

2. **Zero JavaScript for Simple Components**
   - Button, Badge, Card, Avatar = 0 KB JS
   - Nuxt UI requires Vue runtime (~50KB gzipped minimum)

3. **LiveView Assigns (Simpler Than Vue Reactive)**
   - No `ref()`, `reactive()`, `computed()` complexity
   - Explicit state flow: `assign(socket, key, value)`
   - Easy to test (no browser required)

4. **PubSub for Cross-Page Updates**
   - Toast notifications appear on ALL tabs automatically
   - Real-time updates without polling
   - Built into Phoenix (no extra library)

5. **Type Safety with TypeSpec** (Phase 3+)
   - `@spec button(map()) :: Phoenix.LiveView.Rendered.t()`
   - Compile-time type checking with Dialyzer
   - Better than TypeScript (stricter, no runtime overhead)

6. **Pattern Matching for Variants**
   ```elixir
   defp variant_classes("solid", "primary"), do: "bg-primary-500 text-white"
   defp variant_classes("outline", "primary"), do: "border-primary-500 text-primary-500"
   # Compile-time exhaustiveness checking
   ```

---

## 6. MCP Tool Workflow

**CRITICAL**: This section documents the PRIMARY tools for component porting

### 6.1 Nuxt UI MCP Server (PRIMARY Tool)

**Overview**: Dedicated MCP server providing structured access to Nuxt UI component documentation

**Installation** (Already Completed):
```bash
claude mcp add --transport http nuxt-ui-remote https://ui.nuxt.com/mcp
```

**Configuration** (`.mcp.json`):
```json
{
  "nuxt-ui-remote": {
    "type": "http",
    "url": "https://ui.nuxt.com/mcp"
  }
}
```

---

#### Available Tools

**Component Research**:
1. `mcp__nuxt_ui__list_components` - Browse all 105 components with categories
2. `mcp__nuxt_ui__get_component` - Full component documentation
3. `mcp__nuxt_ui__get_component_metadata` - Props, slots, events details
4. `mcp__nuxt_ui__search_components_by_category` - Filter by category

**Templates & Examples**:
5. `mcp__nuxt_ui__list_templates` - Project templates
6. `mcp__nuxt_ui__get_template` - Template setup instructions
7. `mcp__nuxt_ui__list_examples` - Code examples
8. `mcp__nuxt_ui__get_example` - Specific example code

**Documentation**:
9. `mcp__nuxt_ui__list_documentation_pages` - Browse all docs
10. `mcp__nuxt_ui__get_documentation_page` - Fetch page content
11. `mcp__nuxt_ui__list_getting_started_guides` - Installation guides

**Migration**:
12. `mcp__nuxt_ui__get_migration_guide` - Version upgrade paths

---

#### Standard Workflow (MANDATORY)

**Before implementing ANY component**, follow this workflow:

```bash
# Step 1: Component Discovery
mcp__nuxt_ui__list_components
# Output: All components with categories, descriptions

# Step 2: Get Full Documentation
mcp__nuxt_ui__get_component "Button"
# Output: Complete Button component documentation

# Step 3: Get Detailed Metadata
mcp__nuxt_ui__get_component_metadata "Button"
# Output: All props, slots, events with types and defaults

# Step 4: Get Code Examples
mcp__nuxt_ui__get_example "Button"
# Output: Example usage code

# Step 5: Search Related Components (if needed)
mcp__nuxt_ui__search_components_by_category "forms"
# Output: All form-related components
```

---

#### Example: Button Component Research

**Command 1: Get Component Documentation**
```bash
mcp__nuxt_ui__get_component "Button"
```

**Expected Output** (structured JSON):
```json
{
  "name": "Button",
  "description": "Button component with multiple variants and sizes",
  "category": "Elements",
  "props": {
    "color": {
      "type": "String",
      "default": "primary",
      "description": "Button color theme"
    },
    "variant": {
      "type": "String",
      "default": "solid",
      "options": ["solid", "outline", "soft", "ghost", "link"]
    },
    "size": {
      "type": "String",
      "default": "md",
      "options": ["xs", "sm", "md", "lg", "xl"]
    },
    "loading": {
      "type": "Boolean",
      "default": false
    },
    "disabled": {
      "type": "Boolean",
      "default": false
    },
    "icon": {
      "type": "String",
      "default": null
    }
  },
  "slots": {
    "leading": "Content before button text",
    "default": "Button text",
    "trailing": "Content after button text"
  },
  "events": {
    "click": "Emitted when button is clicked"
  }
}
```

**Command 2: Get Metadata**
```bash
mcp__nuxt_ui__get_component_metadata "Button"
```

**Expected Output**:
```json
{
  "props": [
    {
      "name": "color",
      "type": "String",
      "required": false,
      "default": "primary",
      "validator": ["primary", "secondary", "success", "warning", "error", "gray"]
    },
    {
      "name": "variant",
      "type": "String",
      "required": false,
      "default": "solid",
      "validator": ["solid", "outline", "soft", "ghost", "link"]
    }
    // ... more props
  ],
  "slots": [
    {
      "name": "leading",
      "description": "Content displayed before button text",
      "props": {}
    },
    {
      "name": "default",
      "description": "Main button content",
      "props": {}
    },
    {
      "name": "trailing",
      "description": "Content displayed after button text",
      "props": {}
    }
  ],
  "events": [
    {
      "name": "click",
      "description": "Emitted when button is clicked",
      "payload": "MouseEvent"
    }
  ]
}
```

**Command 3: Get Examples**
```bash
mcp__nuxt_ui__get_example "Button"
```

**Expected Output**:
```json
{
  "examples": [
    {
      "title": "Basic Button",
      "code": "<UButton>Click me</UButton>"
    },
    {
      "title": "Button with Icon",
      "code": "<UButton icon=\"i-heroicons-magnifying-glass\">Search</UButton>"
    },
    {
      "title": "Button Variants",
      "code": "<UButton variant=\"outline\" color=\"primary\">Outline</UButton>"
    }
  ]
}
```

---

#### Translation to Phoenix

**Using fetched data**, create Phoenix.Component:

```elixir
defmodule XTweakUI.Components.Button do
  use Phoenix.Component
  alias XTweakUI.Theme

  # Props from metadata
  attr :color, :string, default: "primary", values: ["primary", "secondary", "success", "warning", "error", "gray"]
  attr :variant, :string, default: "solid", values: ["solid", "outline", "soft", "ghost", "link"]
  attr :size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"]
  attr :loading, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :icon, :string, default: nil
  attr :rest, :global  # All other HTML attributes

  # Slots from metadata
  slot :leading
  slot :inner_block, required: true
  slot :trailing

  @doc """
  Renders a button component with multiple variants and sizes.

  ## Examples

      <.button>Click me</.button>

      <.button variant="outline" color="primary">
        Outline Button
      </.button>

      <.button icon="hero-magnifying-glass">
        Search
      </.button>

      <.button loading={true}>
        Saving...
      </.button>
  """
  def button(assigns) do
    ~H"""
    <button
      class={button_classes(@color, @variant, @size, @loading)}
      disabled={@disabled || @loading}
      {@rest}
    >
      <%= if @loading do %>
        <span class="animate-spin">⟳</span>
      <% end %>

      <%= render_slot(@leading) %>

      <%= if @icon && !@loading do %>
        <.icon name={@icon} class="w-5 h-5" />
      <% end %>

      <%= render_slot(@inner_block) %>

      <%= render_slot(@trailing) %>
    </button>
    """
  end

  defp button_classes(color, variant, size, loading) do
    config = Theme.component_config(:button)

    [
      config[:base],
      variant_classes(variant, color),
      size_classes(size),
      loading && "cursor-wait"
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  # ... helper functions
end
```

---

#### Success Criteria

For EVERY component implementation:
- ✅ Fetched documentation with `get_component`
- ✅ Fetched metadata with `get_component_metadata`
- ✅ Fetched examples with `get_example`
- ✅ All props mapped to Phoenix attrs
- ✅ All slots mapped to Phoenix slots
- ✅ Examples translated to Phoenix syntax
- ✅ API parity verified (no missing features)

---

### 6.2 Tidewave MCP Server (Elixir/Phoenix Verification)

**Use Cases**: Verify Phoenix/Elixir patterns, check Hex documentation

**Available Tools**:
- `mcp__tidewave__project_eval` - Evaluate Elixir code in project context
- `mcp__tidewave__get_docs` - Get documentation for modules/functions
- `mcp__tidewave__search_package_docs` - Search Hex package docs
- `mcp__tidewave__get_logs` - Check project logs for errors
- `mcp__tidewave__get_ecto_schemas` - List Ecto schemas (not used in xtweak_ui)
- `mcp__tidewave__execute_sql_query` - Debug database (not used in xtweak_ui)

---

#### Example Workflows

**Verify Phoenix.Component API**:
```bash
mcp__tidewave__get_docs "Phoenix.Component"
# Output: Full Phoenix.Component documentation
```

**Check LiveView Patterns**:
```bash
mcp__tidewave__search_package_docs "Phoenix.LiveView" --query "phx-click"
# Output: Documentation for phx-click event binding
```

**Runtime Checks**:
```bash
mcp__tidewave__project_eval "XTweakUI.Theme.get()"
# Output: Current theme configuration
```

**Debug Errors**:
```bash
mcp__tidewave__get_logs --tail 50 --grep "error"
# Output: Last 50 log entries containing "error"
```

---

### 6.3 Context7 MCP Server (Other Libraries)

**Use Cases**: Research non-Elixir, non-Nuxt UI libraries

**When to Use**:
- ✅ Alpine.js API (for Tier 3 components)
- ✅ @floating-ui/dom documentation (tooltip positioning)
- ✅ Tailwind CSS plugin docs
- ✅ Chart.js API (if using for charts)
- ❌ NOT for Nuxt UI (use dedicated Nuxt UI MCP instead)
- ❌ NOT for Elixir/Phoenix (use Tidewave MCP instead)

---

#### Workflow

**Step 1: Resolve Library ID**:
```bash
mcp__context7__resolve-library-id "alpine.js"
# Output: Library identifier (e.g., "/alpinejs/alpine")
```

**Step 2: Get Documentation**:
```bash
mcp__context7__get-library-docs "/alpinejs/alpine" --topic "x-data directive"
# Output: Alpine.js x-data documentation
```

---

### 6.4 MCP Workflow Summary

**Hierarchy** (use in this order):

```
1. Nuxt UI MCP Server ⭐ (PRIMARY for component porting)
   └─ Use for: ALL Nuxt UI component research

2. Tidewave MCP Server (Elixir/Phoenix verification)
   └─ Use for: Phoenix.Component API, LiveView patterns, Hex packages

3. Context7 MCP Server (Fallback for other libraries)
   └─ Use for: Alpine.js, @floating-ui/dom, Tailwind plugins
```

**Standard Component Porting Workflow**:

```bash
# Before implementation (MANDATORY):
1. mcp__nuxt_ui__get_component "[ComponentName]"
2. mcp__nuxt_ui__get_component_metadata "[ComponentName]"
3. mcp__nuxt_ui__get_example "[ComponentName]"

# During implementation (as needed):
4. mcp__tidewave__get_docs "Phoenix.Component"  # Verify Phoenix API
5. mcp__context7__get-library-docs [library] --topic [topic]  # External libs

# After implementation (verification):
6. mcp__tidewave__project_eval "XTweakUI.Theme.component_config(:button)"
7. mcp__tidewave__get_logs --tail 50  # Check for errors
```

---

## 7. Testing Strategy Overview

**Detailed documentation**: See `07-testing-strategy.md`

**Brief Overview**:

### Test Pyramid

```
        ┌─────────┐
        │   E2E   │  10% (Playwright - full user flows)
        ├─────────┤
        │  Integration  │  20% (Phoenix.LiveViewTest - component integration)
        ├─────────────┤
        │    Unit      │  70% (ExUnit - component rendering, helpers)
        └─────────────┘
```

### Coverage Targets

| Phase | Target | Enforcement |
|-------|--------|-------------|
| Phase 1 | 60% | Recommended |
| Phase 2 | 80% | CI/CD fails below 75% |
| Phase 3 | 85% | CI/CD fails below 80% |
| Phase 4 | 90% | CI/CD fails below 85% |

### Testing Tools

- **ExUnit** - Elixir test framework
- **Phoenix.LiveViewTest** - Component testing
- **Playwright MCP** - Visual regression, accessibility
- **ExCoveralls** - Coverage reporting
- **Credo** - Code quality (strict mode)
- **Dialyzer** - Static type analysis

---

## 8. Documentation Requirements

### 8.1 Component Documentation Template

**EVERY component MUST have**:

```elixir
defmodule XTweakUI.Components.Button do
  use Phoenix.Component

  @moduledoc """
  Renders a button component with multiple variants, sizes, and colors.

  Inspired by Nuxt UI's Button component: https://ui.nuxt.com/components/button

  ## Features

  - Multiple variants (solid, outline, soft, ghost, link)
  - Size options (xs, sm, md, lg, xl)
  - Color themes (primary, secondary, success, warning, error, gray)
  - Loading state with spinner
  - Icon support (leading/trailing)
  - Full keyboard accessibility

  ## Examples

      # Basic button
      <.button>Click me</.button>

      # Button with variant and color
      <.button variant="outline" color="primary">
        Outline Button
      </.button>

      # Button with loading state
      <.button loading={@saving}>
        Save Changes
      </.button>

      # Button with icon
      <.button icon="hero-magnifying-glass">
        Search
      </.button>

      # Button with leading/trailing slots
      <.button>
        <:leading>
          <.icon name="hero-plus" />
        </:leading>
        Create New
        <:trailing>
          <.kbd>⌘N</.kbd>
        </:trailing>
      </.button>

  ## Accessibility

  - Uses semantic `<button>` element
  - Disabled state properly communicated to screen readers
  - Loading state announced with aria-live
  - Keyboard navigation supported (Tab, Enter, Space)

  ## Props

  See attr documentation below for all available props.
  """

  # attr definitions...
  # slot definitions...
  # function implementation...
end
```

### 8.2 ExDoc Configuration

**apps/xtweak_ui/mix.exs**:
```elixir
def project do
  [
    # ... other config
    name: "xTweak UI",
    source_url: "https://github.com/fodurrr/xTweak",
    docs: docs()
  ]
end

defp docs do
  [
    main: "XTweakUI",
    logo: "priv/static/images/logo.png",
    extras: [
      "README.md": [title: "Overview"],
      "CHANGELOG.md": [title: "Changelog"],
      "guides/getting-started.md": [title: "Getting Started"],
      "guides/theming.md": [title: "Theming"],
      "guides/accessibility.md": [title: "Accessibility"]
    ],
    groups_for_modules: [
      "Elements": [~r/XTweakUI.Components.(Button|Badge|Avatar|Icon)/],
      "Forms": [~r/XTweakUI.Components.(Input|Select|Checkbox|Radio|Form)/],
      "Navigation": [~r/XTweakUI.Components.(Dropdown|Tabs|Breadcrumb|Link)/],
      "Overlays": [~r/XTweakUI.Components.(Modal|Toast|Tooltip|Popover)/],
      "Data": [~r/XTweakUI.Components.(Table|Card|Alert|Progress)/],
      "Layout": [~r/XTweakUI.Components.(Container|Divider|Separator)/],
      "Theming": [XTweakUI.Theme]
    ],
    groups_for_extras: [
      "Guides": ~r/guides\/.*/
    ]
  ]
end
```

### 8.3 Live Showcase (xtweak_docs)

**Purpose**: Interactive component demos

**Structure**:
```
apps/xtweak_docs/lib/xtweak_docs_web/live/
├── showcase_live.ex           # Main showcase page
├── components/
│   ├── button_showcase.ex     # Button demos
│   ├── badge_showcase.ex      # Badge demos
│   └── ...
└── helpers/
    ├── code_preview.ex        # Code example display
    └── variant_grid.ex        # Variant/size matrix
```

**Example Showcase Component**:
```elixir
defmodule XTweakDocsWeb.ButtonShowcase do
  use XTweakDocsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="space-y-8">
      <section>
        <h2>Variants</h2>
        <div class="flex gap-4">
          <.button variant="solid">Solid</.button>
          <.button variant="outline">Outline</.button>
          <.button variant="soft">Soft</.button>
          <.button variant="ghost">Ghost</.button>
          <.button variant="link">Link</.button>
        </div>

        <.code_preview>
          ```heex
          <.button variant="solid">Solid</.button>
          <.button variant="outline">Outline</.button>
          ```
        </.code_preview>
      </section>

      <!-- More sections: colors, sizes, states, etc. -->
    </div>
    """
  end
end
```

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-10-29 | 1.0.0 | Initial technical specification | Claude (Sonnet 4.5) |

---

**Document Status**: ✅ Ready for Review
**Next Update**: End of Phase 1 (Week 4)
**Maintained By**: Tech Lead

**Related Documents**:
- [02-requirements.md](./02-requirements.md) - Formal requirements
- [03-architecture.md](./03-architecture.md) - System architecture
- [04-component-inventory.md](./04-component-inventory.md) - Component mapping
- [07-testing-strategy.md](./07-testing-strategy.md) - QA approach
- [QUICK_START.md](./QUICK_START.md) - Getting started guide
- [docs/mcp/nuxt-ui-setup.md](../mcp/nuxt-ui-setup.md) - MCP setup guide
