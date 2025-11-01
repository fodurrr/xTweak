defmodule XTweakUI.Components.Badge do
  @moduledoc """
  Badge component for displaying status, labels, and counts.

  Ported from Nuxt UI's UBadge component.

  ## Examples

      # Basic badge
      <.badge>New</.badge>

      # With color and variant
      <.badge color="success" variant="solid">
        Active
      </.badge>

      # With size
      <.badge size="lg">10</.badge>

      # Different variants
      <.badge variant="outline" color="warning">
        Pending
      </.badge>

      # Different colors
      <.badge color="error">Error</.badge>
      <.badge color="primary">Info</.badge>

  ## Accessibility

  - Semantic HTML with appropriate text
  - Screen reader compatible
  - Proper color contrast for readability

  ## Nuxt UI Reference

  https://ui.nuxt.com/components/badge
  """

  use Phoenix.Component
  alias XTweakUI.Theme

  @doc """
  Renders a badge component.
  """
  attr(:label, :string, default: nil, doc: "Badge label (alternative to inner_block)")

  attr(:color, :string,
    default: "gray",
    doc: "Badge color (gray, primary, success, warning, error)"
  )

  attr(:variant, :string,
    default: "solid",
    doc: "Visual variant (solid, outline, soft, subtle)"
  )

  attr(:size, :string, default: "md", doc: "Badge size (xs, sm, md, lg)")
  attr(:class, :string, default: "", doc: "Additional CSS classes")

  attr(:rest, :global, doc: "Additional HTML attributes")

  slot(:inner_block, doc: "Badge content")

  def badge(assigns) do
    assigns = prepare_badge_assigns(assigns)

    ~H"""
    <span
      class={[
        # Base classes from theme
        @theme_config[:base],

        # Variant classes
        variant_classes(@variant, @color),

        # Size classes
        size_classes(@size),

        # Custom classes
        @class
      ]}
      {@rest}
    >
      <span :if={@label}><%= @label %></span>
      <span :if={!@label}><%= render_slot(@inner_block) %></span>
    </span>
    """
  end

  # Private functions for assigns preparation and class generation

  defp prepare_badge_assigns(assigns) do
    theme_config = Theme.component_config(:badge)
    defaults = Theme.component_defaults(:badge)

    assigns
    |> apply_badge_defaults(defaults)
    |> assign(:theme_config, theme_config)
  end

  defp apply_badge_defaults(assigns, defaults) do
    assigns
    |> assign_new(:color, fn -> defaults[:color] || "gray" end)
    |> assign_new(:variant, fn -> defaults[:variant] || "solid" end)
    |> assign_new(:size, fn -> defaults[:size] || "md" end)
  end

  defp variant_classes("solid", color) do
    case color do
      "gray" ->
        "bg-gray-500 text-white"

      "primary" ->
        "bg-primary-500 text-white"

      "success" ->
        "bg-green-500 text-white"

      "warning" ->
        "bg-yellow-500 text-white"

      "error" ->
        "bg-red-500 text-white"

      _ ->
        "bg-gray-500 text-white"
    end
  end

  defp variant_classes("outline", color) do
    case color do
      "gray" ->
        "border-2 border-gray-500 text-gray-700 dark:text-gray-300"

      "primary" ->
        "border-2 border-primary-500 text-primary-700 dark:text-primary-300"

      "success" ->
        "border-2 border-green-500 text-green-700 dark:text-green-300"

      "warning" ->
        "border-2 border-yellow-500 text-yellow-700 dark:text-yellow-300"

      "error" ->
        "border-2 border-red-500 text-red-700 dark:text-red-300"

      _ ->
        "border-2 border-gray-500 text-gray-700 dark:text-gray-300"
    end
  end

  defp variant_classes("soft", color) do
    case color do
      "gray" -> "bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300"
      "primary" -> "bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-300"
      "success" -> "bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-300"
      "warning" -> "bg-yellow-100 text-yellow-700 dark:bg-yellow-900 dark:text-yellow-300"
      "error" -> "bg-red-100 text-red-700 dark:bg-red-900 dark:text-red-300"
      _ -> "bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300"
    end
  end

  defp variant_classes("subtle", color) do
    case color do
      "gray" -> "bg-gray-50 text-gray-600 dark:bg-gray-900 dark:text-gray-400"
      "primary" -> "bg-primary-50 text-primary-600 dark:bg-primary-950 dark:text-primary-400"
      "success" -> "bg-green-50 text-green-600 dark:bg-green-950 dark:text-green-400"
      "warning" -> "bg-yellow-50 text-yellow-600 dark:bg-yellow-950 dark:text-yellow-400"
      "error" -> "bg-red-50 text-red-600 dark:bg-red-950 dark:text-red-400"
      _ -> "bg-gray-50 text-gray-600 dark:bg-gray-900 dark:text-gray-400"
    end
  end

  defp variant_classes(_, _), do: ""

  defp size_classes(size) do
    case size do
      "xs" -> "px-1.5 py-0.5 text-xs"
      "sm" -> "px-2 py-0.5 text-sm"
      "md" -> "px-2.5 py-1 text-sm"
      "lg" -> "px-3 py-1 text-base"
      _ -> "px-2.5 py-1 text-sm"
    end
  end
end
