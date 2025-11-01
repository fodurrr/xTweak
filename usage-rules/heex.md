# HEEx Template Best Practices

> **Version**: 2.0.0 (Simplified)
> **Last Updated**: 2025-01-01
> **Target**: Phoenix 1.8+, LiveView 1.1+, Elixir 1.16+
> **Related Agent**: `heex-template-expert` v1.2.0

**Purpose**: Human-readable guidelines for modern HEEx templates in Phoenix LiveView. For comprehensive implementation patterns and examples, see the `heex-template-expert` agent.

---

## Quick Reference: The 14 Hard Rules

| # | Rule | Pattern |
|---|------|---------|
| 1 | **Modern Directives** | Use `:if`, `:for`, `:let` (NOT `<%= if %>`) |
| 2 | **Type Specs** | All `attr/3` with types, `slot/3` with docs |
| 3 | **Slots as Lists** | Check `@slot != []`, render with `render_slot/1` |
| 4 | **Class List Syntax** | Use `["base", @cond && "extra"]` |
| 5 | **JS Helpers** | Use `Phoenix.LiveView.JS.*` (NOT inline JS) |
| 6 | **Accessibility** | ARIA roles/labels, keyboard navigation |
| 7 | **Ash Forms** | Use `AshPhoenix.Form` (NOT raw HTML) |
| 8 | **Stable IDs** | JS/ARIA-referenced elements need `id` |
| 9 | **Security** | Trust HEEx auto-escape, avoid `raw/1` |
| 10 | **No Dead HTML** | Remove unused IDs, empty attrs, wrappers |
| 11 | **Streams** | Use for collections >100 items |
| 12 | **Colocated Hooks** | Inline JS with `phx-hook=".Name"` |
| 13 | **Viewport Bindings** | Use `phx-viewport-*` for infinite scroll |
| 14 | **Debug Support** | Enable annotations in dev |

---

## Core Principles

**HEEx (HTML+EEx)** is Phoenix's modern templating language providing:
- **Compile-time validation** - Catch errors before runtime
- **Better performance** - Optimized diffing and rendering
- **Cleaner syntax** - Directive-based instead of code blocks
- **Enhanced accessibility** - Better ARIA support

**Key Philosophy**: Templates should be **declarative, not procedural**. Use directives instead of control flow blocks.

---

## Tier 1: Framework Rules (Reference Phoenix Docs)

These rules follow standard Phoenix/LiveView patterns. See official documentation for detailed examples.

### Rule 1: Modern HEEx Directives

**Pattern**: Use `:if`, `:for`, `:let` attribute directives instead of `<%= if %>` blocks.

```elixir
# ❌ Avoid: <%= if @show do %><div>Content</div><% end %>
# ✅ Use: <div :if={@show}>Content</div>

# ❌ Avoid: <%= for item <- @items do %><li><%= item %></li><% end %>
# ✅ Use: <li :for={item <- @items}><%= item %></li>
```

