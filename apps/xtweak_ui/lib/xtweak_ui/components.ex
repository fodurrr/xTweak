defmodule XTweakUI.Components do
  @moduledoc """
  Main components module that imports all UI components.

  Use this module to access all XTweakUI components in your Phoenix application.

  ## Usage

      defmodule MyAppWeb.MyLive do
        use MyAppWeb, :live_view
        use XTweakUI.Components

        def render(assigns) do
          ~H\"\"\"
          <.card>
            <:body>
              <.button>Click me</.button>
            </:body>
          </.card>
          \"\"\"
        end
      end
  """

  defmacro __using__(_opts) do
    quote do
      import XTweakUI.Components.Alert
      import XTweakUI.Components.Button
      import XTweakUI.Components.Card
      import XTweakUI.Components.Modal
    end
  end
end
