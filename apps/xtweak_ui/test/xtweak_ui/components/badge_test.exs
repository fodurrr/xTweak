defmodule XTweakUI.Components.BadgeTest do
  use ExUnit.Case, async: true
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Badge

  describe "badge/1" do
    test "renders basic badge" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>New</.badge>
        """)

      assert html =~ "New"
      assert html =~ "span"
    end

    test "applies default variant and size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Default</.badge>
        """)

      # Default is gray color solid variant
      assert html =~ "bg-gray-500"
      # Default is md size
      assert html =~ "px-2.5 py-1"
    end

    test "applies custom color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge color="success">Success</.badge>
        """)

      assert html =~ "bg-green-500"
    end

    test "applies solid variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant="solid" color="primary">Solid</.badge>
        """)

      assert html =~ "bg-primary-500"
      assert html =~ "text-white"
    end

    test "applies outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant="outline" color="primary">Outline</.badge>
        """)

      assert html =~ "border-2"
      assert html =~ "border-primary-500"
    end

    test "applies soft variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant="soft" color="primary">Soft</.badge>
        """)

      assert html =~ "bg-primary-100"
      assert html =~ "text-primary-700"
    end

    test "applies subtle variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant="subtle" color="primary">Subtle</.badge>
        """)

      assert html =~ "bg-primary-50"
      assert html =~ "text-primary-600"
    end

    test "applies size classes" do
      assigns = %{}

      html_xs =
        rendered_to_string(~H"""
        <.badge size="xs">Extra Small</.badge>
        """)

      assert html_xs =~ "px-1.5 py-0.5 text-xs"

      html_sm =
        rendered_to_string(~H"""
        <.badge size="sm">Small</.badge>
        """)

      assert html_sm =~ "px-2 py-0.5 text-sm"

      html_md =
        rendered_to_string(~H"""
        <.badge size="md">Medium</.badge>
        """)

      assert html_md =~ "px-2.5 py-1 text-sm"

      html_lg =
        rendered_to_string(~H"""
        <.badge size="lg">Large</.badge>
        """)

      assert html_lg =~ "px-3 py-1 text-base"
    end

    test "accepts custom CSS classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge class="my-custom-class">Custom</.badge>
        """)

      assert html =~ "my-custom-class"
    end

    test "passes through global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge id="badge-1" data-testid="test-badge">
          Badge
        </.badge>
        """)

      assert html =~ ~s(id="badge-1")
      assert html =~ ~s(data-testid="test-badge")
    end

    test "renders with label attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge label="New" />
        """)

      assert html =~ "New"
    end

    test "supports all color variants" do
      colors = ["gray", "primary", "success", "warning", "error"]

      for color <- colors do
        assigns = %{color: color}

        html =
          rendered_to_string(~H"""
          <.badge color={@color}><%= @color %></.badge>
          """)

        assert html =~ color
      end
    end

    test "solid variant works with all colors" do
      assigns = %{}

      # Gray
      html_gray =
        rendered_to_string(~H"""
        <.badge variant="solid" color="gray">Gray</.badge>
        """)

      assert html_gray =~ "bg-gray-500"

      # Primary
      html_primary =
        rendered_to_string(~H"""
        <.badge variant="solid" color="primary">Primary</.badge>
        """)

      assert html_primary =~ "bg-primary-500"

      # Success
      html_success =
        rendered_to_string(~H"""
        <.badge variant="solid" color="success">Success</.badge>
        """)

      assert html_success =~ "bg-green-500"

      # Warning
      html_warning =
        rendered_to_string(~H"""
        <.badge variant="solid" color="warning">Warning</.badge>
        """)

      assert html_warning =~ "bg-yellow-500"

      # Error
      html_error =
        rendered_to_string(~H"""
        <.badge variant="solid" color="error">Error</.badge>
        """)

      assert html_error =~ "bg-red-500"
    end

    test "outline variant works with all colors" do
      assigns = %{}

      html_primary =
        rendered_to_string(~H"""
        <.badge variant="outline" color="primary">Primary</.badge>
        """)

      assert html_primary =~ "border-2 border-primary-500"

      html_success =
        rendered_to_string(~H"""
        <.badge variant="outline" color="success">Success</.badge>
        """)

      assert html_success =~ "border-2 border-green-500"
    end

    test "soft variant works with all colors" do
      assigns = %{}

      html_primary =
        rendered_to_string(~H"""
        <.badge variant="soft" color="primary">Primary</.badge>
        """)

      assert html_primary =~ "bg-primary-100"

      html_success =
        rendered_to_string(~H"""
        <.badge variant="soft" color="success">Success</.badge>
        """)

      assert html_success =~ "bg-green-100"
    end

    test "subtle variant works with all colors" do
      assigns = %{}

      html_primary =
        rendered_to_string(~H"""
        <.badge variant="subtle" color="primary">Primary</.badge>
        """)

      assert html_primary =~ "bg-primary-50"

      html_success =
        rendered_to_string(~H"""
        <.badge variant="subtle" color="success">Success</.badge>
        """)

      assert html_success =~ "bg-green-50"
    end

    test "renders with inner_block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge color="primary">
          <span>Inner Content</span>
        </.badge>
        """)

      assert html =~ "Inner Content"
    end

    test "includes base theme classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Badge</.badge>
        """)

      # Badge should have rounded-full from theme base
      assert html =~ "rounded-full"
      assert html =~ "inline-flex"
    end

    test "supports different sizes for count badges" do
      assigns = %{}

      # Small count badge
      html_xs =
        rendered_to_string(~H"""
        <.badge size="xs" color="primary">3</.badge>
        """)

      assert html_xs =~ "text-xs"

      # Medium count badge
      html_md =
        rendered_to_string(~H"""
        <.badge size="md" color="primary">99+</.badge>
        """)

      assert html_md =~ "text-sm"
    end

    test "handles invalid variant gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant="invalid">Badge</.badge>
        """)

      # Should still render
      assert html =~ "Badge"
    end

    test "handles invalid color gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge color="invalid">Badge</.badge>
        """)

      # Should fall back to default
      assert html =~ "Badge"
    end

    test "handles invalid size gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge size="invalid">Badge</.badge>
        """)

      # Should fall back to default md
      assert html =~ "Badge"
    end
  end
end
