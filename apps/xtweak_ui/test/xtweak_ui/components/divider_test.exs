defmodule XTweakUI.Components.DividerTest do
  use ExUnit.Case, async: true
  import Phoenix.Component
  import Phoenix.LiveViewTest

  alias XTweakUI.Components.Divider

  describe "divider/1 basic rendering" do
    test "renders a horizontal divider by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ ~s(role="separator")
      assert html =~ ~s(aria-orientation="horizontal")
      assert html =~ "w-full"
      assert html =~ "flex-row"
    end

    test "renders a vertical divider" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" />
        """)

      assert html =~ ~s(aria-orientation="vertical")
      assert html =~ "h-full"
      assert html =~ "flex-col"
    end

    test "renders decorative divider with aria-hidden" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ ~s(aria-hidden="true")
    end

    test "renders non-decorative divider without aria-hidden when label present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Section" />
        """)

      refute html =~ ~s(aria-hidden="true")
    end
  end

  describe "divider/1 with label" do
    test "renders horizontal divider with label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="OR" />
        """)

      assert html =~ "OR"
      assert html =~ "text-sm"
      assert html =~ "whitespace-nowrap"
    end

    test "renders vertical divider with label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" label="Section" />
        """)

      assert html =~ "Section"
      assert html =~ "my-2"
    end

    test "renders label with proper spacing for horizontal orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Content" />
        """)

      assert html =~ "mx-3"
      assert html =~ "Content"
    end

    test "renders label with proper spacing for vertical orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" label="Content" />
        """)

      assert html =~ "my-2"
      assert html =~ "Content"
    end

    test "splits divider into two borders when label present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Middle" />
        """)

      # Should have two border elements (before and after label)
      assert String.contains?(html, "border-t") or String.contains?(html, "border-s")
      assert html =~ "Middle"
    end
  end

  describe "divider/1 with icon" do
    test "renders divider with icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-star" />
        """)

      assert html =~ "size-5"
      assert html =~ "shrink-0"
      assert html =~ "<svg"
    end

    test "renders icon in horizontal divider with proper spacing" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-star" />
        """)

      assert html =~ "mx-3"
      assert html =~ "<svg"
    end

    test "renders icon in vertical divider with proper spacing" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" icon="hero-star" />
        """)

      assert html =~ "my-2"
      assert html =~ "<svg"
    end

    test "icon has aria-hidden attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-star" />
        """)

      assert html =~ ~s(aria-hidden="true")
    end
  end

  describe "divider/1 with avatar" do
    test "renders divider with avatar image" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{src: "/avatar.jpg", alt: "User"}} />
        """)

      assert html =~ ~s(src="/avatar.jpg")
      assert html =~ ~s(alt="User")
      assert html =~ "rounded-full"
    end

    test "renders divider with avatar text fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{text: "AB"}} />
        """)

      assert html =~ "AB"
      assert html =~ "rounded-full"
      assert html =~ "bg-gray-100"
    end

    test "renders divider with avatar using alt initials" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{alt: "John Doe"}} />
        """)

      assert html =~ "JO"
      assert html =~ "rounded-full"
    end

    test "renders divider with avatar icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{icon: "hero-user"}} />
        """)

      assert html =~ "<svg"
      assert html =~ "rounded-full"
    end

    test "avatar has default 2xs size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{text: "AB"}} />
        """)

      assert html =~ "size-5"
    end
  end

  describe "divider/1 with inner_block slot" do
    test "renders custom content in inner_block" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider>
          <span class="custom-content">Custom</span>
        </Divider.divider>
        """)

      assert html =~ "custom-content"
      assert html =~ "Custom"
    end

    test "inner_block overrides label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Ignored">
          <span>Custom</span>
        </Divider.divider>
        """)

      assert html =~ "Custom"
      refute html =~ "Ignored"
    end

    test "inner_block overrides icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-star">
          <span>Custom</span>
        </Divider.divider>
        """)

      assert html =~ "Custom"
    end

    test "inner_block overrides avatar" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{text: "AB"}}>
          <span>Custom</span>
        </Divider.divider>
        """)

      assert html =~ "Custom"
      refute html =~ "AB"
    end
  end

  describe "divider/1 size variants" do
    test "renders xs size (default)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ "border-t"
      refute html =~ "border-t-["
    end

    test "renders sm size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider size="sm" />
        """)

      assert html =~ "border-t-[2px]"
    end

    test "renders md size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider size="md" />
        """)

      assert html =~ "border-t-[3px]"
    end

    test "renders lg size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider size="lg" />
        """)

      assert html =~ "border-t-[4px]"
    end

    test "renders xl size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider size="xl" />
        """)

      assert html =~ "border-t-[5px]"
    end

    test "renders vertical xs size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" size="xs" />
        """)

      assert html =~ "border-s"
      refute html =~ "border-s-["
    end

    test "renders vertical sm size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" size="sm" />
        """)

      assert html =~ "border-s-[2px]"
    end

    test "renders vertical lg size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" size="lg" />
        """)

      assert html =~ "border-s-[4px]"
    end
  end

  describe "divider/1 type variants" do
    test "renders solid type (default)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ "border-solid"
    end

    test "renders dashed type" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider type="dashed" />
        """)

      assert html =~ "border-dashed"
    end

    test "renders dotted type" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider type="dotted" />
        """)

      assert html =~ "border-dotted"
    end
  end

  describe "divider/1 color variants" do
    test "renders neutral color (default)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ "border-gray-200"
      assert html =~ "dark:border-gray-800"
    end

    test "renders primary color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="primary" />
        """)

      assert html =~ "border-primary-500"
    end

    test "renders secondary color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="secondary" />
        """)

      assert html =~ "border-gray-500"
    end

    test "renders success color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="success" />
        """)

      assert html =~ "border-green-500"
    end

    test "renders info color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="info" />
        """)

      assert html =~ "border-blue-500"
    end

    test "renders warning color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="warning" />
        """)

      assert html =~ "border-yellow-500"
    end

    test "renders error color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider color="error" />
        """)

      assert html =~ "border-red-500"
    end
  end

  describe "divider/1 compound variants" do
    test "renders horizontal lg dashed primary divider" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider size="lg" type="dashed" color="primary" />
        """)

      assert html =~ "border-t-[4px]"
      assert html =~ "border-dashed"
      assert html =~ "border-primary-500"
    end

    test "renders vertical md dotted success divider" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" size="md" type="dotted" color="success" />
        """)

      assert html =~ "border-s-[3px]"
      assert html =~ "border-dotted"
      assert html =~ "border-green-500"
    end

    test "renders horizontal divider with label and color" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Section" color="primary" />
        """)

      assert html =~ "Section"
      assert html =~ "border-primary-500"
      assert html =~ "mx-3"
    end

    test "renders vertical divider with icon and size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" icon="hero-star" size="lg" />
        """)

      assert html =~ "<svg"
      assert html =~ "border-s-[4px]"
      assert html =~ "my-2"
    end
  end

  describe "divider/1 custom attributes" do
    test "accepts custom class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider class="my-custom-class" />
        """)

      assert html =~ "my-custom-class"
    end

    test "accepts global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider data-test="divider" />
        """)

      assert html =~ ~s(data-test="divider")
    end

    test "accepts id attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider id="my-divider" />
        """)

      # ID is rendered via rest attributes
      assert html =~ ~s(id="my-divider")
    end
  end

  describe "divider/1 accessibility" do
    test "has role separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ ~s(role="separator")
    end

    test "has aria-orientation for horizontal" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ ~s(aria-orientation="horizontal")
    end

    test "has aria-orientation for vertical" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" />
        """)

      assert html =~ ~s(aria-orientation="vertical")
    end

    test "decorative divider has aria-hidden" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider decorative />
        """)

      assert html =~ ~s(aria-hidden="true")
    end

    test "non-decorative divider does not have aria-hidden" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider decorative={false} />
        """)

      refute html =~ ~s(aria-hidden="true")
    end

    test "auto-detects decorative when no content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ ~s(aria-hidden="true")
    end

    test "auto-detects non-decorative when label present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Section" />
        """)

      refute html =~ ~s(aria-hidden="true")
    end

    test "auto-detects non-decorative when icon present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-star" />
        """)

      # Check that the divider root doesn't have aria-hidden (but the icon SVG will)
      refute html =~ ~r/<div[^>]*role="separator"[^>]*aria-hidden="true"/
    end

    test "auto-detects non-decorative when avatar present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={%{text: "AB"}} />
        """)

      refute html =~ ~s(aria-hidden="true")
    end

    test "auto-detects non-decorative when inner_block present" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider>
          <span>Content</span>
        </Divider.divider>
        """)

      refute html =~ ~s(aria-hidden="true")
    end
  end

  describe "divider/1 layout patterns" do
    test "horizontal divider fills width" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ "w-full"
    end

    test "vertical divider fills height" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" />
        """)

      assert html =~ "h-full"
    end

    test "horizontal divider uses flex-row" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider />
        """)

      assert html =~ "flex-row"
    end

    test "vertical divider uses flex-col" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider orientation="vertical" />
        """)

      assert html =~ "flex-col"
    end

    test "content has shrink-0 to prevent collapse" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="Content" />
        """)

      assert html =~ "shrink-0"
    end
  end

  describe "divider/1 edge cases" do
    test "handles empty label gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider label="" />
        """)

      # Empty label should still render container
      assert html =~ "mx-3"
    end

    test "handles nil avatar gracefully" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider avatar={nil} />
        """)

      # Should render as decorative divider
      assert html =~ ~s(aria-hidden="true")
    end

    test "handles unknown icon gracefully with fallback" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider icon="hero-unknown-icon" />
        """)

      # Should render fallback icon (ellipsis-horizontal)
      assert html =~ "<svg"
    end

    test "renders with all attributes combined" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Divider.divider
          orientation="horizontal"
          label="Section"
          size="lg"
          type="dashed"
          color="primary"
          class="custom-class"
        />
        """)

      assert html =~ "Section"
      assert html =~ "border-t-[4px]"
      assert html =~ "border-dashed"
      assert html =~ "border-primary-500"
      assert html =~ "custom-class"
    end
  end
end
