defmodule XTweakUI.Components.Card do
  @moduledoc """
  Card component for Phoenix LiveView applications.

  Provides a flexible card layout with header, body, and footer sections.
  """
  use Phoenix.Component

  @doc """
  Renders a card component.

  ## Examples

      <.card>
        <:header>Card Title</:header>
        <:body>Card content goes here</:body>
        <:footer>
          <button>Action</button>
        </:footer>
      </.card>
  """
  attr(:class, :string, default: "")
  attr(:shadow, :boolean, default: true)

  slot(:header)
  slot(:body, required: true)
  slot(:footer)

  def card(assigns) do
    ~H"""
    <div class={[
      "card bg-base-100",
      @shadow && "shadow-xl",
      @class
    ]}>
      <%= if @header != [] do %>
        <div class="card-title px-6 pt-6">
          <%= render_slot(@header) %>
        </div>
      <% end %>

      <div class="card-body">
        <%= render_slot(@body) %>
      </div>

      <%= if @footer != [] do %>
        <div class="card-actions justify-end px-6 pb-6">
          <%= render_slot(@footer) %>
        </div>
      <% end %>
    </div>
    """
  end
end
