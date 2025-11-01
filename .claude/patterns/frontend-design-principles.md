# Frontend Design Principles Pattern

**Pattern**: `frontend-design-principles`
**Purpose**: Enforce consistent frontend development using Phoenix LiveView, Ash Framework forms, and Tailwind CSS
**Updated**: November 1, 2025
**Scope**: Frontend agents implementing UI components (Phoenix LiveView + Ash + Pure Tailwind)

---

## Problem

Frontend implementations can become inconsistent when:
- Component framework classes (DaisyUI, Flowbite) are mixed with pure Tailwind
- Custom CSS files are created for one-off styling
- Forms bypass Ash Framework helpers
- Accessibility and responsive design are afterthoughts
- Testing workflows are ad-hoc

## Solution

Agents implementing frontend components must strictly adhere to these principles for all LiveView UI development.

## Core Frontend Principles (Phoenix LiveView + Ash + Pure Tailwind)

### 1. The "Pure Utility-First" Workflow

This is the non-negotiable workflow for all LiveView UI development.

1. **ALWAYS** use pure Tailwind CSS utility classes for all styling (e.g., `class="bg-blue-500 text-white px-4 py-2 rounded"`).

2. **LEVERAGE** CSS variables for theming and consistent design tokens (e.g., `class="bg-primary text-white"`).

3. **NEVER** rely on component framework classes (DaisyUI, Flowbite, etc.) - xTweak UI provides Phoenix components with Nuxt UI-inspired APIs.

4. **NEVER** write custom CSS files for one-off component styling. All styling must be achieved through utility classes in the template files.

#### Bad Example (Using component framework classes)

```elixir
# Bad: Relying on external component framework
def button(assigns) do
  ~H"""
  <button class="btn btn-primary">
    <%= @label %>
  </button>
  """
end
```

#### Good Example (Pure Tailwind Utilities)

```elixir
# Good: Pure Tailwind utilities with CSS variables
def button(assigns) do
  ~H"""
  <button class="bg-primary hover:bg-primary-600 text-white font-medium px-4 py-2 rounded-lg transition-colors">
    <%= @label %>
  </button>
  """
end
```

#### Best Example (Using xTweak UI Components)

```elixir
# Best: Using xTweak UI component library
import XTweakUI.Button

def my_component(assigns) do
  ~H"""
  <.button color="primary" size="md">
    <%= @label %>
  </.button>
  """
end
```

### 2. Theming and Responsiveness

1. **PREFER** using CSS variable-based semantic colors (`bg-primary`, `text-success`, `border-error`) over raw Tailwind colors (`blue-500`, `green-600`). This ensures components work correctly across all themes (including dark mode).

2. **ALWAYS** build for mobile-first. Apply base styles for the smallest breakpoint and use responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`) to add or override styles for larger screens.

3. **USE** `data-theme` attribute for runtime theme switching (e.g., `<html data-theme="dark">`).

#### CSS Variables Configuration

```css
/* assets/css/theme.css */
:root {
  --color-primary: 99 102 241;      /* indigo-500 */
  --color-success: 34 197 94;       /* green-500 */
  --color-error: 239 68 68;         /* red-500 */
  --color-warning: 251 191 36;      /* amber-400 */
}

[data-theme="dark"] {
  --color-primary: 129 140 248;     /* indigo-400 */
  --color-success: 74 222 128;      /* green-400 */
  --color-error: 248 113 113;       /* red-400 */
}
```

#### Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: 'rgb(var(--color-primary) / <alpha-value>)',
        success: 'rgb(var(--color-success) / <alpha-value>)',
        error: 'rgb(var(--color-error) / <alpha-value>)',
        warning: 'rgb(var(--color-warning) / <alpha-value>)',
      }
    }
  }
}
```

#### Good Example (Responsive and Themed LiveView Component)

```elixir
def album_card(assigns) do
  ~H"""
  <div class="flex flex-col lg:flex-row bg-white dark:bg-gray-800 rounded-lg shadow-xl overflow-hidden">
    <div class="p-6">
      <h2 class="text-2xl font-bold text-primary mb-2"><%= @album.title %></h2>
      <p class="text-gray-600 dark:text-gray-300"><%= @album.description %></p>
      <div class="mt-4 flex justify-end">
        <button
          class="bg-primary hover:bg-primary-600 text-white font-medium px-4 py-2 rounded-lg transition-colors"
          phx-click="play"
          phx-value-id={@album.id}
        >
          Listen
        </button>
      </div>
    </div>
  </div>
  """
end
```

