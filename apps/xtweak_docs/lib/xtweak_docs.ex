defmodule XTweakDocs do
  @moduledoc """
  Documentation module for the xTweak template project.

  This module provides utilities for parsing and rendering
  documentation from markdown files.
  """

  @doc """
  Returns the version of the documentation app.
  """
  def version do
    "0.1.0"
  end

  @doc """
  Renders markdown content to HTML.
  """
  def render_markdown(content) when is_binary(content) do
    content
    |> Earmark.as_html!()
  end

  @doc """
  Lists all documentation files in the given directory.
  """
  def list_docs(path \\ "docs") do
    Path.wildcard("#{path}/**/*.md")
    |> Enum.map(&Path.relative_to(&1, path))
    |> Enum.sort()
  end

  @doc """
  Reads and renders a documentation file.
  """
  def read_doc(file_path) do
    case File.read(file_path) do
      {:ok, content} -> {:ok, render_markdown(content)}
      error -> error
    end
  end
end
