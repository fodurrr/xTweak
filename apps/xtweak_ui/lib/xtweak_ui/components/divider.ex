defmodule XTweakUI.Components.Divider do
  @moduledoc """
  Divider component for visually separating content horizontally or vertically.

  Provides flexible layout separation with support for labels, icons, and avatars
  embedded within the divider. Includes customizable orientation, size, color,
  and border type (solid, dashed, dotted).

  ## Features

  - Horizontal and vertical orientations
  - Optional label, icon, or avatar in the center
  - Customizable size (thickness)
  - Color variants matching theme system
  - Border type variants (solid, dashed, dotted)
  - Full theme integration with CSS variables
  - Accessible with proper ARIA attributes

  ## Accessibility

  - Uses `role="separator"` for semantic structure
  - Uses `aria-orientation` to indicate direction
  - Decorative dividers use `aria-hidden="true"` when no label
  - Label dividers remain accessible to screen readers
  - Proper color contrast with theme colors

  ## Examples

      # Simple horizontal divider
      <.divider />

      # Vertical divider (needs container with height)
      <.divider orientation="vertical" class="h-48" />

      # Divider with label
      <.divider label="OR" />

      # Divider with custom icon
      <.divider icon="hero-star" />

      # Divider with avatar
      <.divider avatar={%{src: "/avatar.jpg", alt: "User"}} />

      # Thick divider with color
      <.divider size="lg" color="primary" />

      # Dashed divider
      <.divider type="dashed" />

      # Divider in form sections
      <.divider label="Personal Information" color="primary" />
      <.input label="Name" ... />
      <.input label="Email" ... />

      <.divider label="Address" color="primary" />
      <.input label="Street" ... />
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a divider component with optional label, icon, or avatar.

  ## Attributes

  - `orientation` - Direction of the divider (default: "horizontal")
    - "horizontal" - Horizontal line across width
    - "vertical" - Vertical line across height (requires container with height)
  - `label` - Text label to display in center (optional)
  - `icon` - Icon name to display in center (optional)
  - `avatar` - Avatar props to display in center (optional)
  - `color` - Color variant (default: "neutral")
    - "primary" - Primary brand color
    - "secondary" - Secondary brand color
    - "success" - Success green
    - "info" - Info blue
    - "warning" - Warning yellow/orange
    - "error" - Error red
    - "neutral" - Neutral gray (default)
  - `size` - Border thickness (default: "xs")
    - "xs" - 1px border
    - "sm" - 2px border
    - "md" - 3px border
    - "lg" - 4px border
    - "xl" - 5px border
  - `type` - Border style (default: "solid")
    - "solid" - Solid line
    - "dashed" - Dashed line
    - "dotted" - Dotted line
  - `decorative` - Whether divider is purely decorative (default: auto-detected)
    When true, uses aria-hidden. Auto-set to true when no label/icon/avatar.
  - `class` - Additional CSS classes for root element
  - `rest` - Additional HTML attributes

  ## Slots

  - `inner_block` - Custom content to display in center (overrides label/icon/avatar)
  """
  attr(:orientation, :string, default: "horizontal", values: ~w(horizontal vertical))
  attr(:label, :string, default: nil)
  attr(:icon, :string, default: nil)
  attr(:avatar, :map, default: nil)

  attr(:color, :string,
    default: "neutral",
    values: ~w(primary secondary success info warning error neutral)
  )

  attr(:size, :string, default: "xs", values: ~w(xs sm md lg xl))
  attr(:type, :string, default: "solid", values: ~w(solid dashed dotted))
  attr(:decorative, :boolean, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, doc: "Custom content in center of divider")

  def divider(assigns) do
    has_content = has_divider_content?(assigns)

    # Auto-detect decorative when not explicitly set
    decorative =
      if is_nil(assigns.decorative) do
        !has_content
      else
        assigns.decorative
      end

    assigns =
      assigns
      |> assign(:has_content, has_content)
      |> assign(:decorative, decorative)
      |> assign(:avatar_size, "2xs")

    ~H"""
    <div
      :if={@decorative}
      role="separator"
      aria-orientation={@orientation}
      aria-hidden="true"
      class={[
        "flex items-center align-center text-center",
        orientation_root_classes(@orientation),
        @class
      ]}
      {@rest}
    >
      <!-- Border before content (only with content) -->
      <div :if={@has_content} class={border_classes(@orientation, @size, @type, @color)} />

      <!-- Content container (only with content) -->
      <div :if={@has_content} class={[
        "font-medium text-gray-700 dark:text-gray-300 flex shrink-0",
        container_spacing_classes(@orientation)
      ]}>
        <span :if={@inner_block != []}><%= render_slot(@inner_block) %></span>
        <.avatar_content :if={@inner_block == [] && @avatar} avatar={@avatar} size={@avatar_size} />
        <.icon :if={@inner_block == [] && !@avatar && @icon} name={@icon} class="shrink-0 size-5" />
        <span :if={@inner_block == [] && !@avatar && !@icon && @label} class="text-sm whitespace-nowrap"><%= @label %></span>
      </div>

      <!-- Border after content (only with content) -->
      <div :if={@has_content} class={border_classes(@orientation, @size, @type, @color)} />

      <!-- Simple divider without content -->
      <div :if={!@has_content} class={border_classes(@orientation, @size, @type, @color)} />
    </div>

    <div
      :if={!@decorative}
      role="separator"
      aria-orientation={@orientation}
      class={[
        "flex items-center align-center text-center",
        orientation_root_classes(@orientation),
        @class
      ]}
      {@rest}
    >
      <!-- Border before content (only with content) -->
      <div :if={@has_content} class={border_classes(@orientation, @size, @type, @color)} />

      <!-- Content container (only with content) -->
      <div :if={@has_content} class={[
        "font-medium text-gray-700 dark:text-gray-300 flex shrink-0",
        container_spacing_classes(@orientation)
      ]}>
        <span :if={@inner_block != []}><%= render_slot(@inner_block) %></span>
        <.avatar_content :if={@inner_block == [] && @avatar} avatar={@avatar} size={@avatar_size} />
        <.icon :if={@inner_block == [] && !@avatar && @icon} name={@icon} class="shrink-0 size-5" />
        <span :if={@inner_block == [] && !@avatar && !@icon && @label} class="text-sm whitespace-nowrap"><%= @label %></span>
      </div>

      <!-- Border after content (only with content) -->
      <div :if={@has_content} class={border_classes(@orientation, @size, @type, @color)} />

      <!-- Simple divider without content -->
      <div :if={!@has_content} class={border_classes(@orientation, @size, @type, @color)} />
    </div>
    """
  end

  # Private helper: Check if divider has any content
  defp has_divider_content?(assigns) do
    assigns.inner_block != [] ||
      not is_nil(assigns.label) ||
      not is_nil(assigns.icon) ||
      not is_nil(assigns.avatar)
  end

  # Private helper: Root orientation classes
  defp orientation_root_classes("horizontal"), do: "w-full flex-row"
  defp orientation_root_classes("vertical"), do: "h-full flex-col"

  # Private helper: Container spacing classes
  defp container_spacing_classes("horizontal"), do: "mx-3"
  defp container_spacing_classes("vertical"), do: "my-2"

  # Private helper: Border classes based on orientation, size, type, and color
  defp border_classes(orientation, size, type, color) do
    [
      # Width/height (full span)
      border_dimension_classes(orientation),
      # Border direction and thickness
      border_size_classes(orientation, size),
      # Border style
      border_type_classes(type),
      # Border color
      border_color_classes(color)
    ]
  end

  defp border_dimension_classes("horizontal"), do: "w-full"
  defp border_dimension_classes("vertical"), do: "h-full"

  # Border size classes (compound: orientation + size)
  defp border_size_classes("horizontal", "xs"), do: "border-t"
  defp border_size_classes("horizontal", "sm"), do: "border-t-[2px]"
  defp border_size_classes("horizontal", "md"), do: "border-t-[3px]"
  defp border_size_classes("horizontal", "lg"), do: "border-t-[4px]"
  defp border_size_classes("horizontal", "xl"), do: "border-t-[5px]"
  defp border_size_classes("vertical", "xs"), do: "border-s"
  defp border_size_classes("vertical", "sm"), do: "border-s-[2px]"
  defp border_size_classes("vertical", "md"), do: "border-s-[3px]"
  defp border_size_classes("vertical", "lg"), do: "border-s-[4px]"
  defp border_size_classes("vertical", "xl"), do: "border-s-[5px]"

  # Border type classes
  defp border_type_classes("solid"), do: "border-solid"
  defp border_type_classes("dashed"), do: "border-dashed"
  defp border_type_classes("dotted"), do: "border-dotted"

  # Border color classes
  defp border_color_classes("primary"), do: "border-primary-500"
  defp border_color_classes("secondary"), do: "border-gray-500"
  defp border_color_classes("success"), do: "border-green-500"
  defp border_color_classes("info"), do: "border-blue-500"
  defp border_color_classes("warning"), do: "border-yellow-500"
  defp border_color_classes("error"), do: "border-red-500"

  defp border_color_classes("neutral"),
    do: "border-gray-200 dark:border-gray-800"

  # Private helper: Avatar content (simplified Avatar component)
  defp avatar_content(assigns) do
    ~H"""
    <div class={[
      "inline-flex items-center justify-center shrink-0 rounded-full overflow-hidden",
      "bg-gray-100 dark:bg-gray-800",
      avatar_size_classes(@size)
    ]}>
      <img
        :if={Map.get(@avatar, :src)}
        src={@avatar.src}
        alt={Map.get(@avatar, :alt, "")}
        class="object-cover w-full h-full"
      />
      <.icon :if={!Map.get(@avatar, :src) && Map.get(@avatar, :icon)} name={@avatar.icon} class={avatar_icon_classes(@size)} />
      <span
        :if={!Map.get(@avatar, :src) && !Map.get(@avatar, :icon)}
        class={[
          "font-medium text-gray-700 dark:text-gray-300",
          avatar_text_classes(@size)
        ]}
      >
        <%= avatar_text(@avatar) %>
      </span>
    </div>
    """
  end

  defp avatar_size_classes("3xs"), do: "size-4"
  defp avatar_size_classes("2xs"), do: "size-5"
  defp avatar_size_classes("xs"), do: "size-6"
  defp avatar_size_classes("sm"), do: "size-7"
  defp avatar_size_classes("md"), do: "size-8"
  defp avatar_size_classes("lg"), do: "size-10"
  defp avatar_size_classes("xl"), do: "size-12"
  defp avatar_size_classes("2xl"), do: "size-14"
  defp avatar_size_classes("3xl"), do: "size-16"

  defp avatar_icon_classes("3xs"), do: "size-2.5"
  defp avatar_icon_classes("2xs"), do: "size-3"
  defp avatar_icon_classes("xs"), do: "size-3.5"
  defp avatar_icon_classes(_), do: "size-4"

  defp avatar_text_classes("3xs"), do: "text-[0.5rem]"
  defp avatar_text_classes("2xs"), do: "text-[0.625rem]"
  defp avatar_text_classes("xs"), do: "text-xs"
  defp avatar_text_classes(_), do: "text-sm"

  defp avatar_text(avatar) do
    cond do
      text = Map.get(avatar, :text) -> text
      alt = Map.get(avatar, :alt) -> String.slice(alt, 0..1) |> String.upcase()
      true -> "?"
    end
  end

  # Private helper: Icon component
  defp icon(assigns) do
    ~H"""
    <span class={["inline-block", @class]} aria-hidden="true">
      <%= raw(heroicon(@name)) %>
    </span>
    """
  end

  # Private helper: Heroicon SVG generator (minimal set for divider use cases)
  defp heroicon("hero-star") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-user") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM3.751 20.105a8.25 8.25 0 0116.498 0 .75.75 0 01-.437.695A18.683 18.683 0 0112 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 01-.437-.695z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-ellipsis-horizontal") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M4.5 12a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zm6 0a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zm6 0a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp heroicon("hero-ellipsis-vertical") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill-rule="evenodd" d="M10.5 6a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zm0 6a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zm0 6a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  # Fallback for unknown icons
  defp heroicon(_name) do
    heroicon("hero-ellipsis-horizontal")
  end
end
