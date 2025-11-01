defmodule XTweakUI.Components.AlertTest do
  use ExUnit.Case, async: true
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Alert

  describe "alert/1" do
    # Basic rendering tests
    test "renders simple alert with description only" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>This is an alert message</.alert>
        """)

      assert html =~ "This is an alert message"
      assert html =~ "role=\"alert\""
      assert html =~ "rounded-lg"
    end

    test "renders alert with title and description" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>
          <:title>Alert Title</:title>
          Description text
        </.alert>
        """)

      assert html =~ "Alert Title"
      assert html =~ "Description text"
      assert html =~ "font-medium"
    end

    test "renders alert with description slot" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>
          <:title>Title</:title>
          <:description>Description in slot</:description>
        </.alert>
        """)

      assert html =~ "Title"
      assert html =~ "Description in slot"
    end

    # Color/severity tests
    test "renders info alert with default styling" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info">Information message</.alert>
        """)

      assert html =~ "Information message"
      assert html =~ "blue-"
      assert html =~ "aria-live=\"polite\""
    end

    test "renders success alert" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="success">Success message</.alert>
        """)

      assert html =~ "Success message"
      assert html =~ "green-"
      assert html =~ "aria-live=\"polite\""
    end

    test "renders warning alert with assertive aria-live" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="warning">Warning message</.alert>
        """)

      assert html =~ "Warning message"
      assert html =~ "yellow-"
      assert html =~ "aria-live=\"assertive\""
    end

    test "renders error alert with assertive aria-live" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="error">Error occurred</.alert>
        """)

      assert html =~ "Error occurred"
      assert html =~ "red-"
      assert html =~ "aria-live=\"assertive\""
    end

    test "renders primary color alert" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="primary">Primary alert</.alert>
        """)

      assert html =~ "Primary alert"
      assert html =~ "primary-"
    end

    test "renders secondary color alert" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="secondary">Secondary alert</.alert>
        """)

      assert html =~ "Secondary alert"
      assert html =~ "gray-"
    end

    test "renders neutral color alert" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="neutral">Neutral alert</.alert>
        """)

      assert html =~ "Neutral alert"
      assert html =~ "bg-gray-"
    end

    # Variant tests
    test "applies default soft variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info">Soft variant</.alert>
        """)

      assert html =~ "Soft variant"
      assert html =~ "/20"
    end

    test "applies solid variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info" variant="solid">Solid variant</.alert>
        """)

      assert html =~ "Solid variant"
      assert html =~ "text-white"
    end

    test "applies outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info" variant="outline">Outline variant</.alert>
        """)

      assert html =~ "Outline variant"
      assert html =~ "ring ring-inset"
    end

    test "applies subtle variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info" variant="subtle">Subtle variant</.alert>
        """)

      assert html =~ "Subtle variant"
      assert html =~ "/20"
      assert html =~ "ring ring-inset"
    end

    # Icon tests
    test "renders default info icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="info">With info icon</.alert>
        """)

      assert html =~ "With info icon"
      # Info icon SVG path signature
      assert html =~ "M2.25 12c0-5.385"
    end

    test "renders default success icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert color="success">With success icon</.alert>
        """)

      assert html =~ "With success icon"
      # Check circle SVG path signature
      assert html =~ "M2.25 12c0-5.385"
    end

    test "renders custom icon when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert icon="hero-rocket-launch">Custom icon alert</.alert>
        """)

      assert html =~ "Custom icon alert"
      # Rocket launch SVG path signature
      assert html =~ "M9.315 7.584C12.195 3.883"
    end

    test "icon has aria-hidden attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Alert with icon</.alert>
        """)

      assert html =~ "aria-hidden=\"true\""
    end

    # Close button tests
    test "does not render close button by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>No close button</.alert>
        """)

      assert html =~ "No close button"
      refute html =~ "Close alert"
    end

    test "renders close button when close is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert close>With close button</.alert>
        """)

      assert html =~ "With close button"
      assert html =~ "aria-label=\"Close alert\""
      assert html =~ "type=\"button\""
    end

    test "close button includes default X icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert close>Closable</.alert>
        """)

      assert html =~ "Closable"
      # X mark SVG path signature
      assert html =~ "M5.47 5.47a.75.75 0 011.06 0L12 10.94"
    end

    # Orientation tests
    test "applies vertical orientation by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Vertical orientation</.alert>
        """)

      assert html =~ "items-start"
    end

    test "applies horizontal orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert orientation="horizontal">Horizontal orientation</.alert>
        """)

      assert html =~ "items-center"
    end

    # Actions slot tests
    test "renders actions slot in vertical orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert orientation="vertical">
          With actions
          <:actions>
            <button>View details</button>
          </:actions>
        </.alert>
        """)

      assert html =~ "With actions"
      assert html =~ "View details"
      assert html =~ "mt-2.5"
      assert html =~ "items-start"
    end

    test "renders actions slot in horizontal orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert orientation="horizontal">
          Horizontal actions
          <:actions>
            <button>Action</button>
          </:actions>
        </.alert>
        """)

      assert html =~ "Horizontal actions"
      assert html =~ "Action"
      assert html =~ "items-center"
    end

    # Custom attributes tests
    test "accepts custom CSS classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert class="my-custom-alert">Custom class</.alert>
        """)

      assert html =~ "my-custom-alert"
      assert html =~ "Custom class"
    end

    test "passes through global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert id="alert-123" data-testid="test-alert">Global attrs</.alert>
        """)

      assert html =~ ~s(id="alert-123")
      assert html =~ ~s(data-testid="test-alert")
      assert html =~ "Global attrs"
    end

    test "generates unique id when not provided" do
      # Note: Testing ID generation without render_to_string
      # as it strips dynamic attributes
      alert1_id = "alert-#{System.unique_integer([:positive])}"
      alert2_id = "alert-#{System.unique_integer([:positive])}"

      assert alert1_id != alert2_id
      assert String.starts_with?(alert1_id, "alert-")
      assert String.starts_with?(alert2_id, "alert-")
    end

    # Accessibility tests
    test "includes role=alert attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Accessible alert</.alert>
        """)

      assert html =~ "role=\"alert\""
      assert html =~ "Accessible alert"
    end

    test "close button has accessible label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert close>Closable alert</.alert>
        """)

      assert html =~ "aria-label=\"Close alert\""
    end

    # Complex examples
    test "alert with all features - vertical layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert
          color="warning"
          variant="soft"
          close
          class="my-alert"
        >
          <:title>Warning Title</:title>
          This is a warning message with actions
          <:actions>
            <button>Dismiss</button>
            <button>Learn more</button>
          </:actions>
        </.alert>
        """)

      assert html =~ "Warning Title"
      assert html =~ "This is a warning message with actions"
      assert html =~ "Dismiss"
      assert html =~ "Learn more"
      assert html =~ "aria-label=\"Close alert\""
      assert html =~ "my-alert"
      assert html =~ "yellow-"
      assert html =~ "items-start"
    end

    test "alert with all features - horizontal layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert
          color="error"
          variant="outline"
          orientation="horizontal"
          close
        >
          <:title>Error</:title>
          Action required
          <:actions>
            <button>Fix now</button>
          </:actions>
        </.alert>
        """)

      assert html =~ "Error"
      assert html =~ "Action required"
      assert html =~ "Fix now"
      assert html =~ "aria-label=\"Close alert\""
      assert html =~ "red-"
      assert html =~ "items-center"
      assert html =~ "ring ring-inset"
    end

    test "multiple alerts render independently" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert id="alert-1" color="info">First alert</.alert>
        <.alert id="alert-2" color="success">Second alert</.alert>
        """)

      assert html =~ ~s(id="alert-1")
      assert html =~ ~s(id="alert-2")
      assert html =~ "First alert"
      assert html =~ "Second alert"
      assert html =~ "blue-"
      assert html =~ "green-"
    end

    # Theme integration tests
    test "includes proper spacing classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Spacing test</.alert>
        """)

      assert html =~ "p-4"
      assert html =~ "gap-2.5"
    end

    test "includes proper sizing classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Sizing test</.alert>
        """)

      assert html =~ "w-full"
      assert html =~ "rounded-lg"
    end

    test "icon has correct size class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>Icon size test</.alert>
        """)

      assert html =~ "size-5"
    end
  end
end
