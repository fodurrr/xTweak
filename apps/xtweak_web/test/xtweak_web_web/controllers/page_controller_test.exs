defmodule XTweakWebWeb.PageControllerTest do
  use XTweakWebWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "xTweak"
  end

  test "GET /weather", %{conn: conn} do
    conn = get(conn, ~p"/weather")
    assert html_response(conn, 200) =~ "Weather Dashboard"
  end
end