**Why**: Directives compile more efficiently and are validated at compile time.
**Reference**: [Phoenix.Component.sigil_H/2](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#sigil_H/2)

---

### Rule 2: Function Components with Type Specs

**Pattern**: Every component must declare `attr/3` with types and `slot/3` with docs.

```elixir
# ❌ Avoid: Untyped assigns
def button(assigns) do
  ~H"<button class={@class}><%= @label %></button>"
end

# ✅ Use: Properly typed
attr :label, :string, required: true
attr :class, :string, default: ""
def button(assigns) do
  ~H"<button class={@class}><%= @label %></button>"
end
```

**Why**: Type specs provide compile-time validation and prevent runtime errors.
**Reference**: [Phoenix.Component.attr/3](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#attr/3)

---

### Rule 5: Phoenix.LiveView.JS Helpers

**Pattern**: Use declarative `JS.*` helpers instead of server events or imperative JavaScript.

```elixir
# ❌ Avoid: <button phx-click="close_modal">Close</button>
# ✅ Use: <button phx-click={JS.hide(to: "#modal")}>Close</button>

# Chained: JS.hide(to: "#modal") |> JS.push("closed") |> JS.dispatch("modal:closed")
```

**Why**: No server round-trip needed, self-contained interactions.
**Reference**: [Phoenix.LiveView.JS](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html)

---

### Rule 9: Security Defaults

**Pattern**: HEEx auto-escapes by default. Only use `raw/1` when absolutely necessary with documentation.

```elixir
# ✅ Safe (auto-escaped): <div><%= @user_input %></div>
# ❌ DANGER: <div><%= raw(@params["comment"]) %></div>  # XSS vulnerability!
# ✅ Safe: <div><%= @params["comment"] %></div>
```

**Reference**: [HEEx Security](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#sigil_H/2-security)

---

### Rule 11: LiveView Streams

**Pattern**: Use streams for large collections (>100 items) to reduce memory and DOM operations.

```elixir
# Backend: stream(socket, :posts, Blog.list_posts(), limit: 20)
# Template: <div id="posts" phx-update="stream">
#   <article :for={{dom_id, post} <- @streams.posts} id={dom_id}>
#     <%= post.title %>
#   </article>
# </div>
```

**Reference**: [Phoenix.LiveView.stream/4](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#stream/4)

---

### Rule 12: Colocated Hooks

**Pattern**: Write JavaScript inline with components using `phx-hook=".HookName"`.

```elixir
~H"""
<input type="tel" phx-hook=".PhoneFormatter" />
<script type="text/javascript" phx-track-static>
  export default {
    mounted() { /* format phone input */ }
  }
</script>
"""
```

**Reference**: [Colocated Hooks](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-colocated-hooks)

---

### Rule 13: Viewport Bindings

**Pattern**: Use `phx-viewport-top/bottom` for infinite scroll with streams.

```elixir
<div id="feed" phx-update="stream"
     phx-viewport-bottom={!@end? && "load-next"}
     class="pb-[200vh]">
  <div :for={{dom_id, item} <- @streams.items} id={dom_id}><%= item.title %></div>
</div>
```

**Reference**: [Viewport Bindings](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-bindings)

---

### Rule 14: Debug Support

**Pattern**: Enable debug annotations in `config/dev.exs` for component hierarchy visibility.

```elixir
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
```

**Reference**: [Debug Configuration](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-debugging)

---

## Tier 2: xTweak Standards (Detailed)

These rules are xTweak-specific conventions and quality standards not emphasized in Phoenix documentation.

### Rule 3: Slots as Lists (xTweak Convention)

**Pattern**: Always check slots with `@slot != []` before rendering. Slots are **always lists** in HEEx.

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

**Complete pattern:**
```elixir
slot :title, doc: "Modal header"
slot :body, required: true
slot :footer

def modal(assigns) do
  ~H"""
  <div role="dialog">
    <header :if={@title != []}><%= render_slot(@title) %></header>
    <div><%= render_slot(@body) %></div>
    <footer :if={@footer != []}><%= render_slot(@footer) %></footer>
  </div>
  """
end
```

**Why**: Slots are lists even when empty. Using `!= []` is explicit and prevents runtime errors. This is a xTweak standard for clarity.

---

### Rule 4: Class List Syntax (xTweak Standard)

**Pattern**: Use list syntax for classes, not string concatenation. Lists auto-filter `nil`/`false` values.

**❌ WRONG - String concatenation:**
```elixir
<button class={"btn " <> if @primary, do: "btn-primary", else: ""}>
```

**✅ CORRECT - List syntax:**
```elixir
<button class={["btn", @primary && "btn-primary"]}>
```

**Advanced pattern:**
```elixir
<button class={[
  "btn",                        # Always present
  @size == "lg" && "btn-lg",    # Conditional
  @disabled && "opacity-50",    # Conditional
  @custom_class                 # User override
]}>
```

**Why**: Safer (no manual spacing), more readable, handles edge cases automatically. This is a xTweak code quality standard.

---

### Rule 6: Accessibility Requirements (xTweak Standard)

**xTweak requires comprehensive accessibility for all interactive components.** This goes beyond Phoenix framework requirements.

**Modal Dialog:**
```elixir
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
```

**Icon Button:**
```elixir
<button
  type="button"
  aria-label="Close dialog"
  phx-click="delete"
>
  <span class="hero-trash" aria-hidden="true"></span>
  <span class="sr-only">Close dialog</span>
</button>
```

**Form Input:**
```elixir
<label for="email" class="block">Email Address</label>
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
- `role` - Semantic element role (dialog, menu, etc.)
- `aria-label` - Text alternative for icon-only buttons
- `aria-labelledby` - Reference to label element ID
- `aria-describedby` - Reference to help text ID
- `aria-modal="true"` - For modal dialogs
- `aria-pressed/checked/selected` - For toggle buttons
- `aria-invalid` - For form field validation state
- `aria-hidden="true"` - For decorative icons

**Keyboard navigation requirements:**
- **Tab/Shift+Tab** - Focus navigation between interactive elements
- **Enter/Space** - Activate buttons and links
- **Escape** - Close modals, dropdowns, and overlays
- **Arrow keys** - Navigate lists and menus

**Why**: xTweak prioritizes accessibility as a first-class feature, not an afterthought. All interactive components must be keyboard-navigable and screen-reader friendly.

**Resources**: [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/), [WebAIM](https://webaim.org/)

---

### Rule 7: Ash Forms for Data Mutations (xTweak-Specific)

**Pattern**: All data mutations must use `AshPhoenix.Form`. Never use raw HTML forms.

**❌ WRONG - Raw HTML forms:**
```elixir
<form phx-submit="save">
  <input type="text" name="title" />
</form>
```

**✅ CORRECT - AshPhoenix.Form:**
```elixir
# LiveView
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
  <.input field={comment_form[:body]} label="Comment" />
</.inputs_for>
```

**Why**: Ash forms provide automatic validation, authorization, type coercion, and changesets. This is core to xTweak's architecture.

**Reference**: [AshPhoenix.Form](https://hexdocs.pm/ash_phoenix/AshPhoenix.Form.html)

---

### Rule 8: Stable IDs (xTweak Requirement)

**Pattern**: Any element referenced by JavaScript or ARIA must have a stable, required `id` attribute.

```elixir
attr :id, :string, required: true  # ← Make ID required
slot :title

def modal(assigns) do
  ~H"""
  <div id={@id} role="dialog" aria-labelledby={"#{@id}-title"}>
    <h2 id={"#{@id}-title"}>
      <%= render_slot(@title) %>
    </h2>
  </div>
  """
end

# Usage - ID is required
<.modal id="confirm-delete">
  <:title>Confirm Deletion</:title>
</.modal>
```

**Why**: IDs must be stable across re-renders for:
- JavaScript targeting (`JS.hide(to: "#modal-123")`)
- ARIA relationships (`aria-labelledby="title-123"`)
- LiveView DOM morphing (preserves element state)

**xTweak standard**: Components managing state or interactions MUST require an `:id` attribute.

---

### Rule 10: No Dead HTML (xTweak Quality Standard)

**Pattern**: Eliminate unnecessary markup, unused attributes, and redundant wrappers.

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
<button id="" class="" disabled={false} data-action="">
```

**✅ CORRECT - Only what's needed:**
```elixir
<button>Click</button>

# Or with actual values:
<button id="submit-btn" class="btn-primary" disabled>
```

**Common dead HTML to remove:**
- Empty `id=""` or `class=""` attributes
- `disabled={false}` (omit instead)
- Unused `data-*` attributes
- Wrapper `<div>` without purpose
- Inline `style=""` (use Tailwind classes)

**Why**: Clean HTML improves performance, reduces bundle size, and makes templates easier to maintain. This is a xTweak code quality standard.

---

## Common Mistakes

| Mistake | ❌ Avoid | ✅ Use Instead |
|---------|----------|---------------|
| **Inline if/do/else** | `<%= if @x, do: a, else: b %>` | `<span :if={@x}>a</span>` + `<span :if={!@x}>b</span>` |
| **Missing slot check** | `<%= render_slot(@title) %>` | `<div :if={@title != []}><%= render_slot(@title) %></div>` |
| **Hardcoded events** | `phx-click="hide"` + server handler | `phx-click={JS.hide(to: "#modal")}` (no server) |
| **Missing ARIA** | `<button><span class="icon"/></button>` | `<button aria-label="Close"><span aria-hidden="true" class="icon"/></button>` |

---

## Quick Validation

Before committing HEEx templates (see `heex-template-expert` agent for comprehensive checklist):

**Syntax**: Modern directives (`:if`, `:for`), typed `attr/3`, list classes
**Accessibility**: ARIA roles/labels, keyboard nav, stable IDs
**Data**: Ash forms only, no `raw/1` on user input
**Performance**: Minimal markup, streams for >100 items
**Quality**: `mix format`, `mix compile --warnings-as-errors`

---

## Examples

**For complete, production-ready examples**, see:
- **`heex-template-expert` agent** - 130-line TaskModal with streams, accessibility, infinite scroll (lines 388-518)
- **Phoenix generators** - Run `mix phx.gen.live` for scaffolds
- **Component patterns** - See agent lines 99-323 for 5 comprehensive patterns

**Quick snippet - Minimal component:**
```elixir
attr :label, :string, required: true
attr :class, :any, default: nil
slot :inner_block

def button(assigns) do
  ~H"""
  <button class={["btn", @class]}>
    <%= @label || render_slot(@inner_block) %>
  </button>
  """
end
```

---

## Resources

**Phoenix Documentation:**
- [Phoenix.Component](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) - attr/3, slot/3, function components
- [Phoenix.LiveView.JS](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html) - Declarative JS helpers
- [Phoenix.LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) - Streams, hooks, bindings

**Ash Framework:**
- [AshPhoenix.Form](https://hexdocs.pm/ash_phoenix/AshPhoenix.Form.html) - Form integration

**Accessibility:**
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/) - Patterns and widgets
- [WebAIM Resources](https://webaim.org/resources/) - Accessibility guidelines

**xTweak Internal:**
- `.claude/agents/heex-template-expert.md` - Implementation guide with comprehensive examples
- `usage-rules/ash_phoenix.md` - Ash form patterns

---

## Version History

- **v2.0.0** (2025-01-01) - Simplified edition: Tier-based rules, removed redundant examples, added quick reference table, static docs links (49% reduction)
- **v1.1.0** (2025-10-30) - Added LiveView 1.1+ features (streams, colocated hooks, viewport bindings)
- **v1.0.0** (2025-10-29) - Initial version
