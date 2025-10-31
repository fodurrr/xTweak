# HEEx Template Best Practices

> **Version**: 1.1.0
> **Last Updated**: 2025-10-30
> **Target**: Phoenix 1.8+, LiveView 1.1+, Elixir 1.16+
> **Related Agent**: `heex-template-expert` v1.2.0 (implementation rules and patterns)

This document provides human-readable guidelines for writing modern HEEx templates in Phoenix LiveView applications. These rules are enforced by the `heex-template-expert` agent (v1.2.0), which includes additional patterns for component structure, accessibility, and LiveView 1.1+ features like streams and colocated hooks.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [The 14 Hard Rules](#the-14-hard-rules)
3. [Component Patterns](#component-patterns)
4. [Common Mistakes](#common-mistakes)
5. [Examples](#examples)
6. [Validation Checklist](#validation-checklist)

---

## Core Principles

### Modern HEEx vs Legacy EEx

HEEx (HTML+EEx) is Phoenix's modern templating language introduced in LiveView 0.17+. It provides:

- **Compile-time validation** - Catch errors before runtime
- **Better performance** - Optimized diffing and rendering
- **Cleaner syntax** - Directive-based instead of code blocks
- **Enhanced accessibility** - Better support for ARIA attributes

**Key Philosophy**: Templates should be declarative, not procedural. Use directives (`:if`, `:for`, `:let`) instead of control flow blocks (`<%= if %>`).

---

## The 14 Hard Rules

### Rule 1: Use HEEx Directives (CRITICAL)

**❌ WRONG - Legacy EEx syntax:**
```elixir
<%= if @show do %>
  <div>Content</div>
<% end %>

<%= for item <- @items do %>
  <li><%= item %></li>
<% end %>
```

**✅ CORRECT - Modern HEEx directives:**
```elixir
<div :if={@show}>Content</div>

<li :for={item <- @items}><%= item %></li>
```

**Why**: Directives are compiled more efficiently, validated at compile time, and result in cleaner templates.

---

### Rule 2: Function Components with Type Specs (CRITICAL)

**❌ WRONG - Untyped assigns:**
```elixir
def button(assigns) do
  ~H"""
  <button class={@class}><%= @label %></button>
  """
end
```

**✅ CORRECT - Properly typed:**
```elixir
def button(assigns) do
  attr :label, :string, required: true, doc: "Button text"
  attr :class, :string, default: "", doc: "CSS classes"
  attr :disabled, :boolean, default: false

  ~H"""
  <button class={@class} disabled={@disabled}>
    <%= @label %>
  </button>
  """
end
```

**Why**: Type specs provide compile-time validation, documentation, and prevent runtime errors from missing/incorrect assigns.

---

### Rule 3: Slots as Lists (CRITICAL)

**❌ WRONG - Checking truthiness:**
```elixir
<%= if @title do %>
  <h3><%= @title %></h3>
<% end %>
```

**✅ CORRECT - List semantics:**
```elixir
<h3 :if={@title != []}><%= render_slot(@title) %></h3>
```

**Complete slot pattern:**
```elixir
def modal(assigns) do
  slot :title, doc: "Modal header"
  slot :body, required: true
  slot :footer

  ~H"""
  <div role="dialog">
    <header :if={@title != []}>
      <%= render_slot(@title) %>
    </header>

    <div><%= render_slot(@body) %></div>

    <footer :if={@footer != []}>
      <%= render_slot(@footer) %>
    </footer>
  </div>
  """
end
```

**Why**: Slots are always lists in HEEx. Checking `!= []` is explicit and correct.

---

### Rule 4: Class List Syntax (CRITICAL)

**❌ WRONG - String concatenation:**
```elixir
<button class={"btn " <> if @primary, do: "btn-primary", else: ""}>
```

**✅ CORRECT - List merge:**
```elixir
<button class={["btn", @primary && "btn-primary"]}>
```

**Advanced pattern:**
```elixir
<button class={[
  "btn",                           # Always present
  @size == "lg" && "btn-lg",       # Conditional
  @disabled && "opacity-50",       # Conditional
  @custom_class                     # User override
]}>
```

**Why**: List syntax is safer (no manual spacing), more readable, and handles `nil`/`false` values automatically.

---

### Rule 5: Phoenix.LiveView.JS Helpers (CRITICAL)

**❌ WRONG - Hardcoded event names:**
```elixir
<button phx-click="close_modal">Close</button>
```

**❌ WRONG - Imperative JavaScript:**
```elixir
<button onclick="document.getElementById('modal').style.display='none'">
```

**✅ CORRECT - Declarative JS helpers:**
```elixir
alias Phoenix.LiveView.JS

<button phx-click={JS.hide(to: "#modal")}>Close</button>

<!-- Chained commands -->
<button phx-click={
  JS.hide(to: "#modal")
  |> JS.push("modal_closed")
  |> JS.dispatch("modal:closed", to: window)
}>
  Close
</button>
```

**Available helpers:**
- `JS.show/hide` - Element visibility
- `JS.toggle` - Toggle visibility
- `JS.add_class/remove_class` - Class manipulation
- `JS.set_attribute/remove_attribute` - Attribute changes
- `JS.push` - Server events
- `JS.navigate/patch` - LiveView navigation
- `JS.dispatch` - Custom JS events
- `JS.transition` - Smooth animations

**Why**: Self-contained, no server round-trip needed, consistent with LiveView patterns.

---

### Rule 6: Accessibility Requirements (CRITICAL)

**Minimum requirements for interactive components:**

```elixir
# Modal Dialog
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  phx-window-keydown={hide_modal()}
  phx-key="escape"
>
  <h2 id="modal-title">Dialog Title</h2>
  <!-- content -->
</div>

# Button
<button
  type="button"
  aria-label="Close dialog"
  aria-pressed={to_string(@pressed)}
>
  <span aria-hidden="true">&times;</span>
  <span class="sr-only">Close</span>
</button>

# Form Input
<label for="email" class="block">
  Email Address
</label>
<input
  id="email"
  type="email"
  aria-describedby="email-help"
  aria-invalid={to_string(@errors != [])}
/>
<span id="email-help" class="text-sm">
  We'll never share your email
</span>
```

**Required ARIA attributes:**
- `role` - Semantic element role
- `aria-label` - Text alternative for icon buttons
- `aria-labelledby` - Reference to label element
- `aria-describedby` - Reference to description
- `aria-modal` - For dialogs
- `aria-pressed/checked/selected` - For toggle buttons
- `aria-invalid` - For form validation
- `aria-hidden="true"` - For decorative icons

**Keyboard navigation:**
- Tab/Shift+Tab - Focus navigation
- Enter/Space - Activate buttons
- Escape - Close modals/dropdowns
- Arrow keys - Navigate lists/menus

---

### Rule 7: Ash Forms for Data Mutations (CRITICAL)

**❌ WRONG - Raw HTML forms:**
```elixir
<form phx-submit="save">
  <input type="text" name="title" />
</form>
```

**✅ CORRECT - AshPhoenix.Form:**
```elixir
def mount(_params, _session, socket) do
  form = AshPhoenix.Form.for_create(Post, :create)
  {:ok, assign(socket, form: to_form(form))}
end

def handle_event("save", %{"form" => params}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
    {:ok, post} ->
      {:noreply, push_navigate(socket, to: ~p"/posts/#{post}")}

    {:error, form} ->
      {:noreply, assign(socket, form: to_form(form))}
  end
end

# Template
<.form for={@form} phx-submit="save">
  <.input field={@form[:title]} label="Title" />
  <.input field={@form[:body]} type="textarea" />

  <.error :for={error <- @form[:title].errors}>
    <%= translate_error(error) %>
  </.error>

  <.button type="submit">Save</.button>
</.form>
```

**Nested relationships:**
```elixir
<.inputs_for :let={comment_form} field={@form[:comments]}>
  <.input field={comment_form[:body]} />
</.inputs_for>
```

**Why**: Ash forms provide validation, authorization, type coercion, and changesets automatically.

---

### Rule 8: Stable IDs (CRITICAL)

**Any element referenced by JavaScript or ARIA must have a stable ID:**

```elixir
def modal(assigns) do
  attr :id, :string, required: true  # ← Require ID
  slot :title

  ~H"""
  <div id={@id} role="dialog" aria-labelledby={"#{@id}-title"}>
    <h2 id={"#{@id}-title"}>
      <%= render_slot(@title) %>
    </h2>
  </div>
  """
end

# Usage
<.modal id="confirm-delete">
  <:title>Confirm</:title>
</.modal>
```

**Why**: IDs must be stable across re-renders for JS targeting, ARIA relationships, and LiveView morphing.

---

### Rule 9: Security Defaults (CRITICAL)

**HEEx auto-escapes by default - trust this!**

```elixir
# ✅ Safe - Auto-escaped
<div><%= @user_input %></div>

# ⚠️ Only when absolutely necessary (and documented!)
<div><%= raw(@trusted_html) %></div>

# ✅ Better - Use Phoenix.HTML helpers
<%= tag.div(class: "content") do %>
  <%= @user_input %>
<% end %>
```

**Never mark user input as safe:**
```elixir
# ❌ DANGEROUS - XSS vulnerability
<div><%= raw(@params["comment"]) %></div>

# ✅ Safe
<div><%= @params["comment"] %></div>
```

---

### Rule 10: No Dead HTML (CRITICAL)

**❌ WRONG - Unnecessary wrappers:**
```elixir
<div>
  <div>
    <div class="content">
      <%= @body %>
    </div>
  </div>
</div>
```

**✅ CORRECT - Minimal markup:**
```elixir
<div class="content">
  <%= @body %>
</div>
```

**❌ WRONG - Unused attributes:**
```elixir
<button id="" class="" disabled={false}>
```

**✅ CORRECT - Only what's needed:**
```elixir
<button>Click</button>
```

---

### Rule 11: LiveView 1.1+ Streams (NEW)

**For large collections (>100 items), use streams:**

```elixir
def mount(_params, _session, socket) do
  socket =
    socket
    |> stream(:posts, Blog.list_posts(), limit: 20)

  {:ok, socket}
end

def handle_event("load_more", _, socket) do
  posts = Blog.list_posts(offset: socket.assigns.page * 20)
  {:noreply, stream_insert(socket, :posts, posts)}
end

# Template - Note the tuple destructuring!
<div id="posts-list" phx-update="stream">
  <article
    :for={{dom_id, post} <- @streams.posts}
    id={dom_id}
    class="post"
  >
    <h3><%= post.title %></h3>
  </article>
</div>
```

**Why**: Streams only send changes to the client, dramatically reducing memory usage and DOM operations for large lists.

---

### Rule 12: Colocated Hooks (NEW in LiveView 1.1)

**Write JavaScript inline with your component:**

```elixir
def phone_input(assigns) do
  ~H"""
  <div id="phone-container" phx-hook=".PhoneFormatter">
    <input type="tel" id="phone" />
  </div>

  <script type="text/javascript" phx-track-static>
    (() => {
      if (window.PhoneFormatter) return;

      window.PhoneFormatter = {
        mounted() {
          this.el.querySelector('input').addEventListener('input', (e) => {
            e.target.value = formatPhone(e.target.value);
          });
        },

        updated() {
          console.log('Phone input updated');
        }
      };
    })();
  </script>
  """
end
```

**Why**: No separate JS files needed, code stays with the component, auto-prefixed to prevent conflicts.

---

### Rule 13: Viewport Bindings for Infinite Scroll (NEW)

```elixir
<div
  id="infinite-list"
  phx-viewport-top={@page > 1 && "load-previous"}
  phx-viewport-bottom="load-next"
  phx-update="stream"
  class="pb-[200vh]"  # Padding for smooth scroll
>
  <div :for={{dom_id, item} <- @streams.items} id={dom_id}>
    <%= item.title %>
  </div>
</div>
```

**Handlers:**
```elixir
def handle_event("load-next", _, socket) do
  {:noreply, stream(socket, :items, fetch_next_page(), at: -1)}
end

def handle_event("load-previous", _, socket) do
  {:noreply, stream(socket, :items, fetch_prev_page(), at: 0)}
end
```

---

### Rule 14: Modern Debug Support (NEW)

**Enable in dev environment:**

```elixir
# config/dev.exs
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
```

**Use in templates:**
```elixir
<div
  phx-mounted={JS.dispatch("component:mounted")}
  data-component="button"
>
  <!-- HTML comments show component hierarchy -->
  <!-- Component: XTweakUI.Components.Button -->
  <button>Click</button>
</div>
```

---

## Component Patterns

### Basic Component Template

```elixir
defmodule MyApp.Components.Widget do
  use Phoenix.Component

  @moduledoc """
  Brief description of the component.

  ## Examples

      <.widget id="w1" title="Hello">
        Content here
      </.widget>
  """

  attr :id, :string, required: true, doc: "Unique identifier"
  attr :title, :string, default: nil
  attr :class, :any, default: nil

  slot :inner_block, required: true

  attr :rest, :global, include: ~w(phx-click phx-target)

  def widget(assigns) do
    ~H"""
    <div id={@id} class={["widget", @class]} {@rest}>
      <h3 :if={@title}><%= @title %></h3>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
```

### Global Attributes Pattern

```elixir
attr :rest, :global,
  include: ~w(phx-click phx-change phx-submit phx-value-id),
  doc: "Phoenix event bindings"

# In template
<button {@rest}>
```

### Conditional Rendering Patterns

```elixir
# Simple boolean
<div :if={@show}>Content</div>

# Inverted
<div :if={!@show}>Hidden</div>

# Complex condition
<div :if={@user && @user.admin?}>Admin panel</div>

# Pattern matching
<div :if={match?({:ok, _}, @result)}>Success</div>
```

---

## Common Mistakes

### Mistake 1: Inline if/do/else

**❌ WRONG:**
```elixir
<%= if @label, do: @label, else: render_slot(@inner_block) %>
```

**✅ CORRECT:**
```elixir
<span :if={@label}><%= @label %></span>
<span :if={!@label}><%= render_slot(@inner_block) %></span>
```

### Mistake 2: Forgetting to Check Slot Presence

**❌ WRONG:**
```elixir
<header><%= render_slot(@title) %></header>
```

**✅ CORRECT:**
```elixir
<header :if={@title != []}>
  <%= render_slot(@title) %>
</header>
```

### Mistake 3: Hardcoded Event Names

**❌ WRONG:**
```elixir
<button phx-click="hide">Close</button>

# In LiveView
def handle_event("hide", _, socket) do
  {:noreply, assign(socket, show: false)}
end
```

**✅ CORRECT:**
```elixir
<button phx-click={JS.hide(to: "#modal")}>Close</button>
# No server event needed!
```

### Mistake 4: Missing ARIA Labels on Icon Buttons

**❌ WRONG:**
```elixir
<button phx-click="delete">
  <span class="hero-trash"></span>
</button>
```

**✅ CORRECT:**
```elixir
<button phx-click="delete" aria-label="Delete item">
  <span class="hero-trash" aria-hidden="true"></span>
  <span class="sr-only">Delete item</span>
</button>
```

---

## Examples

### Complete Modal Component

See the full refactored Modal example in the code-reviewer audit report.

### Complete Form with Validation

```elixir
<.form for={@form} phx-submit="save" phx-change="validate">
  <.input
    field={@form[:email]}
    type="email"
    label="Email"
    required
    autocomplete="email"
  />

  <.input
    field={@form[:password]}
    type="password"
    label="Password"
    required
  />

  <div :if={@form.errors != []}>
    <.error :for={{field, errors} <- @form.errors}>
      <%= translate_error(errors) %>
    </.error>
  </div>

  <.button type="submit" loading={@saving}>
    Save Changes
  </.button>
</.form>
```

---

## Validation Checklist

Before committing HEEx templates, verify:

### Syntax (Rules 1-5)
- [ ] All `<%= if %>` replaced with `:if`
- [ ] All `<%= for %>` replaced with `:for`
- [ ] All attrs have `attr/3` definitions with types
- [ ] All slots have `slot/3` definitions
- [ ] Class attributes use list syntax
- [ ] JS interactions use `Phoenix.LiveView.JS` helpers

### Accessibility (Rules 6, 8)
- [ ] Interactive elements have proper `role` attributes
- [ ] Icon buttons have `aria-label`
- [ ] Modals have `aria-modal`, `aria-labelledby`
- [ ] Forms have proper `<label for="">` associations
- [ ] Keyboard navigation works (Tab, Enter, Escape)
- [ ] All JS-targeted elements have stable IDs

### Data & Security (Rules 7, 9)
- [ ] Forms use `AshPhoenix.Form` (not raw HTML)
- [ ] No `raw/1` on user input
- [ ] Validation errors displayed properly
- [ ] No sensitive data in client-side assigns

### Performance (Rules 10-13)
- [ ] No unnecessary wrapper divs
- [ ] Large lists (>100 items) use streams
- [ ] Infinite scroll uses viewport bindings
- [ ] Dead HTML removed (empty attrs, unused IDs)

### Testing
- [ ] Component renders without errors
- [ ] `mix format` passes
- [ ] `mix compile --warnings-as-errors` passes
- [ ] Manual browser test for accessibility
- [ ] Screen reader test (if interactive)

---

## Resources

- [Phoenix LiveView Docs](https://hexdocs.pm/phoenix_live_view)
- [HEEx Template Syntax](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html)
- [Phoenix.LiveView.JS](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html)
- [AshPhoenix.Form](https://hexdocs.pm/ash_phoenix/AshPhoenix.Form.html)
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WebAIM Accessibility Resources](https://webaim.org/resources/)

---

## Version History

- **v1.1.0** (2025-10-30) - Added LiveView 1.1+ features (streams, colocated hooks, viewport bindings)
- **v1.0.0** (2025-10-29) - Initial version with 10 core rules
