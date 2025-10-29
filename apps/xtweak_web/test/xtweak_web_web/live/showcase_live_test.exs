defmodule XTweakWebWeb.ShowcaseLiveTest do
  use XTweakWebWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders showcase page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/showcase")

    assert html =~ "xTweak UI"
    assert html =~ "Button"
    assert has_element?(view, "button", "Solid")
  end

  test "displays all button variants", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/showcase")

    assert html =~ "Solid"
    assert html =~ "Outline"
    assert html =~ "Soft"
    assert html =~ "Ghost"
    assert html =~ "Link"
  end

  test "displays all button sizes", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/showcase")

    assert html =~ "Extra Small"
    assert html =~ "Small"
    assert html =~ "Medium"
    assert html =~ "Large"
    assert html =~ "Extra Large"
  end

  test "displays all button colors", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/showcase")

    assert html =~ "Primary"
    assert html =~ "Secondary"
    assert html =~ "Success"
    assert html =~ "Warning"
    assert html =~ "Error"
    assert html =~ "Neutral"
  end

  test "displays button states", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/showcase")

    assert html =~ "Normal"
    assert html =~ "Loading"
    assert html =~ "Disabled"
  end

  test "toggles theme", %{conn: conn} do
    {:ok, view, html} = live(conn, "/showcase")

    # Check initial theme (button shows "Dark" option)
    assert html =~ "🌙 Dark"

    # Toggle theme
    html = view |> element("button", "🌙 Dark") |> render_click()

    # Check new theme (button now shows "Light" option)
    assert html =~ "☀️ Light"
  end

  test "theme switcher changes text", %{conn: conn} do
    {:ok, view, html} = live(conn, "/showcase")

    # Initial state shows Dark option
    assert html =~ "🌙 Dark"

    # Click to toggle to dark
    html = view |> element("button", "🌙 Dark") |> render_click()

    # Now shows Light option
    assert html =~ "☀️ Light"
  end

  test "displays code examples", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/showcase")

    assert html =~ "Code Example"
    assert html =~ "&lt;.button"
  end
end
