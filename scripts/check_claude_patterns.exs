#!/usr/bin/env elixir

defmodule ClaudePatternCheck do
  @agent_dir ".claude/agents/*.md"
  @pattern_dir ".claude/patterns/*.md"
  @core_patterns ~w(placeholder-basics phase-zero-context mcp-tool-discipline self-check-core dual-example-bridge)

  def run do
    pattern_names = load_patterns()

    results =
      @agent_dir
      |> Path.wildcard()
      |> Enum.map(&check_agent(&1, pattern_names))

    report(results)
  end

  defp load_patterns do
    @pattern_dir
    |> Path.wildcard()
    |> Enum.map(fn path ->
      path
      |> Path.basename()
      |> Path.rootname()
    end)
    |> MapSet.new()
  end

  defp check_agent(path, pattern_names) do
    {:ok, contents} = File.read(path)

    front_matter =
      case Regex.run(~r/^---\n(?<fm>.*?\n)---\n/s, contents, capture: :all_but_first) do
        [fm] -> fm
        _ -> ""
      end

    version? = String.contains?(front_matter, "\nversion:")
    updated? = String.contains?(front_matter, "\nupdated:")

    patterns = extract_pattern_stack(front_matter)

    parsed_patterns =
      patterns
      |> Enum.map(&String.split(&1, "@") |> List.first())

    missing_core = @core_patterns -- parsed_patterns

    unknown_patterns =
      parsed_patterns
      |> Enum.reject(&MapSet.member?(pattern_names, &1))

    %{
      path: path,
      has_version?: version?,
      has_updated?: updated?,
      has_pattern_stack?: patterns != [],
      missing_core: missing_core,
      unknown_patterns: unknown_patterns
    }
  end

  defp report(results) do
    Enum.each(results, fn result ->
      issues =
        []
        |> push_issue(not result.has_version?, "missing version")
        |> push_issue(not result.has_updated?, "missing updated date")
        |> push_issue(not result.has_pattern_stack?, "missing pattern-stack")
        |> push_issue(Enum.any?(result.missing_core), "missing core patterns: #{Enum.join(result.missing_core, ", ")}")
        |> push_issue(Enum.any?(result.unknown_patterns), "unknown patterns: #{Enum.join(result.unknown_patterns, ", ")}")

      unless issues == [] do
        IO.puts("[WARN] #{result.path}")
        Enum.each(issues, &IO.puts("       • #{&1}"))
      end
    end)

    IO.puts("Check complete.")
  end

  defp push_issue(list, condition, message) do
    if condition, do: [message | list], else: list
  end

  defp extract_pattern_stack(front_matter) do
    front_matter
    |> String.split("\n")
    |> Enum.reduce({[], false}, fn line, {acc, in_stack?} ->
      cond do
        String.starts_with?(line, "pattern-stack:") ->
          {acc, true}

        in_stack? and String.match?(line, ~r/^\s*-/) ->
          entry =
            line
            |> String.trim_leading()
            |> String.trim_leading("- ")
            |> String.trim()

          {[entry | acc], true}

        in_stack? and String.trim(line) == "" ->
          {acc, true}

        in_stack? ->
          {acc, false}

        true ->
          {acc, false}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end
end

ClaudePatternCheck.run()