### 3. xTweak UI Component Library

Always check xTweak UI for pre-built Phoenix components before creating custom ones:

- **Forms**: Button, Input, Textarea, Select, Checkbox, Radio, FormGroup
- **Navigation**: Link, Dropdown, Tabs, Breadcrumb, Pagination
- **Feedback**: Alert, Modal, Toast, Tooltip, Progress
- **Layout**: Card, Badge, Avatar, Divider, Container
- **Data Display**: Table, Accordion, Kbd

**Documentation**: See xtweak_docs app for full API reference and examples.

### 4. Ash Form Handling Best Practices

**ALWAYS** use Ash forms with AshPhoenix helpers, never raw Phoenix forms.

```elixir
# Good: Using Ash forms with xTweak UI components
def user_form(assigns) do
  ~H"""
  <.simple_form
    for={@form}
    id="user-form"
    phx-target={@myself}
    phx-change="validate"
    phx-submit="save"
  >
    <div class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Email
        </label>
        <.input
          field={@form[:email]}
          type="email"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
          placeholder="user@example.com"
        />
        <.error field={@form[:email]} class="mt-1 text-sm text-error" />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Role
        </label>
        <.input
          field={@form[:role]}
          type="select"
          options={[:user, :node_operator, :admin]}
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
        />
        <.error field={@form[:role]} class="mt-1 text-sm text-error" />
      </div>
    </div>

    <:actions>
      <button
        type="submit"
        class="bg-primary hover:bg-primary-600 disabled:bg-gray-300 disabled:cursor-not-allowed text-white font-medium px-4 py-2 rounded-lg transition-colors"
        disabled={!@form.source.valid?}
      >
        Save User
      </button>
    </:actions>
  </.simple_form>
  """
end

# In the LiveView module
def mount(_params, _session, socket) do
  form =
    XTweak.Core.User
    |> AshPhoenix.Form.for_create(:create)

  {:ok, assign(socket, form: form)}
end

def handle_event("validate", %{"form" => params}, socket) do
  form = AshPhoenix.Form.validate(socket.assigns.form, params)
  {:noreply, assign(socket, form: form)}
end

def handle_event("save", %{"form" => params}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
    {:ok, _user} ->
      {:noreply,
       socket
       |> put_flash(:info, "User created successfully")
       |> push_navigate(to: ~p"/users")}

    {:error, form} ->
      {:noreply, assign(socket, form: form)}
  end
end
```

## Frontend Testing with Playwright MCP Server

### 5. Automated Testing Workflow

Use the Playwright MCP server for comprehensive frontend testing. This provides powerful browser automation capabilities directly within your development environment.

#### Available Playwright MCP Tools

```bash
# Browser Control
mcp__playwright__browser_navigate          # Navigate to URLs
mcp__playwright__browser_snapshot          # Capture accessibility tree
mcp__playwright__browser_take_screenshot   # Visual regression testing
mcp__playwright__browser_click            # Interact with elements
mcp__playwright__browser_type             # Type into inputs
mcp__playwright__browser_fill_form        # Fill multiple form fields

# Testing & Validation
mcp__playwright__browser_evaluate         # Execute JavaScript for assertions
mcp__playwright__browser_wait_for        # Wait for elements/conditions
mcp__playwright__browser_console_messages # Check console errors
mcp__playwright__browser_network_requests # Monitor API calls

# Advanced Features
mcp__playwright__browser_tabs            # Multi-tab testing
mcp__playwright__browser_handle_dialog   # Handle alerts/confirmations
mcp__playwright__browser_file_upload     # Test file uploads
```

#### Testing LiveView Forms Example

