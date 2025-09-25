defmodule XTweakUI.Components.Alert do
  @moduledoc """
  Alert component for Phoenix LiveView applications.

  Displays informational, warning, or error messages.
  """
  use Phoenix.Component

  @doc """
  Renders an alert component.

  ## Examples

      <.alert type="info">This is an informational message</.alert>
      <.alert type="success">Operation completed successfully</.alert>
      <.alert type="error" dismissible={true}>An error occurred</.alert>
  """
  attr(:type, :string, default: "info", values: ~w(info success warning error))
  attr(:dismissible, :boolean, default: false)
  attr(:class, :string, default: "")

  slot(:inner_block, required: true)

  def alert(assigns) do
    ~H"""
    <div role="alert" class={[
      "alert",
      alert_type(@type),
      @class
    ]}>
      <%= render_slot(@inner_block) %>
      <%= if @dismissible do %>
        <button class="btn btn-sm btn-circle btn-ghost" phx-click="dismiss-alert">✕</button>
      <% end %>
    </div>
    """
  end

  defp alert_type("info"), do: "alert-info"
  defp alert_type("success"), do: "alert-success"
  defp alert_type("warning"), do: "alert-warning"
  defp alert_type("error"), do: "alert-error"
  defp alert_type(_), do: "alert-info"
end
