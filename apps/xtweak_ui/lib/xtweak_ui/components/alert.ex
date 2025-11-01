defmodule XTweakUI.Components.Alert do
  @moduledoc """
  Alert component for displaying contextual feedback messages to users.

  Provides severity-based variants (info, success, warning, error) with proper
  color coding, icons, and accessibility attributes. Supports optional slots
  for title, description, and actions, plus a dismissible close button.

  ## Features

  - Semantic color variants for different message types
  - Default icons per severity level
  - Optional title, description, and action slots
  - Dismissible with close button
  - Proper ARIA attributes for screen readers
  - Horizontal and vertical orientations
  - Theme integration with CSS variables

  ## Accessibility

  - Uses `role="alert"` for important notifications
  - Uses `aria-live="polite"` for info/success alerts
  - Uses `aria-live="assertive"` for warning/error alerts
  - Close button includes `aria-label="Close alert"`
  - Icons complement color (not sole indicator)
  - Semantic HTML structure

  ## Examples

      # Simple info alert
      <.alert color="info">
        Your profile has been updated.
      </.alert>

      # Alert with title and description
      <.alert color="success">
        <:title>Success!</:title>
        Your changes have been saved successfully.
      </.alert>

      # Alert with actions
      <.alert color="warning">
        <:title>Low disk space</:title>
        <:description>
          You have less than 10% disk space remaining.
        </:description>
        <:actions>
          <.button size="xs" variant="soft">View details</.button>
        </:actions>
      </.alert>

      # Dismissible alert
      <.alert color="error" close>
        <:title>Error occurred</:title>
        Failed to process your request.
      </.alert>

      # Custom icon
      <.alert color="info" icon="hero-rocket-launch">
        <:title>New feature available</:title>
        Check out our latest updates!
      </.alert>
  """
  use Phoenix.Component
  import Phoenix.HTML

  alias Phoenix.LiveView.JS
  alias XTweakUI.Theme

  @doc """
  Renders an alert component with severity-based styling and optional slots.

  ## Attributes

  - `color` - Alert severity color (default: "info")
    - "info" - Informational messages (blue)
    - "success" - Success confirmations (green)
    - "warning" - Warning messages (yellow/orange)
    - "error" - Error messages (red)
    - "primary" - Primary brand color
    - "secondary" - Secondary brand color
    - "neutral" - Neutral gray styling
  - `variant` - Visual style variant (default: "soft")
    - "solid" - Solid background with white text
    - "outline" - Border with colored ring
    - "soft" - Light background with colored text
    - "subtle" - Soft background with border ring
  - `orientation` - Layout direction (default: "vertical")
    - "vertical" - Actions below content
    - "horizontal" - Actions inline with content
  - `icon` - Custom icon name (optional, defaults to severity icon)
  - `close` - Show close button (default: false)
  - `close_icon` - Custom close icon (default: "hero-x-mark")
  - `on_close` - JS command or function to execute when closed
  - `class` - Additional CSS classes for root element
  - `rest` - Additional HTML attributes

  ## Slots

  - `title` - Custom title content (overrides title attr)
  - `inner_block` - Default description content (overrides description attr)
  - `actions` - Action buttons or links
  - `leading` - Custom leading icon/avatar (overrides default icon)
  - `close` - Custom close button (overrides default close button)
  """
  attr(:color, :string,
    default: "info",
    values: ~w(info success warning error primary secondary neutral)
  )

  attr(:variant, :string, default: "soft", values: ~w(solid outline soft subtle))
  attr(:orientation, :string, default: "vertical", values: ~w(vertical horizontal))
  attr(:icon, :string, default: nil)
  attr(:close, :boolean, default: false)
  attr(:close_icon, :string, default: "hero-x-mark")
  attr(:on_close, :any, default: nil)
  attr(:class, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:rest, :global)

  slot(:title, doc: "Alert title content")
  slot(:description, doc: "Alert description content (can use inner_block instead)")
  slot(:inner_block, doc: "Description content (alternative to :description slot)")
  slot(:actions, doc: "Action buttons or links")
  slot(:leading, doc: "Custom leading icon or avatar")

  def alert(assigns) do
    theme_config = Theme.component_config(:alert)

    assigns =
      assigns
      |> assign_new(:id, fn -> "alert-#{System.unique_integer([:positive])}" end)
      |> assign(:theme_config, theme_config)
      |> assign(:default_icon, default_icon_for_color(assigns.color, theme_config))
      |> assign(:aria_live, aria_live_for_color(assigns.color, theme_config))

    ~H"""
    <div
      id={@id}
      role="alert"
      aria-live={@aria_live}
      class={[
        "relative overflow-hidden w-full rounded-lg p-4 flex gap-2.5",
        orientation_classes(@orientation),
        color_variant_classes(@color, @variant, @theme_config),
        @class
      ]}
      {@rest}
    >
      <!-- Leading icon/avatar -->
      <div :if={@leading != [] || @icon || @default_icon} class="shrink-0">
        <span :if={@leading != []}><%= render_slot(@leading) %></span>
        <.icon :if={@leading == []} name={@icon || @default_icon} class="size-5" />
      </div>

      <!-- Content wrapper -->
      <div class="min-w-0 flex-1 flex flex-col">
        <!-- Title -->
        <div :if={@title != []} class="text-sm font-medium">
          <%= render_slot(@title) %>
        </div>

        <!-- Description -->
        <div :if={@description != [] || @inner_block != []} class={[
          "text-sm opacity-90",
          @title != [] && "mt-1"
        ]}>
          <span :if={@description != []}><%= render_slot(@description) %></span>
          <span :if={@description == []}><%= render_slot(@inner_block) %></span>
        </div>

        <!-- Actions (vertical orientation) -->
        <div :if={@actions != [] && @orientation == "vertical"} class="flex flex-wrap gap-1.5 mt-2.5 items-start">
          <%= render_slot(@actions) %>
        </div>
      </div>

      <!-- Actions (horizontal orientation) -->
      <div :if={@actions != [] && @orientation == "horizontal"} class="flex flex-wrap gap-1.5 shrink-0 items-center">
        <%= render_slot(@actions) %>
      </div>

      <!-- Close button -->
      <div :if={@close} class="shrink-0">
        <button
          type="button"
          aria-label="Close alert"
          phx-click={@on_close || JS.hide(to: "##{@id}")}
          class="p-0 inline-flex items-center justify-center text-current opacity-70 hover:opacity-100 transition-opacity"
        >
          <.icon name={@close_icon} class="size-5" />
        </button>
      </div>
    </div>
    """
  end

  # Private helper: default icon based on color/severity (from theme config)
  defp default_icon_for_color(color, theme_config) do
    get_in(theme_config, [:color, String.to_atom(color), :icon]) || "hero-bell"
  end

  # Private helper: aria-live level based on severity (from theme config)
  defp aria_live_for_color(color, theme_config) do
    get_in(theme_config, [:color, String.to_atom(color), :aria_live]) || "polite"
  end

  # Private helper: orientation classes
  defp orientation_classes("horizontal"), do: "items-center"
  defp orientation_classes("vertical"), do: "items-start"

  # Private helper: fetch color and variant classes from theme config
  defp color_variant_classes(color, variant, theme_config) do
    get_in(theme_config, [:color, String.to_atom(color), String.to_atom(variant)]) || ""
  end

  # Private helper: icon component
  defp icon(assigns) do
    ~H"""
    <span class={["inline-block", @class]} aria-hidden="true">
      <%= raw(heroicon(@name)) %>
    </span>
    """
  end

  # Private helper: Heroicon SVG generator
  defp heroicon("hero-information-circle") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm8.706-1.442c1.146-.573 2.437.463 2.126 1.706l-.709 2.836.042-.02a.75.75 0 01.67 1.34l-.04.022c-1.147.573-2.438-.463-2.127-1.706l.71-2.836-.042.02a.75.75 0 11-.671-1.34l.041-.022zM12 9a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-check-circle") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm13.36-1.814a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.75-5.25z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-exclamation-triangle") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.4 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-x-circle") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zm-1.72 6.97a.75.75 0 10-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 101.06 1.06L12 13.06l1.72 1.72a.75.75 0 101.06-1.06L13.06 12l1.72-1.72a.75.75 0 10-1.06-1.06L12 10.94l-1.72-1.72z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-bell") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M5.85 3.5a.75.75 0 00-1.117-1 9.719 9.719 0 00-2.348 4.876.75.75 0 001.479.248A8.219 8.219 0 015.85 3.5zM19.267 2.5a.75.75 0 10-1.118 1 8.22 8.22 0 011.987 4.124.75.75 0 001.48-.248A9.72 9.72 0 0019.266 2.5z" />
      <path fill-rule="evenodd" d="M12 2.25A6.75 6.75 0 005.25 9v.75a8.217 8.217 0 01-2.119 5.52.75.75 0 00.298 1.206c1.544.57 3.16.99 4.831 1.243a3.75 3.75 0 107.48 0 24.583 24.583 0 004.83-1.244.75.75 0 00.298-1.205 8.217 8.217 0 01-2.118-5.52V9A6.75 6.75 0 0012 2.25zM9.75 18c0-.034 0-.067.002-.1a25.05 25.05 0 004.496 0l.002.1a2.25 2.25 0 11-4.5 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-x-mark") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-rocket-launch") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M9.315 7.584C12.195 3.883 16.695 1.5 21.75 1.5a.75.75 0 01.75.75c0 5.056-2.383 9.555-6.084 12.436A6.75 6.75 0 019.75 22.5a.75.75 0 01-.75-.75v-4.131A15.838 15.838 0 016.382 15H2.25a.75.75 0 01-.75-.75 6.75 6.75 0 017.815-6.666zM15 6.75a2.25 2.25 0 100 4.5 2.25 2.25 0 000-4.5z" clip-rule="evenodd" />
      <path d="M5.26 17.242a.75.75 0 10-.897-1.203 5.243 5.243 0 00-2.05 5.022.75.75 0 00.625.627 5.243 5.243 0 005.022-2.051.75.75 0 10-1.202-.897 3.744 3.744 0 01-3.008 1.51c0-1.23.592-2.323 1.51-3.008z" />
    </svg>
    """
  end
end