```javascript
// 1. Navigate to the LiveView page
mcp__playwright__browser_navigate({ url: "http://localhost:4000/users/new" })

// 2. Take accessibility snapshot for testing
mcp__playwright__browser_snapshot()

// 3. Fill Ash form fields
mcp__playwright__browser_fill_form({
  fields: [
    { name: "Email field", ref: "input[name='form[email]']", type: "textbox", value: "test@example.com" },
    { name: "Role select", ref: "select[name='form[role]']", type: "combobox", value: "node_operator" }
  ]
})

// 4. Submit the form
mcp__playwright__browser_click({
  element: "Save button",
  ref: "button[type='submit']"
})

// 5. Wait for success message
mcp__playwright__browser_wait_for({ text: "User created successfully" })

// 6. Verify no console errors
mcp__playwright__browser_console_messages()
```

### 6. Accessibility Testing

**ALWAYS** ensure LiveView components are accessible:

1. Use `mcp__playwright__browser_snapshot()` to capture the accessibility tree
2. Verify proper ARIA labels and roles are present
3. Test keyboard navigation with `mcp__playwright__browser_press_key()`
4. Ensure proper focus management in LiveView interactions

#### Accessibility Checklist

- [ ] All interactive elements are keyboard accessible
- [ ] Form inputs have associated labels
- [ ] Images have alt text
- [ ] Color contrast meets WCAG AA standards (4.5:1 for normal text, 3:1 for large text)
- [ ] ARIA attributes are used correctly
- [ ] Focus indicators are visible
- [ ] LiveView updates announce to screen readers

### 7. Visual Regression Testing

Use screenshots to catch unintended visual changes in LiveView components:

```javascript
// Take baseline screenshot of LiveView component
mcp__playwright__browser_take_screenshot({
  filename: "user-form-baseline.png",
  fullPage: false,
  element: "User form",
  ref: "#user-form"
})

// After LiveView updates
mcp__playwright__browser_wait_for({ text: "Validation error" })

// Take screenshot of error state
mcp__playwright__browser_take_screenshot({
  filename: "user-form-error-state.png",
  element: "User form with errors",
  ref: "#user-form"
})
```

## Phoenix LiveView Component Patterns

### 8. LiveView Component Best Practices

Build reusable LiveView components with pure Tailwind utilities:

```elixir
defmodule XTweakWeb.Components.DataTable do
  use Phoenix.Component

  attr :rows, :list, required: true
  attr :columns, :list, required: true
  slot :action, doc: "Action buttons for each row"

  def data_table(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
        <thead class="bg-gray-50 dark:bg-gray-800">
          <tr>
            <%= for col <- @columns do %>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                <%= col.label %>
              </th>
            <% end %>
            <th :if={@action != []} class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
              Actions
            </th>
          </tr>
        </thead>
        <tbody class="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
          <tr :for={row <- @rows} class="hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
            <%= for col <- @columns do %>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100">
                <%= Map.get(row, col.field) %>
              </td>
            <% end %>
            <td :if={@action != []} class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <%= render_slot(@action, row) %>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
```

### 9. Real-time UI Updates with Streams

For real-time features using Phoenix streams:

```elixir
def notification_list(assigns) do
  ~H"""
  <div id="notifications" phx-update="stream" class="space-y-2">
    <div
      :for={{dom_id, notification} <- @streams.notifications}
      id={dom_id}
      class="flex items-center gap-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 animate-slide-in"
    >
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 text-blue-500">
        <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
      </svg>
      <span class="flex-1 text-sm text-gray-700 dark:text-gray-300">
        <%= notification.message %>
      </span>
      <button
        class="px-3 py-1 text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-100 transition-colors"
        phx-click="dismiss"
        phx-value-id={notification.id}
      >
        Dismiss
      </button>
    </div>
  </div>
  """
end
```

### 10. Loading States and Skeletons

Implement smooth loading states for async operations:

```elixir
def resource_list(assigns) do
  ~H"""
  <div>
    <!-- Loading state -->
    <div :if={@loading} class="space-y-4">
      <div class="animate-pulse flex space-x-4">
        <div class="flex-1 space-y-6 py-1">
          <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
          <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
          <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
        </div>
      </div>
    </div>

    <!-- Loaded content -->
    <div :if={!@loading} class="space-y-4">
      <div :for={resource <- @resources} class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h3 class="text-xl font-bold text-gray-900 dark:text-gray-100 mb-2">
          <%= resource.name %>
        </h3>
        <p class="text-gray-600 dark:text-gray-300">
          <%= resource.description %>
        </p>
      </div>
    </div>
  </div>
  """
end
```

