#!/usr/bin/env elixir

defmodule ProjectRenamer do
  @moduledoc """
  Standalone script to rename xTweak template project to a new name.

  This script performs find-and-replace operations on all project files
  and renames directories to match your new project name.

  ## Usage

      # Interactive mode (prompts for project name)
      elixir scripts/rename_project.exs

      # Specify project name
      elixir scripts/rename_project.exs --to MyProject

      # Preview changes without applying
      elixir scripts/rename_project.exs --to MyProject --dry-run

      # Automated mode (no prompts)
      elixir scripts/rename_project.exs --to MyProject --yes

      # Custom app prefix
      elixir scripts/rename_project.exs --to MyProject --prefix my_proj

      # From custom source (if already renamed once)
      elixir scripts/rename_project.exs --from OldName --to NewName

  ## Options

    * `--to` - Target project name (PascalCase, e.g., MyProject)
    * `--from` - Source project name (default: XTweak)
    * `--prefix` - Custom app atom prefix (default: snake_case of --to)
    * `--from-prefix` - Source app prefix (default: xtweak)
    * `--dry-run` - Show planned changes without applying
    * `--yes` - Skip confirmation prompts
    * `--skip-docs` - Don't update documentation files
    * `--help` - Show this help message

  ## What Gets Renamed

    1. Module names: `XTweak.*` → `YourProject.*`
    2. App atoms: `:xtweak_core` → `:yourproject_core`
    3. Directories: `apps/xtweak_*` → `apps/yourproject_*`
    4. Database names: `xtweak_dev` → `yourproject_dev`
    5. Config files: All app and database references
    6. Frontend configs: package.json, tailwind.config.js
    7. Documentation: README and markdown files (unless --skip-docs)

  ## Safety Features

    * Validates git working directory is clean
    * Validates project names (PascalCase, no underscores)
    * Dry-run mode to preview changes
    * Idempotent (safe to run multiple times)
    * Clear error messages

  ## After Running

      mix deps.get
      mix compile
      mix test

      # Create new databases
      MIX_ENV=dev mix ash_postgres.create
      MIX_ENV=dev mix ash_postgres.migrate
      MIX_ENV=test mix ash_postgres.create

  """

  @default_from "XTweak"
  @default_from_prefix "xtweak"

  def main(args) do
    case parse_args(args) do
      {:ok, config} ->
        run_rename(config)

      {:error, :help} ->
        print_help()
        System.halt(0)

      {:error, message} ->
        print_error(message)
        System.halt(1)
    end
  end

  # ============================================================================
  # CLI Argument Parsing
  # ============================================================================

  defp parse_args(args) do
    {parsed, _remaining, invalid} =
      OptionParser.parse(args,
        strict: [
          to: :string,
          from: :string,
          prefix: :string,
          from_prefix: :string,
          dry_run: :boolean,
          yes: :boolean,
          skip_docs: :boolean,
          help: :boolean
        ],
        aliases: [
          t: :to,
          f: :from,
          p: :prefix,
          d: :dry_run,
          y: :yes,
          h: :help
        ]
      )

    cond do
      parsed[:help] ->
        {:error, :help}

      invalid != [] ->
        {:error, "Invalid options: #{inspect(invalid)}"}

      true ->
        build_config(parsed)
    end
  end

  defp build_config(parsed) do
    with {:ok, to_name} <- get_target_name(parsed),
         {:ok, from_name} <- get_source_name(parsed),
         :ok <- validate_project_name(to_name),
         :ok <- validate_project_name(from_name),
         {:ok, config} <- build_full_config(from_name, to_name, parsed) do
      {:ok, config}
    end
  end

  defp get_target_name(parsed) do
    case parsed[:to] do
      nil ->
        IO.puts("\n📝 xTweak Project Renamer\n")
        to_name = IO.gets("Enter new project name (PascalCase, e.g., MyProject): ") |> String.trim()

        if to_name == "" do
          {:error, "Project name cannot be empty"}
        else
          {:ok, to_name}
        end

      to_name ->
        {:ok, to_name}
    end
  end

  defp get_source_name(parsed) do
    {:ok, parsed[:from] || @default_from}
  end

  defp build_full_config(from_name, to_name, parsed) do
    from_prefix = parsed[:from_prefix] || @default_from_prefix
    to_prefix = parsed[:prefix] || to_snake_case(to_name)

    case validate_app_prefix(to_prefix) do
      :ok ->
        {:ok,
         %{
           from_module: from_name,
           to_module: to_name,
           from_prefix: from_prefix,
           to_prefix: to_prefix,
           dry_run: parsed[:dry_run] || false,
           yes: parsed[:yes] || false,
           skip_docs: parsed[:skip_docs] || false
         }}

      error ->
        error
    end
  end

  # ============================================================================
  # Validation
  # ============================================================================

  defp validate_project_name(name) do
    cond do
      not Regex.match?(~r/^[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*$/, name) ->
        {:error, "Project name must be PascalCase (e.g., MyProject or My.Project)"}

      String.contains?(name, "_") ->
        {:error, "Project name should not contain underscores"}

      true ->
        :ok
    end
  end

  defp validate_app_prefix(prefix) do
    cond do
      not Regex.match?(~r/^[a-z][a-z0-9_]*$/, prefix) ->
        {:error, "App prefix must be snake_case (e.g., my_project)"}

      String.starts_with?(prefix, "_") or String.ends_with?(prefix, "_") ->
        {:error, "App prefix cannot start or end with underscore"}

      true ->
        :ok
    end
  end

  defp check_git_status do
    case System.cmd("git", ["status", "--porcelain"], stderr_to_stdout: true) do
      {"", 0} ->
        :ok

      {output, 0} when output != "" ->
        {:error, "Git working directory is not clean. Please commit or stash changes first."}

      _ ->
        # Git not available or not a git repo - warn but allow
        IO.puts("⚠️  Warning: Not a git repository or git not available")
        :ok
    end
  end

  # ============================================================================
  # Main Rename Logic
  # ============================================================================

  defp run_rename(config) do
    IO.puts("\n📋 xTweak Project Renamer\n")
    IO.puts("🔍 Validating...\n")

    with :ok <- check_git_status(),
         :ok <- validate_target_not_exists(config) do
      print_summary(config)

      if should_proceed?(config) do
        perform_rename(config)
      else
        IO.puts("\n❌ Rename cancelled.")
      end
    else
      {:error, message} ->
        print_error(message)
        System.halt(1)
    end
  end

  defp validate_target_not_exists(config) do
    target_dir = "apps/#{config.to_prefix}_core"

    if config.from_prefix != config.to_prefix and File.exists?(target_dir) do
      {:error, "Target directory already exists: #{target_dir}\nPlease remove it first."}
    else
      :ok
    end
  end

  defp should_proceed?(config) do
    if config.dry_run do
      IO.puts("\n🔍 DRY RUN MODE - No changes will be applied")
      false
    else
      IO.puts("\n⚠️  This will modify your files.")

      if config.yes do
        IO.puts("✅ Proceeding (--yes flag provided)")
        true
      else
        answer = IO.gets("\nContinue with rename? [y/N] ") |> String.trim() |> String.downcase()
        answer in ["y", "yes"]
      end
    end
  end

  defp perform_rename(config) do
    IO.puts("\n🔄 Applying transformations...")

    steps = [
      {"Renaming module names", fn -> replace_content(config) end},
      {"Updating frontend configs", fn -> update_frontend_configs(config) end},
      {"Renaming directories", fn -> rename_directories(config) end}
    ]

    Enum.each(steps, fn {label, fun} ->
      IO.puts("  → #{label}...")
      fun.()
    end)

    print_next_steps(config)
  end

  # ============================================================================
  # Content Replacement
  # ============================================================================

  defp replace_content(config) do
    %{
      from_module: from_pascal,
      to_module: to_pascal,
      from_prefix: from_snake,
      to_prefix: to_snake
    } = config

    # Order matters! Replace most specific patterns first
    replacements = build_replacement_list(from_pascal, to_pascal, from_snake, to_snake, config)

    file_patterns = [
      "mix.exs",
      "apps/*/mix.exs",
      "config/**/*.exs",
      "apps/**/lib/**/*.ex",
      "apps/**/lib/**/*.exs",
      "apps/**/test/**/*.exs",
      "apps/**/test/**/*.ex"
    ]

    # Add docs if not skipped
    file_patterns =
      if config.skip_docs do
        file_patterns
      else
        file_patterns ++ ["README.md", "apps/*/README.md", "docs/**/*.md", ".claude/**/*.md"]
      end

    files = collect_files(file_patterns)

    Enum.each(files, fn file ->
      apply_replacements(file, replacements)
    end)
  end

  defp build_replacement_list(from_pascal, to_pascal, from_snake, to_snake, _config) do
    [
      # 1. Concatenated app modules (most specific first)
      {"#{from_pascal}Core", "#{to_pascal}Core"},
      {"#{from_pascal}Web", "#{to_pascal}Web"},
      {"#{from_pascal}UI", "#{to_pascal}UI"},
      {"#{from_pascal}Docs", "#{to_pascal}Docs"},
      # 2. Web namespace (Phoenix convention)
      {"#{from_pascal}WebWeb", "#{to_pascal}WebWeb"},
      # 3. Domain modules with dot
      {"#{from_pascal}.Core", "#{to_pascal}.Core"},
      {"#{from_pascal}.Repo", "#{to_pascal}.Repo"},
      {"#{from_pascal}.Application", "#{to_pascal}.Application"},
      # 4. General pattern for any XTweak.* modules
      {"#{from_pascal}.", "#{to_pascal}."},
      # 5. Base module name (after more specific ones)
      {from_pascal, to_pascal},
      # 6. App atoms (most specific first)
      {":#{from_snake}_core", ":#{to_snake}_core"},
      {":#{from_snake}_web", ":#{to_snake}_web"},
      {":#{from_snake}_ui", ":#{to_snake}_ui"},
      {":#{from_snake}_docs", ":#{to_snake}_docs"},
      {":#{from_snake}", ":#{to_snake}"},
      # 7. Database names (in quoted strings)
      {"\"#{from_snake}_dev\"", "\"#{to_snake}_dev\""},
      {"\"#{from_snake}_test\"", "\"#{to_snake}_test\""},
      {"\"#{from_snake}_prod\"", "\"#{to_snake}_prod\""},
      # 8. Release names
      {"releases: [\n    #{from_snake}:", "releases: [\n    #{to_snake}:"},
      # 9. Snake_case paths (for lib directories, package names, etc.)
      {"#{from_snake}_web_web", "#{to_snake}_web_web"},
      {"#{from_snake}_core", "#{to_snake}_core"},
      {"#{from_snake}_web", "#{to_snake}_web"},
      {"#{from_snake}_ui", "#{to_snake}_ui"},
      {"#{from_snake}_docs", "#{to_snake}_docs"},
      # 10. Session/cookie keys
      {"_#{from_snake}_web_key", "_#{to_snake}_web_key"},
      # 11. Slash paths
      {"/#{from_snake}_", "/#{to_snake}_"},
      {"\"../lib/#{from_snake}_", "\"../lib/#{to_snake}_"}
    ]
  end

  defp collect_files(patterns) do
    patterns
    |> Enum.flat_map(&Path.wildcard/1)
    |> Enum.uniq()
    |> Enum.filter(&File.regular?/1)
  end

  defp apply_replacements(file, replacements) do
    content = File.read!(file)
    new_content = Enum.reduce(replacements, content, fn {from, to}, acc ->
      String.replace(acc, from, to)
    end)

    if content != new_content do
      File.write!(file, new_content)
    end
  end

  # ============================================================================
  # Frontend Config Updates
  # ============================================================================

  defp update_frontend_configs(config) do
    %{from_prefix: from_prefix, to_prefix: to_prefix} = config

    # Update package.json
    package_json = "apps/#{from_prefix}_web/assets/package.json"

    if File.exists?(package_json) do
      content = File.read!(package_json)
      new_content = String.replace(content, from_prefix, to_prefix)
      File.write!(package_json, new_content)
    end

    # Update tailwind.config.js
    tailwind_config = "apps/#{from_prefix}_web/assets/tailwind.config.js"

    if File.exists?(tailwind_config) do
      content = File.read!(tailwind_config)

      new_content =
        content
        |> String.replace("../lib/#{from_prefix}_web_web", "../lib/#{to_prefix}_web_web")
        |> String.replace("../lib/#{from_prefix}_web/", "../lib/#{to_prefix}_web/")

      File.write!(tailwind_config, new_content)
    end
  end

  # ============================================================================
  # Directory Renaming
  # ============================================================================

  defp rename_directories(config) do
    %{from_prefix: from_prefix, to_prefix: to_prefix} = config

    if from_prefix == to_prefix do
      # No directory renaming needed
      :ok
    else
      apps = ["core", "web", "ui", "docs"]

      Enum.each(apps, fn app ->
        rename_app_directory(app, from_prefix, to_prefix)
      end)
    end
  end

  defp rename_app_directory(app, from_prefix, to_prefix) do
    old_path = "apps/#{from_prefix}_#{app}"
    new_path = "apps/#{to_prefix}_#{app}"

    if File.exists?(old_path) do
      IO.puts("    #{old_path} → #{new_path}")
      File.rename!(old_path, new_path)

      # Rename internal lib directory
      old_lib = "#{new_path}/lib/#{from_prefix}_#{app}"
      new_lib = "#{new_path}/lib/#{to_prefix}_#{app}"

      if File.exists?(old_lib) do
        File.rename!(old_lib, new_lib)
      end

      # Rename web namespace directory if exists (e.g., lib/xtweak_web_web)
      old_web_lib = "#{new_path}/lib/#{from_prefix}_#{app}_#{app}"
      new_web_lib = "#{new_path}/lib/#{to_prefix}_#{app}_#{app}"

      if File.exists?(old_web_lib) do
        File.rename!(old_web_lib, new_web_lib)
      end
    end
  end

  # ============================================================================
  # Output & Formatting
  # ============================================================================

  defp print_summary(config) do
    %{
      from_module: from_pascal,
      to_module: to_pascal,
      from_prefix: from_snake,
      to_prefix: to_snake
    } = config

    IO.puts("""
    📋 Planned Transformations:

    Module Names:
      #{from_pascal}         → #{to_pascal}
      #{from_pascal}Core     → #{to_pascal}Core
      #{from_pascal}Web      → #{to_pascal}Web
      #{from_pascal}WebWeb   → #{to_pascal}WebWeb
      #{from_pascal}.Core    → #{to_pascal}.Core
      (and all submodules)

    App Atoms:
      :#{from_snake}_core   → :#{to_snake}_core
      :#{from_snake}_web    → :#{to_snake}_web
      :#{from_snake}_ui     → :#{to_snake}_ui
      :#{from_snake}_docs   → :#{to_snake}_docs

    Directories:
      apps/#{from_snake}_core → apps/#{to_snake}_core
      apps/#{from_snake}_web  → apps/#{to_snake}_web
      apps/#{from_snake}_ui   → apps/#{to_snake}_ui
      apps/#{from_snake}_docs → apps/#{to_snake}_docs

    Database Names:
      #{from_snake}_dev     → #{to_snake}_dev
      #{from_snake}_test    → #{to_snake}_test
      #{from_snake}_prod    → #{to_snake}_prod

    Frontend:
      package.json name
      tailwind.config.js paths
    #{if config.skip_docs, do: "\n    Documentation: Skipped", else: "\n    Documentation: Will update README and markdown files"}
    """)
  end

  defp print_next_steps(config) do
    IO.puts("""

    ✅ Rename complete!

    📋 Next Steps:

    1. Update dependencies:
       mix deps.get

    2. Clean and recompile:
       mix clean
       mix compile

    3. Run tests:
       mix test

    4. Create new databases:
       MIX_ENV=dev mix ash_postgres.create
       MIX_ENV=dev mix ash_postgres.migrate
       MIX_ENV=test mix ash_postgres.create
       MIX_ENV=test mix ash_postgres.migrate

    5. (Optional) Drop old databases:
       MIX_ENV=dev mix ash_postgres.drop

    6. Commit changes:
       git add -A
       git commit -m "Rename project from #{config.from_module} to #{config.to_module}"

    Happy coding with your new project! 🎉
    """)
  end

  defp print_error(message) do
    IO.puts("\n❌ Error: #{message}\n")
    IO.puts("Run with --help for usage information.")
  end

  defp print_help do
    IO.puts(@moduledoc)
  end

  # ============================================================================
  # Utility Functions
  # ============================================================================

  defp to_snake_case(name) do
    name
    |> String.replace(".", "")
    |> Macro.underscore()
  end
end

# Run the script
ProjectRenamer.main(System.argv())
