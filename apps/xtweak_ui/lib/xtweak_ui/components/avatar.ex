defmodule XTweakUI.Components.Avatar do
  @moduledoc """
  Avatar component for displaying user profile images with fallbacks.

  Ported from Nuxt UI's UAvatar component.

  ## Examples

      # Avatar with image
      <.avatar src="/images/user.jpg" alt="John Doe" />

      # Avatar with initials fallback (no image)
      <.avatar alt="John Doe" />

      # Avatar with text fallback
      <.avatar text="JD" />

      # Avatar with icon fallback
      <.avatar icon="hero-user" />

      # Avatar with size variants
      <.avatar src="/images/user.jpg" size="xs" />
      <.avatar src="/images/user.jpg" size="lg" />
      <.avatar src="/images/user.jpg" size="xl" />

      # Avatar with status chip
      <.avatar src="/images/user.jpg" chip={%{color: "success", position: "top-right"}} />

  ## Fallback Logic

  The Avatar component uses a cascading fallback system:

  1. **Image** - If `src` is provided, display the image
  2. **Text** - If `text` is provided, display the text
  3. **Icon** - If `icon` is provided, display the icon
  4. **Initials** - Extract initials from `alt` attribute (first letters of first two words)

  ## Accessibility

  - Always provide `alt` text for images
  - Semantic HTML with proper img attributes
  - Screen reader compatible fallbacks
  - Proper color contrast for text/initials

  ## Nuxt UI Reference

  https://ui.nuxt.com/components/avatar
  """

  use Phoenix.Component
  alias XTweakUI.Theme

  @doc """
  Renders an avatar component.
  """
  attr(:src, :string, default: nil, doc: "Image URL")
  attr(:alt, :string, default: "", doc: "Alt text and source for initials fallback")
  attr(:icon, :string, default: nil, doc: "Fallback icon (Heroicons class name)")
  attr(:text, :string, default: nil, doc: "Fallback text to display")

  attr(:size, :string,
    default: "md",
    doc: "Avatar size (3xs, 2xs, xs, sm, md, lg, xl, 2xl, 3xl)"
  )

  attr(:chip, :map,
    default: nil,
    doc: "Optional status chip indicator (map with color, position)"
  )

  attr(:class, :string, default: "", doc: "Additional CSS classes")
  attr(:rest, :global, doc: "Additional HTML attributes")

  slot(:inner_block, doc: "Optional inner content (overrides all fallbacks)")

  def avatar(assigns) do
    assigns = prepare_avatar_assigns(assigns)

    ~H"""
    <span class={["relative inline-flex", @class]} {@rest}>
      <span class={avatar_classes(@size)}>
        <img :if={@src} src={@src} alt={@alt} class={image_classes()} />
        <span :if={!@src && @inner_block != []} class={fallback_classes(@size)}>
          <%= render_slot(@inner_block) %>
        </span>
        <span :if={!@src && @inner_block == [] && @text} class={fallback_classes(@size)}>
          <%= @text %>
        </span>
        <span :if={!@src && @inner_block == [] && !@text && @icon} class={icon_wrapper_classes(@size)}>
          <span class={[@icon, "shrink-0"]} aria-hidden="true"></span>
        </span>
        <span
          :if={!@src && @inner_block == [] && !@text && !@icon && @initials}
          class={fallback_classes(@size)}
        >
          <%= @initials %>
        </span>
      </span>
      <span :if={@chip} class={chip_classes(@chip, @size)}>
        <span class={chip_indicator_classes(@chip)}></span>
      </span>
    </span>
    """
  end

  # Private functions for assigns preparation and class generation

  defp prepare_avatar_assigns(assigns) do
    theme_config = Theme.component_config(:avatar)
    defaults = Theme.component_defaults(:avatar)

    assigns
    |> apply_avatar_defaults(defaults)
    |> assign(:theme_config, theme_config)
    |> assign(:initials, extract_initials(assigns[:alt] || ""))
  end

  defp apply_avatar_defaults(assigns, defaults) do
    assigns
    |> assign_new(:size, fn -> defaults[:size] || "md" end)
  end

  defp extract_initials(alt) when is_binary(alt) do
    alt
    |> String.trim()
    |> String.split(~r/\s+/, parts: 2)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.first/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join()
  end

  defp extract_initials(_), do: ""

  defp avatar_classes(size) do
    base_classes = [
      "inline-flex",
      "items-center",
      "justify-center",
      "shrink-0",
      "select-none",
      "rounded-full",
      "align-middle",
      "bg-gray-100",
      "dark:bg-gray-800",
      "overflow-hidden"
    ]

    size_class = size_classes(size)
    [base_classes, size_class]
  end

  defp image_classes do
    [
      "h-full",
      "w-full",
      "rounded-full",
      "object-cover"
    ]
  end

  defp fallback_classes(size) do
    base_classes = [
      "font-medium",
      "leading-none",
      "text-gray-700",
      "dark:text-gray-300",
      "truncate"
    ]

    text_size = text_size_class(size)
    [base_classes, text_size]
  end

  defp icon_wrapper_classes(size) do
    base_classes = [
      "flex",
      "items-center",
      "justify-center",
      "text-gray-500",
      "dark:text-gray-400"
    ]

    icon_size = icon_size_class(size)
    [base_classes, icon_size]
  end

  # Size configuration map to reduce cyclomatic complexity
  @size_config %{
    "3xs" => %{avatar: "size-4", text: "text-[8px]", icon: "size-3", chip: "size-1.5"},
    "2xs" => %{avatar: "size-5", text: "text-[10px]", icon: "size-3.5", chip: "size-1.5"},
    "xs" => %{avatar: "size-6", text: "text-xs", icon: "size-4", chip: "size-2"},
    "sm" => %{avatar: "size-7", text: "text-sm", icon: "size-4", chip: "size-2"},
    "md" => %{avatar: "size-8", text: "text-base", icon: "size-5", chip: "size-2.5"},
    "lg" => %{avatar: "size-9", text: "text-lg", icon: "size-5", chip: "size-2.5"},
    "xl" => %{avatar: "size-10", text: "text-xl", icon: "size-6", chip: "size-3"},
    "2xl" => %{avatar: "size-11", text: "text-[22px]", icon: "size-6", chip: "size-3"},
    "3xl" => %{avatar: "size-12", text: "text-2xl", icon: "size-7", chip: "size-3.5"}
  }

  @default_size_config %{avatar: "size-8", text: "text-base", icon: "size-5", chip: "size-2.5"}

  defp size_classes(size) do
    get_in(@size_config, [size, :avatar]) || @default_size_config.avatar
  end

  defp text_size_class(size) do
    get_in(@size_config, [size, :text]) || @default_size_config.text
  end

  defp icon_size_class(size) do
    get_in(@size_config, [size, :icon]) || @default_size_config.icon
  end

  defp chip_classes(chip, avatar_size) do
    position = chip[:position] || "top-right"
    inset = chip[:inset] || false

    base_classes = [
      "absolute",
      "rounded-full",
      "ring-2",
      "ring-white",
      "dark:ring-gray-900"
    ]

    position_class = chip_position_class(position, inset)
    size_class = chip_size_class(avatar_size)

    [base_classes, position_class, size_class]
  end

  defp chip_position_class(position, inset) do
    offset = if inset, do: "0", else: "-0.5"

    case position do
      "top-right" -> "top-#{offset} right-#{offset}"
      "top-left" -> "top-#{offset} left-#{offset}"
      "bottom-right" -> "bottom-#{offset} right-#{offset}"
      "bottom-left" -> "bottom-#{offset} left-#{offset}"
      _ -> "top-#{offset} right-#{offset}"
    end
  end

  defp chip_size_class(avatar_size) do
    get_in(@size_config, [avatar_size, :chip]) || @default_size_config.chip
  end

  defp chip_indicator_classes(chip) do
    color = chip[:color] || "gray"

    base_classes = [
      "block",
      "rounded-full",
      "size-full"
    ]

    color_class = chip_color_class(color)
    [base_classes, color_class]
  end

  defp chip_color_class(color) do
    case color do
      "primary" -> "bg-primary-500"
      "success" -> "bg-green-500"
      "warning" -> "bg-yellow-500"
      "error" -> "bg-red-500"
      "info" -> "bg-blue-500"
      "gray" -> "bg-gray-500"
      _ -> "bg-gray-500"
    end
  end
end