## Common LiveView Patterns

### Navigation Component

```elixir
defmodule XTweakWeb.Components.Navigation do
  use Phoenix.Component

  def navbar(assigns) do
    ~H"""
    <nav class="bg-white dark:bg-gray-800 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              <.link navigate={~p"/"} class="text-xl font-bold text-primary">
                xTweak
              </.link>
            </div>
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <.link
                navigate={~p"/dashboard"}
                class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
              >
                Dashboard
              </.link>
              <.link
                navigate={~p"/nodes"}
                class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
              >
                Nodes
              </.link>
              <.link
                navigate={~p"/users"}
                class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
              >
                Users
              </.link>
            </div>
          </div>
          <div class="flex items-center">
            <button
              class="bg-primary hover:bg-primary-600 text-white font-medium px-4 py-2 rounded-lg transition-colors"
              phx-click="show_login"
            >
              Get started
            </button>
          </div>
        </div>
      </div>
    </nav>
    """
  end
end
```

### Modal Component

```elixir
defmodule XTweakWeb.Components.Modal do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "fixed inset-0 z-50 overflow-y-auto",
        @show && "block" || "hidden"
      ]}
      phx-click-away="close_modal"
      phx-value-id={@id}
    >
      <!-- Backdrop -->
      <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity"></div>

      <!-- Modal panel -->
      <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-lg w-full p-6">
          <%= render_slot(@inner_block) %>
          <div class="mt-6 flex justify-end gap-3">
            <button
              class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-lg transition-colors"
              phx-click="close_modal"
              phx-value-id={@id}
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
```

### Ash Resource Table with Actions

```elixir
def resource_table(assigns) do
  ~H"""
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
      <thead class="bg-gray-50 dark:bg-gray-800">
        <tr>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
            Name
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
            Status
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
            Created
          </th>
          <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
            Actions
          </th>
        </tr>
      </thead>
      <tbody class="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
        <tr :for={resource <- @resources} class="hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-gray-100">
            <%= resource.name %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap">
            <span class={[
              "inline-flex px-2 py-1 text-xs font-semibold rounded-full",
              resource.active && "bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-400" || "bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400"
            ]}>
              <%= if resource.active, do: "Active", else: "Inactive" %>
            </span>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
            <%= Calendar.strftime(resource.inserted_at, "%B %d, %Y") %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
            <div class="flex justify-end gap-2">
              <.link
                navigate={~p"/resources/#{resource.id}"}
                class="text-primary hover:text-primary-600 transition-colors"
              >
                View
              </.link>
              <button
                class="text-error hover:text-error-600 transition-colors"
                phx-click="delete"
                phx-value-id={resource.id}
                data-confirm="Are you sure?"
              >
                Delete
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  """
end
```

## Testing Checklist

Before marking any frontend task complete:

- [ ] Component renders correctly on mobile, tablet, and desktop
- [ ] Dark mode works properly (test with theme switcher)
- [ ] Ash forms validate and submit correctly
- [ ] Error states display appropriately
- [ ] Loading states and skeletons show during async operations
- [ ] LiveView interactions work smoothly
- [ ] Accessibility snapshot shows proper structure
- [ ] No console errors in browser
- [ ] WebSocket connections remain stable
- [ ] Keyboard navigation works throughout
- [ ] Visual regression tests pass
- [ ] Color contrast meets WCAG AA standards

---

## Usage

Agents implementing frontend components should reference this pattern in their `pattern-stack` frontmatter:

```yaml
pattern-stack:
  - placeholder-basics
  - phase-zero-context
  - mcp-tool-discipline
  - self-check-core
  - dual-example-bridge
  - frontend-design-principles  # <-- Reference this pattern
  - collaboration-handoff
```

**Agents that should use this pattern**:
- `frontend-design-enforcer` (coordinator for frontend work)
- `heex-template-expert` (HEEx template generation/refactoring)
- Any agent implementing LiveView UI components

**Key Principle**: Always use Phoenix LiveView components with Ash forms, pure Tailwind utilities, semantic CSS variables for theming, and ensure accessibility. Test everything with Playwright MCP tools. The goal is maintainable, responsive, and user-friendly interfaces that leverage the full power of LiveView and Ash Framework.
