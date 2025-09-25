defmodule XTweakUI.Components.Button do
  @moduledoc """
  Button component for Phoenix LiveView applications.

  Provides a customizable button with various styles and sizes.
  """
  use Phoenix.Component

  @doc """
  Renders a button component.

  ## Examples

      <.button>Click me</.button>
      <.button variant="primary" size="lg">Submit</.button>
      <.button variant="danger" disabled={true}>Delete</.button>
  """
  attr(:variant, :string,
    default: "primary",
    values: ~w(primary secondary danger success warning)
  )

  attr(:size, :string, default: "md", values: ~w(sm md lg))
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: "")
  attr(:rest, :global, include: ~w(type form name value))

  slot(:inner_block, required: true)

  def button(assigns) do
    ~H"""
    <button
      class={[
        "btn",
        button_variant(@variant),
        button_size(@size),
        @class
      ]}
      disabled={@disabled}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp button_variant("primary"), do: "btn-primary"
  defp button_variant("secondary"), do: "btn-secondary"
  defp button_variant("danger"), do: "btn-error"
  defp button_variant("success"), do: "btn-success"
  defp button_variant("warning"), do: "btn-warning"
  defp button_variant(_), do: "btn-primary"

  defp button_size("sm"), do: "btn-sm"
  defp button_size("md"), do: ""
  defp button_size("lg"), do: "btn-lg"
  defp button_size(_), do: ""
end
