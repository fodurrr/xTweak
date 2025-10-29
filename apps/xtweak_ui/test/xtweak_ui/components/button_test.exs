defmodule XTweakUI.Components.ButtonTest do
  use ExUnit.Case, async: true
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Button

  describe "button/1" do
    test "renders basic button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button>Click me</.button>
        """)

      assert html =~ "Click me"
      assert html =~ "button"
      assert html =~ ~s(type="button")
    end

    test "applies default variant and size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button>Default</.button>
        """)

      assert html =~ "bg-primary-500"
      # solid variant
      assert html =~ "px-4 py-2"
      # md size
    end

    test "applies custom color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button color="success">Success</.button>
        """)

      assert html =~ "bg-green-500"
    end

    test "applies outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button variant="outline">Outline</.button>
        """)

      assert html =~ "border-2"
      assert html =~ "border-primary-500"
    end

    test "applies soft variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button variant="soft">Soft</.button>
        """)

      assert html =~ "bg-primary-100"
      assert html =~ "text-primary-700"
    end

    test "applies ghost variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button variant="ghost">Ghost</.button>
        """)

      assert html =~ "text-primary-500"
      assert html =~ "hover:bg-primary-50"
    end

    test "applies link variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button variant="link">Link</.button>
        """)

      assert html =~ "text-primary-500"
      assert html =~ "hover:underline"
    end

    test "applies size classes" do
      assigns = %{}

      html_xs =
        rendered_to_string(~H"""
        <.button size="xs">Extra Small</.button>
        """)

      assert html_xs =~ "px-2 py-1 text-xs"

      html_sm =
        rendered_to_string(~H"""
        <.button size="sm">Small</.button>
        """)

      assert html_sm =~ "px-3 py-1.5 text-sm"

      html_lg =
        rendered_to_string(~H"""
        <.button size="lg">Large</.button>
        """)

      assert html_lg =~ "px-5 py-2.5 text-lg"

      html_xl =
        rendered_to_string(~H"""
        <.button size="xl">Extra Large</.button>
        """)

      assert html_xl =~ "px-6 py-3 text-xl"
    end

    test "shows loading spinner when loading=true" do
      assigns = %{loading: true}

      html =
        rendered_to_string(~H"""
        <.button loading={@loading}>Loading</.button>
        """)

      assert html =~ "animate-spin"
      assert html =~ "disabled"
    end

    test "disables button when disabled=true" do
      assigns = %{disabled: true}

      html =
        rendered_to_string(~H"""
        <.button disabled={@disabled}>Disabled</.button>
        """)

      assert html =~ "disabled"
    end

    test "renders full width when block=true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button block>Block</.button>
        """)

      assert html =~ "w-full"
    end

    test "renders square button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button square size="md">X</.button>
        """)

      assert html =~ "p-2"
      refute html =~ "px-4"
    end

    test "accepts custom CSS classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button class="my-custom-class">Custom</.button>
        """)

      assert html =~ "my-custom-class"
    end

    test "passes through global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button phx-click="submit" type="submit" name="action" value="save">
          Submit
        </.button>
        """)

      assert html =~ ~s(phx-click="submit")
      assert html =~ ~s(type="submit")
      assert html =~ ~s(name="action")
      assert html =~ ~s(value="save")
    end

    test "renders with label attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button label="Click me" />
        """)

      assert html =~ "Click me"
    end

    test "supports all color variants" do
      colors = ["primary", "secondary", "neutral", "success", "warning", "error"]

      for color <- colors do
        assigns = %{color: color}

        html =
          rendered_to_string(~H"""
          <.button color={@color}><%= @color %></.button>
          """)

        assert html =~ color
      end
    end

    test "leading icon renders correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button leading_icon="hero-check">Save</.button>
        """)

      assert html =~ "hero-check"
      assert html =~ "mr-2"
    end

    test "trailing icon renders correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button trailing_icon="hero-arrow-right">Next</.button>
        """)

      assert html =~ "hero-arrow-right"
      assert html =~ "ml-2"
    end

    test "icon attribute is alias for leading_icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button icon="hero-check">Save</.button>
        """)

      assert html =~ "hero-check"
      assert html =~ "mr-2"
    end

    test "loading spinner hides leading icon" do
      assigns = %{loading: true}

      html =
        rendered_to_string(~H"""
        <.button loading={@loading} leading_icon="hero-check">Save</.button>
        """)

      assert html =~ "animate-spin"
      # Spinner should be present
      refute html =~ "hero-check"
      # Icon should not be rendered
    end

    test "supports different button types" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button type="submit">Submit</.button>
        """)

      assert html =~ ~s(type="submit")

      html_reset =
        rendered_to_string(~H"""
        <.button type="reset">Reset</.button>
        """)

      assert html_reset =~ ~s(type="reset")
    end
  end
end
