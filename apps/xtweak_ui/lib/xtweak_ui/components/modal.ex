defmodule XTweakUI.Components.Modal do
  @moduledoc """
  Modal component for Phoenix LiveView applications.

  Provides a modal dialog with customizable content.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal component.

  ## Examples

      <.modal id="confirm-modal">
        <:title>Confirm Action</:title>
        <:body>Are you sure you want to proceed?</:body>
        <:footer>
          <button phx-click={hide_modal("confirm-modal")}>Cancel</button>
          <button class="btn-primary">Confirm</button>
        </:footer>
      </.modal>
  """
  attr(:id, :string, required: true)
  attr(:show, :boolean, default: false)

  slot(:title)
  slot(:body, required: true)
  slot(:footer)

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "modal",
        @show && "modal-open"
      ]}
      phx-click={hide_modal(@id)}
    >
      <div class="modal-box" phx-click-away={hide_modal(@id)}>
        <%= if @title != [] do %>
          <h3 class="font-bold text-lg">
            <%= render_slot(@title) %>
          </h3>
        <% end %>

        <div class="py-4">
          <%= render_slot(@body) %>
        </div>

        <%= if @footer != [] do %>
          <div class="modal-action">
            <%= render_slot(@footer) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def show_modal(id) when is_binary(id) do
    JS.add_class("modal-open", to: "##{id}")
  end

  def hide_modal(id) when is_binary(id) do
    JS.remove_class("modal-open", to: "##{id}")
  end
end
