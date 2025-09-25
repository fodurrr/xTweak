defmodule XTweakDocsTest do
  use ExUnit.Case
  doctest XTweakDocs

  test "version returns the current version" do
    assert XTweakDocs.version() == "0.1.0"
  end

  test "render_markdown converts markdown to HTML" do
    markdown = "# Hello World"
    html = XTweakDocs.render_markdown(markdown)
    assert html =~ "<h1>"
    assert html =~ "Hello World"
  end
end
