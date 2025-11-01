defmodule XTweakUI.Components.AvatarTest do
  use ExUnit.Case, async: true
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Avatar

  describe "avatar/1" do
    test "renders avatar with image" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/images/user.jpg" alt="John Doe" />
        """)

      assert html =~ "img"
      assert html =~ ~s(src="/images/user.jpg")
      assert html =~ ~s(alt="John Doe")
    end

    test "renders avatar with initials fallback when no src" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="John Doe" />
        """)

      assert html =~ "JD"
    end

    test "renders avatar with text fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar text="AB" />
        """)

      assert html =~ "AB"
    end

    test "renders avatar with icon fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar icon="hero-user" />
        """)

      assert html =~ "hero-user"
    end

    test "applies default size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="User" />
        """)

      # Default is md size
      assert html =~ "size-8"
    end

    test "applies size variants" do
      assigns = %{}

      # 3xs
      html_3xs =
        rendered_to_string(~H"""
        <.avatar size="3xs" alt="User" />
        """)

      assert html_3xs =~ "size-4"

      # 2xs
      html_2xs =
        rendered_to_string(~H"""
        <.avatar size="2xs" alt="User" />
        """)

      assert html_2xs =~ "size-5"

      # xs
      html_xs =
        rendered_to_string(~H"""
        <.avatar size="xs" alt="User" />
        """)

      assert html_xs =~ "size-6"

      # sm
      html_sm =
        rendered_to_string(~H"""
        <.avatar size="sm" alt="User" />
        """)

      assert html_sm =~ "size-7"

      # md
      html_md =
        rendered_to_string(~H"""
        <.avatar size="md" alt="User" />
        """)

      assert html_md =~ "size-8"

      # lg
      html_lg =
        rendered_to_string(~H"""
        <.avatar size="lg" alt="User" />
        """)

      assert html_lg =~ "size-9"

      # xl
      html_xl =
        rendered_to_string(~H"""
        <.avatar size="xl" alt="User" />
        """)

      assert html_xl =~ "size-10"

      # 2xl
      html_2xl =
        rendered_to_string(~H"""
        <.avatar size="2xl" alt="User" />
        """)

      assert html_2xl =~ "size-11"

      # 3xl
      html_3xl =
        rendered_to_string(~H"""
        <.avatar size="3xl" alt="User" />
        """)

      assert html_3xl =~ "size-12"
    end

    test "extracts initials from single word" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="John" />
        """)

      assert html =~ "J"
    end

    test "extracts initials from two words" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="John Doe" />
        """)

      assert html =~ "JD"
    end

    test "extracts initials from multiple words (only first two)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="John Michael Doe" />
        """)

      assert html =~ "JM"
    end

    test "extracts initials in uppercase" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="john doe" />
        """)

      assert html =~ "JD"
    end

    test "handles empty alt gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="" />
        """)

      # Should still render
      assert html =~ "span"
    end

    test "renders with chip indicator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "success"}} />
        """)

      assert html =~ "absolute"
      assert html =~ "rounded-full"
      assert html =~ "bg-green-500"
    end

    test "chip defaults to top-right position" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "success"}} />
        """)

      assert html =~ "top-"
      assert html =~ "right-"
    end

    test "chip supports all positions" do
      assigns = %{}

      # top-right
      html_tr =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{position: "top-right"}} />
        """)

      assert html_tr =~ "top-"
      assert html_tr =~ "right-"

      # top-left
      html_tl =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{position: "top-left"}} />
        """)

      assert html_tl =~ "top-"
      assert html_tl =~ "left-"

      # bottom-right
      html_br =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{position: "bottom-right"}} />
        """)

      assert html_br =~ "bottom-"
      assert html_br =~ "right-"

      # bottom-left
      html_bl =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{position: "bottom-left"}} />
        """)

      assert html_bl =~ "bottom-"
      assert html_bl =~ "left-"
    end

    test "chip supports all colors" do
      assigns = %{}

      # primary
      html_primary =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "primary"}} />
        """)

      assert html_primary =~ "bg-primary-500"

      # success
      html_success =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "success"}} />
        """)

      assert html_success =~ "bg-green-500"

      # warning
      html_warning =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "warning"}} />
        """)

      assert html_warning =~ "bg-yellow-500"

      # error
      html_error =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "error"}} />
        """)

      assert html_error =~ "bg-red-500"

      # info
      html_info =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "info"}} />
        """)

      assert html_info =~ "bg-blue-500"

      # gray
      html_gray =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{color: "gray"}} />
        """)

      assert html_gray =~ "bg-gray-500"
    end

    test "chip has ring border" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" chip={%{}} />
        """)

      assert html =~ "ring-2"
      assert html =~ "ring-white"
    end

    test "accepts custom CSS classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar class="my-custom-class" alt="User" />
        """)

      assert html =~ "my-custom-class"
    end

    test "passes through global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar id="avatar-1" data-testid="test-avatar" alt="User" />
        """)

      assert html =~ ~s(id="avatar-1")
      assert html =~ ~s(data-testid="test-avatar")
    end

    test "includes base theme classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="User" />
        """)

      assert html =~ "rounded-full"
      assert html =~ "inline-flex"
      assert html =~ "items-center"
      assert html =~ "justify-center"
    end

    test "image has proper aspect ratio classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" alt="User" />
        """)

      assert html =~ "h-full"
      assert html =~ "w-full"
      assert html =~ "object-cover"
    end

    test "fallback text has proper styling" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar text="AB" />
        """)

      assert html =~ "font-medium"
      assert html =~ "text-gray-700"
    end

    test "handles invalid size gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar size="invalid" alt="User" />
        """)

      # Should fall back to default md
      assert html =~ "size-8"
    end

    test "prioritizes src over text fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" text="AB" alt="User" />
        """)

      assert html =~ "img"
      refute html =~ ">AB<"
    end

    test "prioritizes text over icon fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar text="AB" icon="hero-user" alt="User" />
        """)

      assert html =~ "AB"
      refute html =~ "hero-user"
    end

    test "prioritizes icon over initials fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar icon="hero-user" alt="John Doe" />
        """)

      assert html =~ "hero-user"
      refute html =~ ">JD<"
    end

    test "supports inner_block content that overrides all fallbacks" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar text="AB" icon="hero-user" alt="John Doe">
          <span>Custom</span>
        </.avatar>
        """)

      assert html =~ "Custom"
      refute html =~ ">AB<"
      refute html =~ "hero-user"
      refute html =~ ">JD<"
    end

    test "avatar with image and chip for online status" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar
          src="/user.jpg"
          alt="Active User"
          chip={%{color: "success", position: "bottom-right"}}
        />
        """)

      assert html =~ "img"
      assert html =~ "bg-green-500"
      assert html =~ "bottom-"
      assert html =~ "right-"
    end

    test "avatar with initials and warning chip" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar alt="Away User" chip={%{color: "warning"}} />
        """)

      assert html =~ "AU"
      assert html =~ "bg-yellow-500"
    end

    test "very small avatar (3xs) with appropriate chip size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar size="3xs" alt="User" chip={%{color: "success"}} />
        """)

      assert html =~ "size-4"
      assert html =~ "size-1.5"
    end

    test "very large avatar (3xl) with appropriate chip size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar size="3xl" alt="User" chip={%{color: "success"}} />
        """)

      assert html =~ "size-12"
      assert html =~ "size-3.5"
    end

    test "avatar has proper accessibility attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar src="/user.jpg" alt="John Doe" />
        """)

      assert html =~ ~s(alt="John Doe")
    end

    test "icon has aria-hidden attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.avatar icon="hero-user" />
        """)

      assert html =~ ~s(aria-hidden="true")
    end
  end
end
