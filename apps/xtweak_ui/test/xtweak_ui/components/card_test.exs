defmodule XTweakUI.Components.CardTest do
  use ExUnit.Case, async: true
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest
  import XTweakUI.Components.Card

  describe "card/1" do
    # Basic rendering tests
    test "renders empty card" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card />
        """)

      assert html =~ "rounded-lg"
      assert html =~ "overflow-hidden"
    end

    test "renders card with only body content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <p>Body content</p>
        </.card>
        """)

      assert html =~ "Body content"
    end

    test "renders card with only header" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>
            <h3>Card Title</h3>
          </:header>
        </.card>
        """)

      assert html =~ "Card Title"
    end

    test "renders card with only footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:footer>
            <button>Action</button>
          </:footer>
        </.card>
        """)

      assert html =~ "Action"
    end

    test "renders card with header and body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Header</:header>
          Body content
        </.card>
        """)

      assert html =~ "Header"
      assert html =~ "Body content"
    end

    test "renders card with body and footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          Body content
          <:footer>Footer</:footer>
        </.card>
        """)

      assert html =~ "Body content"
      assert html =~ "Footer"
    end

    test "renders full card with header, body, and footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>
            <h3>Title</h3>
          </:header>
          <p>Main content</p>
          <:footer>
            <button>Save</button>
          </:footer>
        </.card>
        """)

      assert html =~ "Title"
      assert html =~ "Main content"
      assert html =~ "Save"
    end

    test "renders card with header only, no body or footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Only Header</:header>
        </.card>
        """)

      assert html =~ "Only Header"
    end

    # Variant tests
    test "applies default outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>Content</.card>
        """)

      assert html =~ "ring-1"
      assert html =~ "ring-gray-200"
      assert html =~ "divide-y"
    end

    test "applies solid variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="solid">
          Content
        </.card>
        """)

      assert html =~ "bg-gray-900"
      assert html =~ "text-white"
    end

    test "applies soft variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="soft">
          Content
        </.card>
        """)

      assert html =~ "bg-gray-50/50"
      assert html =~ "divide-y"
    end

    test "applies subtle variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="subtle">
          Content
        </.card>
        """)

      assert html =~ "bg-gray-50/50"
      assert html =~ "ring-1"
      assert html =~ "divide-y"
    end

    test "handles invalid variant gracefully (defaults to outline)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="invalid">
          Content
        </.card>
        """)

      assert html =~ "ring-1"
      assert html =~ "ring-gray-200"
    end

    # Padding tests
    test "applies default md padding" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          Content
        </.card>
        """)

      assert html =~ "p-4"
      assert html =~ "sm:px-6"
    end

    test "applies none padding (no padding)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card padding="none">
          <img src="/test.jpg" alt="test" />
        </.card>
        """)

      refute html =~ ~r/p-\d/
      assert html =~ "test.jpg"
    end

    test "applies sm padding" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card padding="sm">
          Content
        </.card>
        """)

      assert html =~ "p-3"
      assert html =~ "sm:px-4"
    end

    test "applies lg padding" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card padding="lg">
          Content
        </.card>
        """)

      assert html =~ "p-6"
      assert html =~ "sm:px-8"
    end

    test "handles invalid padding gracefully (defaults to md)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card padding="invalid">
          Content
        </.card>
        """)

      assert html =~ "p-4"
      assert html =~ "sm:px-6"
    end

    # Custom attributes tests
    test "accepts custom CSS classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card class="my-custom-class">
          Content
        </.card>
        """)

      assert html =~ "my-custom-class"
    end

    test "passes through global attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card id="card-1" data-testid="test-card">
          Content
        </.card>
        """)

      assert html =~ ~s(id="card-1")
      assert html =~ ~s(data-testid="test-card")
    end

    # Structure tests
    test "includes base theme classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>Content</.card>
        """)

      assert html =~ "rounded-lg"
      assert html =~ "overflow-hidden"
    end

    test "header section renders before body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Header</:header>
          Body
        </.card>
        """)

      header_pos = html |> String.split("Header") |> List.first() |> String.length()
      body_pos = html |> String.split("Body") |> List.first() |> String.length()

      assert header_pos < body_pos
    end

    test "footer section renders after body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          Body
          <:footer>Footer</:footer>
        </.card>
        """)

      body_pos = html |> String.split("Body") |> List.first() |> String.length()
      footer_pos = html |> String.split("Footer") |> List.first() |> String.length()

      assert body_pos < footer_pos
    end

    test "all three sections render in correct order" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Header</:header>
          Body
          <:footer>Footer</:footer>
        </.card>
        """)

      header_pos = html |> String.split("Header") |> List.first() |> String.length()
      body_pos = html |> String.split("Body") |> List.first() |> String.length()
      footer_pos = html |> String.split("Footer") |> List.first() |> String.length()

      assert header_pos < body_pos
      assert body_pos < footer_pos
    end

    # Complex examples
    test "card with complex header content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>
            <div class="flex justify-between items-center">
              <h3>Title</h3>
              <button>Close</button>
            </div>
          </:header>
          Content
        </.card>
        """)

      assert html =~ "flex"
      assert html =~ "justify-between"
      assert html =~ "Title"
      assert html =~ "Close"
    end

    test "card with complex footer content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          Content
          <:footer>
            <div class="flex gap-2">
              <button>Cancel</button>
              <button>Save</button>
            </div>
          </:footer>
        </.card>
        """)

      assert html =~ "flex"
      assert html =~ "gap-2"
      assert html =~ "Cancel"
      assert html =~ "Save"
    end

    test "card with form in body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Edit Profile</:header>
          <form>
            <input type="text" name="name" />
          </form>
          <:footer>
            <button type="submit">Save</button>
          </:footer>
        </.card>
        """)

      assert html =~ "Edit Profile"
      assert html =~ "form"
      assert html =~ "input"
      assert html =~ "Save"
    end

    test "card with list in body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <:header>Items</:header>
          <ul>
            <li>Item 1</li>
            <li>Item 2</li>
          </ul>
        </.card>
        """)

      assert html =~ "Items"
      assert html =~ "Item 1"
      assert html =~ "Item 2"
    end

    test "card with image and no padding" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card padding="none">
          <:header>
            <img src="/header.jpg" alt="Header" class="w-full" />
          </:header>
          <div class="p-4">
            <p>Content with custom padding</p>
          </div>
        </.card>
        """)

      assert html =~ "header.jpg"
      assert html =~ "Content with custom padding"
    end

    # Dark mode tests
    test "solid variant has dark mode classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="solid">Content</.card>
        """)

      assert html =~ "dark:bg-gray-100"
      assert html =~ "dark:text-gray-900"
    end

    test "outline variant has dark mode ring classes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="outline">Content</.card>
        """)

      assert html =~ "dark:bg-gray-900"
      assert html =~ "dark:ring-gray-800"
      assert html =~ "dark:divide-gray-800"
    end

    test "soft variant has dark mode background" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="soft">Content</.card>
        """)

      assert html =~ "dark:bg-gray-900/50"
      assert html =~ "dark:divide-gray-800"
    end

    # Edge cases
    test "card with only whitespace in body" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>

        </.card>
        """)

      assert html =~ "rounded-lg"
    end

    test "multiple cards render independently" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card id="card-1">Content 1</.card>
        <.card id="card-2">Content 2</.card>
        """)

      assert html =~ ~s(id="card-1")
      assert html =~ ~s(id="card-2")
      assert html =~ "Content 1"
      assert html =~ "Content 2"
    end

    test "card with mixed variant and padding options" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card variant="soft" padding="lg">
          <:header>Large padding soft card</:header>
          Content
        </.card>
        """)

      assert html =~ "bg-gray-50/50"
      assert html =~ "p-6"
      assert html =~ "sm:px-8"
    end
  end
end
