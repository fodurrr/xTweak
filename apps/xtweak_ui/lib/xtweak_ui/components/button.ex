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
      <.button loading>
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

      # Block (full width)
      <.button block>
        Full Width
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

  @doc """
  Renders a button component.
  """
  attr(:label, :string, default: nil, doc: "Button label (alternative to inner_block)")

  attr(:color, :string,
    default: "primary",
    doc: "Button color (primary, secondary, success, warning, error, neutral)"
  )

  attr(:variant, :string,
    default: "solid",
    doc: "Visual variant (solid, outline, soft, ghost, link)"
  )

  attr(:size, :string, default: "md", doc: "Button size (xs, sm, md, lg, xl)")
  attr(:loading, :boolean, default: false, doc: "Show loading spinner")
  attr(:disabled, :boolean, default: false, doc: "Disable button")
  attr(:icon, :string, default: nil, doc: "Leading icon (Heroicons name, e.g., 'hero-check')")
  attr(:leading_icon, :string, default: nil, doc: "Alias for icon (leading icon)")
  attr(:trailing_icon, :string, default: nil, doc: "Trailing icon")
  attr(:block, :boolean, default: false, doc: "Full width button")
  attr(:square, :boolean, default: false, doc: "Square button (equal padding)")
  attr(:type, :string, default: "button", doc: "Button type (button, submit, reset)")
  attr(:class, :string, default: "", doc: "Additional CSS classes")

  attr(:rest, :global,
    include: ~w(phx-click phx-target form name value href target),
    doc: "Additional HTML attributes"
  )

  slot(:inner_block, doc: "Button content")

  def button(assigns) do
    assigns = prepare_button_assigns(assigns)

    ~H"""
    <button
      type={@type}
      class={[
        # Base classes from theme
        @theme_config[:base],

        # Size-based gap for spacing between elements (only when not icon-only)
        !@icon_only && gap_classes(@size),

        # Variant classes
        variant_classes(@variant, @color),

        # Size classes
        size_classes(@size, @square),

        # Square icon-only buttons should be perfect squares
        @square && @icon_only && "aspect-square",

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
      <span
        :if={@loading}
        class={["animate-spin", icon_classes(@size)]}
        aria-hidden="true"
      >
        <svg class="w-full h-full" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle
            class="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            stroke-width="4"
          >
          </circle>
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          >
          </path>
        </svg>
      </span>

      <span
        :if={@leading_icon && !@loading}
        class={[@leading_icon, icon_classes(@size)]}
        aria-hidden="true"
      >
      </span>

      <span :if={@label}><%= @label %></span>
      <span :if={!@label}><%= render_slot(@inner_block) %></span>

      <span :if={@trailing_icon} class={[@trailing_icon, icon_classes(@size)]} aria-hidden="true">
      </span>
    </button>
    """
  end

  # Private functions for assigns preparation and class generation

  defp prepare_button_assigns(assigns) do
    theme_config = Theme.component_config(:button)
    defaults = Theme.component_defaults(:button)
    icon_only = detect_icon_only_button(assigns)

    assigns
    |> apply_button_defaults(defaults)
    |> assign(:leading_icon, assigns[:icon] || assigns[:leading_icon])
    |> assign(:icon_only, icon_only)
    |> assign(:theme_config, theme_config)
  end

  defp detect_icon_only_button(assigns) do
    has_text_content = has_text_content?(assigns)
    has_icon = assigns[:icon] || assigns[:leading_icon] || assigns[:trailing_icon]
    has_icon && !has_text_content
  end

  defp has_text_content?(assigns) do
    assigns[:label] != nil || (assigns[:inner_block] && assigns[:inner_block] != [])
  end

  defp apply_button_defaults(assigns, defaults) do
    assigns
    |> assign_new(:color, fn -> defaults[:color] || "primary" end)
    |> assign_new(:variant, fn -> defaults[:variant] || "solid" end)
    |> assign_new(:size, fn -> defaults[:size] || "md" end)
  end

  defp variant_classes("solid", color) do
    case color do
      "primary" ->
        "bg-primary-500 text-white hover:bg-primary-600 active:bg-primary-700 focus-visible:outline-primary-500"

      "secondary" ->
        "bg-gray-500 text-white hover:bg-gray-600 active:bg-gray-700 focus-visible:outline-gray-500"

      "neutral" ->
        "bg-gray-500 text-white hover:bg-gray-600 active:bg-gray-700 focus-visible:outline-gray-500"

      "success" ->
        "bg-green-500 text-white hover:bg-green-600 active:bg-green-700 focus-visible:outline-green-500"

      "warning" ->
        "bg-yellow-500 text-white hover:bg-yellow-600 active:bg-yellow-700 focus-visible:outline-yellow-500"

      "error" ->
        "bg-red-500 text-white hover:bg-red-600 active:bg-red-700 focus-visible:outline-red-500"

      _ ->
        "bg-primary-500 text-white hover:bg-primary-600"
    end
  end

  defp variant_classes("outline", color) do
    case color do
      "primary" ->
        "border-2 border-primary-500 text-primary-500 hover:bg-primary-50 active:bg-primary-100"

      "secondary" ->
        "border-2 border-gray-500 text-gray-500 hover:bg-gray-50 active:bg-gray-100"

      "neutral" ->
        "border-2 border-gray-500 text-gray-500 hover:bg-gray-50 active:bg-gray-100"

      "success" ->
        "border-2 border-green-500 text-green-500 hover:bg-green-50 active:bg-green-100"

      "warning" ->
        "border-2 border-yellow-500 text-yellow-500 hover:bg-yellow-50 active:bg-yellow-100"

      "error" ->
        "border-2 border-red-500 text-red-500 hover:bg-red-50 active:bg-red-100"

      _ ->
        "border-2 border-primary-500 text-primary-500 hover:bg-primary-50"
    end
  end

  defp variant_classes("soft", color) do
    case color do
      "primary" -> "bg-primary-100 text-primary-700 hover:bg-primary-200 active:bg-primary-300"
      "secondary" -> "bg-gray-100 text-gray-700 hover:bg-gray-200 active:bg-gray-300"
      "neutral" -> "bg-gray-100 text-gray-700 hover:bg-gray-200 active:bg-gray-300"
      "success" -> "bg-green-100 text-green-700 hover:bg-green-200 active:bg-green-300"
      "warning" -> "bg-yellow-100 text-yellow-700 hover:bg-yellow-200 active:bg-yellow-300"
      "error" -> "bg-red-100 text-red-700 hover:bg-red-200 active:bg-red-300"
      _ -> "bg-primary-100 text-primary-700 hover:bg-primary-200"
    end
  end

  defp variant_classes("ghost", color) do
    case color do
      "primary" -> "text-primary-500 hover:bg-primary-50 active:bg-primary-100"
      "secondary" -> "text-gray-500 hover:bg-gray-50 active:bg-gray-100"
      "neutral" -> "text-gray-500 hover:bg-gray-50 active:bg-gray-100"
      "success" -> "text-green-500 hover:bg-green-50 active:bg-green-100"
      "warning" -> "text-yellow-500 hover:bg-yellow-50 active:bg-yellow-100"
      "error" -> "text-red-500 hover:bg-red-50 active:bg-red-100"
      _ -> "text-primary-500 hover:bg-primary-50"
    end
  end

  defp variant_classes("link", color) do
    case color do
      "primary" -> "text-primary-500 hover:underline"
      "secondary" -> "text-gray-500 hover:underline"
      "neutral" -> "text-gray-500 hover:underline"
      "success" -> "text-green-500 hover:underline"
      "warning" -> "text-yellow-500 hover:underline"
      "error" -> "text-red-500 hover:underline"
      _ -> "text-primary-500 hover:underline"
    end
  end

  defp variant_classes(_, _), do: ""

  defp size_classes(size, true = _square) do
    case size do
      "xs" -> "p-1.5"
      "sm" -> "p-2"
      "md" -> "p-2.5"
      "lg" -> "p-3"
      "xl" -> "p-4"
      _ -> "p-2.5"
    end
  end

  defp size_classes(size, false = _square) do
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

  defp gap_classes(size) do
    case size do
      "xs" -> "gap-1"
      "sm" -> "gap-1.5"
      "md" -> "gap-2"
      "lg" -> "gap-2.5"
      "xl" -> "gap-3"
      _ -> "gap-2"
    end
  end
end
