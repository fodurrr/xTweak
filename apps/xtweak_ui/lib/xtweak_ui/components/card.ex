defmodule XTweakUI.Components.Card do
  @moduledoc """
  Card component for displaying content with optional header and footer sections.

  Ported from Nuxt UI's UCard component.

  ## Examples

      # Simple card with body content
      <.card>
        <p>Card content goes here</p>
      </.card>

      # Card with header
      <.card>
        <:header>
          <h3>Card Title</h3>
        </:header>
        <p>Main content</p>
      </.card>

      # Card with footer
      <.card>
        <p>Main content</p>
        <:footer>
          <button>Action</button>
        </:footer>
      </.card>

      # Full card with header, body, and footer
      <.card>
        <:header>
          <h3>Card Title</h3>
        </:header>
        <p>Main content goes here</p>
        <:footer>
          <button>Save</button>
          <button>Cancel</button>
        </:footer>
      </.card>

      # Card with variant
      <.card variant="soft">
        <p>Soft variant card</p>
      </.card>

      # Card with custom padding
      <.card padding="none">
        <img src="/image.jpg" alt="Full bleed image" />
      </.card>

  ## Slots

  The Card component uses three slots:

  - `:header` - Optional header section (typically for titles, actions)
  - Default slot (inner_block) - Main body content
  - `:footer` - Optional footer section (typically for actions, metadata)

  All slots are optional, allowing flexible layouts.

  ## Variants

  - `solid` - Inverted background with text
  - `outline` - Default border with dividers between sections
  - `soft` - Elevated background with dividers
  - `subtle` - Elevated background with ring and dividers

  ## Accessibility

  - Semantic HTML with proper section elements
  - Proper color contrast for all variants
  - Screen reader compatible content structure

  ## Nuxt UI Reference

  https://ui.nuxt.com/components/card
  """

  use Phoenix.Component
  alias XTweakUI.Theme

  @doc """
  Renders a card component.
  """
  attr(:variant, :string,
    default: "outline",
    doc: "Visual variant (solid, outline, soft, subtle)"
  )

  attr(:padding, :string,
    default: "md",
    doc: "Padding size for sections (none, sm, md, lg)"
  )

  attr(:class, :string, default: "", doc: "Additional CSS classes for root element")
  attr(:rest, :global, doc: "Additional HTML attributes")

  slot(:header, doc: "Optional header section")
  slot(:inner_block, doc: "Main body content")
  slot(:footer, doc: "Optional footer section")

  def card(assigns) do
    assigns = prepare_card_assigns(assigns)

    ~H"""
    <div class={[root_classes(@variant), @class]} {@rest}>
      <div :if={@header != []} class={section_classes(:header, @padding)}>
        <%= render_slot(@header) %>
      </div>

      <div :if={@inner_block != []} class={section_classes(:body, @padding)}>
        <%= render_slot(@inner_block) %>
      </div>

      <div :if={@footer != []} class={section_classes(:footer, @padding)}>
        <%= render_slot(@footer) %>
      </div>
    </div>
    """
  end

  # Private functions for assigns preparation and class generation

  defp prepare_card_assigns(assigns) do
    theme_config = Theme.component_config(:card)
    defaults = Theme.component_defaults(:card)

    assigns
    |> apply_card_defaults(defaults)
    |> assign(:theme_config, theme_config)
  end

  defp apply_card_defaults(assigns, defaults) do
    assigns
    |> assign_new(:variant, fn -> defaults[:variant] || "outline" end)
    |> assign_new(:padding, fn -> defaults[:padding] || "md" end)
  end

  defp root_classes(variant) do
    base_classes = [
      "rounded-lg",
      "overflow-hidden"
    ]

    variant_class = variant_classes(variant)
    [base_classes, variant_class]
  end

  defp variant_classes(variant) do
    case variant do
      "solid" ->
        [
          "bg-gray-900",
          "text-white",
          "dark:bg-gray-100",
          "dark:text-gray-900"
        ]

      "outline" ->
        [
          "bg-white",
          "dark:bg-gray-900",
          "ring-1",
          "ring-gray-200",
          "dark:ring-gray-800",
          "divide-y",
          "divide-gray-200",
          "dark:divide-gray-800"
        ]

      "soft" ->
        [
          "bg-gray-50/50",
          "dark:bg-gray-900/50",
          "divide-y",
          "divide-gray-200",
          "dark:divide-gray-800"
        ]

      "subtle" ->
        [
          "bg-gray-50/50",
          "dark:bg-gray-900/50",
          "ring-1",
          "ring-gray-200",
          "dark:ring-gray-800",
          "divide-y",
          "divide-gray-200",
          "dark:divide-gray-800"
        ]

      _ ->
        variant_classes("outline")
    end
  end

  defp section_classes(section, padding) do
    base_classes =
      case section do
        :header -> []
        :body -> []
        :footer -> []
      end

    padding_class = padding_classes(padding)
    [base_classes, padding_class]
  end

  defp padding_classes(padding) do
    case padding do
      "none" -> []
      "sm" -> "p-3 sm:px-4"
      "md" -> "p-4 sm:px-6"
      "lg" -> "p-6 sm:px-8"
      _ -> padding_classes("md")
    end
  end
end
