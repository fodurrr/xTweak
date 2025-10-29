defmodule XTweakWebWeb.ShowcaseLive do
  use XTweakWebWeb, :live_view
  alias XTweakUI.Components.Button

  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "light", page_title: "xTweak UI Showcase")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-ui-bg-default" phx-hook="UniversalTheme" id="theme-container">
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
              class="px-4 py-2 rounded-lg bg-ui-bg-accented text-ui-text-default hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
            >
              {if @theme == "light", do: "🌙 Dark", else: "☀️ Light"}
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
                <Button.button color="neutral">Neutral</Button.button>
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
                <Button.button loading>Loading</Button.button>
                <Button.button disabled>Disabled</Button.button>
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
            
    <!-- Block Button -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Block (Full Width)</h3>
              <div class="space-y-4">
                <Button.button block>Block Button</Button.button>
                <Button.button block variant="outline">Block Outline</Button.button>
              </div>
            </div>
            
    <!-- Square Buttons -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Square Buttons</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Button.button square icon="hero-heart" size="xs" />
                <Button.button square icon="hero-star" size="sm" />
                <Button.button square icon="hero-plus" size="md" />
                <Button.button square icon="hero-x-mark" size="lg" color="error" />
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;.button color="primary" variant="solid" size="md"&gt;
                Click me
              &lt;/.button&gt;

              &lt;.button loading&gt;
                Submit
              &lt;/.button&gt;

              &lt;.button icon="hero-check" color="success"&gt;
                Save
              &lt;/.button&gt;

              &lt;.button block&gt;
                Full Width Button
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

    socket =
      socket
      |> assign(theme: new_theme)
      |> push_event("toggle-theme", %{})

    {:noreply, socket}
  end
end
