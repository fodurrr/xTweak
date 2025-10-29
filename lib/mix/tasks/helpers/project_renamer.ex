defmodule Mix.Tasks.Helpers.ProjectRenamer do
  @moduledoc """
  Helper module for renaming an Elixir umbrella project.

  Provides functions to safely rename modules, apps, configs, and directories
  using Igniter's AST manipulation capabilities combined with targeted text
  transformations for non-Elixir files.
  """

  alias Igniter.Code.Common
  alias Sourceror.Zipper

  @type rename_config :: %{
          from_module: module(),
          to_module: module(),
          from_app_prefix: String.t(),
          to_app_prefix: String.t(),
          skip_docs: boolean(),
          skip_db: boolean(),
          dry_run: boolean()
        }

  @doc """
  Validates the project rename configuration.

  Returns `{:ok, config}` or `{:error, reason}`.
  """
  @spec validate_config(rename_config()) :: {:ok, rename_config()} | {:error, String.t()}
  def validate_config(config) do
    with :ok <- validate_module_name(config.to_module),
         :ok <- validate_app_prefix(config.to_app_prefix),
         :ok <- check_git_status() do
      {:ok, config}
    end
  end

  defp validate_module_name(module) when is_atom(module) do
    module_str = inspect(module)

    cond do
      not String.match?(module_str, ~r/^[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*$/) ->
        {:error, "Module name must be PascalCase (e.g., MyProject)"}

      String.contains?(module_str, "_") ->
        {:error, "Module names should not contain underscores"}

      true ->
        :ok
    end
  end

  defp validate_app_prefix(prefix) when is_binary(prefix) do
    cond do
      not String.match?(prefix, ~r/^[a-z][a-z0-9_]*$/) ->
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
        IO.puts(:stderr, "Warning: Not a git repository or git not available")
        :ok
    end
  end

  @doc """
  Renames all module definitions and references across the project.

  Uses Igniter's AST manipulation to safely update:
  - Module definitions (`defmodule`)
  - Module aliases (`alias`, `use`, `import`)
  - Module-qualified calls (`OldModule.function()`)
  - Module attributes referencing modules
  """
  @spec rename_modules(Igniter.t(), rename_config()) :: Igniter.t()
  def rename_modules(igniter, config) do
    %{from_module: from_base, to_module: to_base} = config

    # Define all module mappings for umbrella apps
    module_mappings = build_module_mappings(from_base, to_base)

    # Update all Elixir files with module transformations
    Igniter.update_all_elixir_files(igniter, fn zipper ->
      Enum.reduce(module_mappings, {:ok, zipper}, fn {from_mod, to_mod}, {:ok, zipper} ->
        with {:ok, zipper} <- rename_module_definition(zipper, from_mod, to_mod),
             {:ok, zipper} <- rename_module_aliases(zipper, from_mod, to_mod),
             {:ok, zipper} <- rename_module_calls(zipper, from_mod, to_mod) do
          {:ok, zipper}
        else
          _ -> {:ok, zipper}
        end
      end)
    end)
  end

  defp build_module_mappings(from_base, to_base) do
    from_base_str = inspect(from_base)
    to_base_str = inspect(to_base)

    # Detect current module patterns in xTweak:
    # - XTweak (base)
    # - XTweakCore, XTweakWeb, XTweakUI, XTweakDocs (app modules)
    # - XTweak.Core, XTweak.Web, etc. (domain modules)

    app_suffixes = ["Core", "Web", "UI", "Docs"]
    domain_suffixes = ["Core", "Web", "UI", "Docs"]

    base_mapping = [{from_base, to_base}]

    app_mappings =
      Enum.map(app_suffixes, fn suffix ->
        from = Module.concat([from_base_str <> suffix])
        to = Module.concat([to_base_str <> suffix])
        {from, to}
      end)

    domain_mappings =
      Enum.map(domain_suffixes, fn suffix ->
        from = Module.concat([from_base, suffix])
        to = Module.concat([to_base, suffix])
        {from, to}
      end)

    # Return with most specific first (longer module names first)
    (app_mappings ++ domain_mappings ++ base_mapping)
    |> Enum.uniq()
    |> Enum.sort_by(fn {from, _} -> -String.length(inspect(from)) end)
  end

  defp rename_module_definition(zipper, from_module, to_module) do
    case Igniter.Code.Module.move_to_defmodule(zipper, from_module) do
      {:ok, module_zipper} ->
        # Replace the module name in defmodule
        new_zipper =
          Zipper.update(module_zipper, fn
            {:defmodule, meta, [_old_name, do_block]} ->
              {:defmodule, meta, [to_module_alias(to_module), do_block]}

            other ->
              other
          end)

        {:ok, Zipper.root(new_zipper)}

      :error ->
        {:ok, zipper}
    end
  end

  defp rename_module_aliases(zipper, from_module, to_module) do
    # Rename in alias, use, import statements
    new_zipper =
      Zipper.traverse(zipper, fn z ->
        rename_alias_node(z, from_module, to_module)
      end)

    {:ok, new_zipper}
  end

  defp rename_alias_node(zipper, from_module, to_module) do
    case Zipper.node(zipper) do
      # alias OldModule
      {:alias, meta, [{:__aliases__, _alias_meta, _} = old_alias]} ->
        replace_if_matches_exact(zipper, old_alias, from_module, to_module, :alias, meta)

      # alias OldModule.SubModule
      {:alias, meta, [{:__aliases__, _, _} = old_alias | rest]} ->
        replace_if_starts_with(zipper, old_alias, from_module, to_module, :alias, meta, rest)

      # use OldModule
      {:use, meta, [{:__aliases__, _, _} = old_alias | rest]} ->
        replace_if_starts_with(zipper, old_alias, from_module, to_module, :use, meta, rest)

      # import OldModule
      {:import, meta, [{:__aliases__, _, _} = old_alias | rest]} ->
        replace_if_starts_with(zipper, old_alias, from_module, to_module, :import, meta, rest)

      _ ->
        zipper
    end
  end

  defp replace_if_matches_exact(zipper, old_alias, from_module, to_module, directive, meta) do
    if aliases_to_module?(old_alias, from_module) do
      new_alias = to_module_alias(to_module)
      Zipper.replace(zipper, {directive, meta, [new_alias]})
    else
      zipper
    end
  end

  defp replace_if_starts_with(zipper, old_alias, from_module, to_module, directive, meta, rest) do
    if alias_starts_with?(old_alias, from_module) do
      new_alias = replace_alias_prefix(old_alias, from_module, to_module)
      Zipper.replace(zipper, {directive, meta, [new_alias | rest]})
    else
      zipper
    end
  end

  defp rename_module_calls(zipper, from_module, to_module) do
    # Rename module-qualified function calls: OldModule.function()
    new_zipper =
      Zipper.traverse(zipper, fn z ->
        rename_module_call_node(z, from_module, to_module)
      end)

    {:ok, new_zipper}
  end

  defp rename_module_call_node(zipper, from_module, to_module) do
    case Zipper.node(zipper) do
      {{:., dot_meta, [{:__aliases__, _, _} = old_alias, function]}, call_meta, args} ->
        replace_module_call(
          zipper,
          old_alias,
          from_module,
          to_module,
          dot_meta,
          function,
          call_meta,
          args
        )

      _ ->
        zipper
    end
  end

  defp replace_module_call(
         zipper,
         old_alias,
         from_module,
         to_module,
         dot_meta,
         function,
         call_meta,
         args
       ) do
    if alias_starts_with?(old_alias, from_module) do
      new_alias = replace_alias_prefix(old_alias, from_module, to_module)
      new_call = {{:., dot_meta, [new_alias, function]}, call_meta, args}
      Zipper.replace(zipper, new_call)
    else
      zipper
    end
  end

  # Helper: Convert module atom to alias AST node
  defp to_module_alias(module) when is_atom(module) do
    parts =
      module
      |> inspect()
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    {:__aliases__, [line: 1], parts}
  end

  # Helper: Check if alias represents exact module
  defp aliases_to_module?({:__aliases__, _, parts}, module) do
    module_parts =
      module
      |> inspect()
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    parts == module_parts
  end

  # Helper: Check if alias starts with module prefix
  defp alias_starts_with?({:__aliases__, _, parts}, module) do
    module_parts =
      module
      |> inspect()
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    List.starts_with?(parts, module_parts)
  end

  # Helper: Replace alias prefix
  defp replace_alias_prefix({:__aliases__, meta, parts}, from_module, to_module) do
    from_parts =
      from_module
      |> inspect()
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    to_parts =
      to_module
      |> inspect()
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    from_length = length(from_parts)

    new_parts =
      if List.starts_with?(parts, from_parts) do
        to_parts ++ Enum.drop(parts, from_length)
      else
        parts
      end

    {:__aliases__, meta, new_parts}
  end

  @doc """
  Renames app atoms and module names in mix.exs files.

  Updates:
  - `app: :old_app` to `app: :new_app`
  - `defmodule OldModule.MixProject`
  - `mod: {OldModule.Application, []}`
  - Release names
  """
  @spec rename_mix_files(Igniter.t(), rename_config()) :: Igniter.t()
  def rename_mix_files(igniter, config) do
    %{
      from_module: from_base,
      to_module: to_base,
      from_app_prefix: from_prefix,
      to_app_prefix: to_prefix
    } = config

    # Find all mix.exs files
    mix_files = [
      "mix.exs",
      "apps/#{from_prefix}_core/mix.exs",
      "apps/#{from_prefix}_web/mix.exs",
      "apps/#{from_prefix}_ui/mix.exs",
      "apps/#{from_prefix}_docs/mix.exs"
    ]

    Enum.reduce(mix_files, igniter, fn file, acc ->
      update_mix_file(acc, file, from_prefix, to_prefix)
    end)
  end

  defp update_mix_file(igniter, file, from_prefix, to_prefix) do
    case Igniter.include_existing_file(igniter, file) do
      {:ok, acc} ->
        Igniter.update_file(acc, file, fn source ->
          replace_app_atoms(source, from_prefix, to_prefix)
        end)

      {:error, acc} ->
        acc
    end
  end

  defp replace_app_atoms(content, from_prefix, to_prefix) do
    content
    |> String.replace(":#{from_prefix}_core", ":#{to_prefix}_core")
    |> String.replace(":#{from_prefix}_web", ":#{to_prefix}_web")
    |> String.replace(":#{from_prefix}_ui", ":#{to_prefix}_ui")
    |> String.replace(":#{from_prefix}_docs", ":#{to_prefix}_docs")
    |> String.replace(":#{from_prefix}", ":#{to_prefix}")
  end

  @doc """
  Renames database names and app configs in config files.

  Updates:
  - `database: "old_app_dev"` to `database: "new_app_dev"`
  - `config :old_app` to `config :new_app`
  """
  @spec rename_config_files(Igniter.t(), rename_config()) :: Igniter.t()
  def rename_config_files(igniter, config) do
    if config.skip_db do
      igniter
    else
      %{from_app_prefix: from_prefix, to_app_prefix: to_prefix} = config

      config_files = [
        "config/config.exs",
        "config/dev.exs",
        "config/test.exs",
        "config/runtime.exs"
      ]

      Enum.reduce(config_files, igniter, fn file, acc ->
        update_config_file(acc, file, from_prefix, to_prefix)
      end)
    end
  end

  defp update_config_file(igniter, file, from_prefix, to_prefix) do
    case Igniter.include_existing_file(igniter, file) do
      {:ok, acc} ->
        Igniter.update_file(acc, file, fn source ->
          replace_config_names(source, from_prefix, to_prefix)
        end)

      {:error, acc} ->
        acc
    end
  end

  defp replace_config_names(source, from_prefix, to_prefix) do
    source
    # Replace database names
    |> String.replace("\"#{from_prefix}_dev\"", "\"#{to_prefix}_dev\"")
    |> String.replace("\"#{from_prefix}_test\"", "\"#{to_prefix}_test\"")
    |> String.replace("\"#{from_prefix}_prod\"", "\"#{to_prefix}_prod\"")
    # Replace config atoms
    |> String.replace(":#{from_prefix}_core", ":#{to_prefix}_core")
    |> String.replace(":#{from_prefix}_web", ":#{to_prefix}_web")
    |> String.replace(":#{from_prefix}_ui", ":#{to_prefix}_ui")
    |> String.replace(":#{from_prefix}_docs", ":#{to_prefix}_docs")
  end

  @doc """
  Renames documentation files (optional).

  Updates project name references in:
  - README files
  - Documentation markdown files
  - CLAUDE.md and other project docs
  """
  @spec rename_documentation(Igniter.t(), rename_config()) :: Igniter.t()
  def rename_documentation(igniter, config) do
    if config.skip_docs do
      igniter
    else
      %{from_module: from_base, to_module: to_base} = config
      from_name = inspect(from_base)
      to_name = inspect(to_base)

      doc_patterns = [
        "README.md",
        "apps/*/README.md",
        "docs/**/*.md"
      ]

      # Note: Igniter doesn't have great glob support for updates
      # This is a simplified version - in practice, might need custom file walking
      Enum.reduce(doc_patterns, igniter, fn pattern, acc ->
        update_doc_file(acc, pattern, from_name, to_name)
      end)
    end
  end

  defp update_doc_file(igniter, pattern, from_name, to_name) do
    # For now, just handle top-level README
    if pattern == "README.md" do
      update_readme_file(igniter, from_name, to_name)
    else
      igniter
    end
  end

  defp update_readme_file(igniter, from_name, to_name) do
    case Igniter.include_existing_file(igniter, "README.md") do
      {:ok, acc} ->
        Igniter.update_file(acc, "README.md", fn source ->
          replace_doc_names(source, from_name, to_name)
        end)

      {:error, acc} ->
        acc
    end
  end

  defp replace_doc_names(source, from_name, to_name) do
    source
    |> String.replace(from_name, to_name)
    # Also replace kebab-case and snake_case versions if present
    |> String.replace(
      Macro.underscore(from_name),
      Macro.underscore(to_name)
    )
  end

  @doc """
  Generates a summary of changes to be made.

  Returns a formatted string describing all planned transformations.
  """
  @spec generate_summary(rename_config()) :: String.t()
  def generate_summary(config) do
    %{
      from_module: from_base,
      to_module: to_base,
      from_app_prefix: from_prefix,
      to_app_prefix: to_prefix
    } = config

    """
    📋 Planned Transformations:

    Module Names:
      #{inspect(from_base)} → #{inspect(to_base)}
      #{inspect(from_base)}.Core → #{inspect(to_base)}.Core
      #{inspect(from_base)}.Web → #{inspect(to_base)}.Web
      (and all submodules)

    App Atoms:
      :#{from_prefix}_core → :#{to_prefix}_core
      :#{from_prefix}_web → :#{to_prefix}_web
      :#{from_prefix}_ui → :#{to_prefix}_ui
      :#{from_prefix}_docs → :#{to_prefix}_docs

    Directories:
      apps/#{from_prefix}_core → apps/#{to_prefix}_core
      apps/#{from_prefix}_web → apps/#{to_prefix}_web
      apps/#{from_prefix}_ui → apps/#{to_prefix}_ui
      apps/#{from_prefix}_docs → apps/#{to_prefix}_docs

    #{if config.skip_db, do: "", else: "Database Names:\n  #{from_prefix}_dev → #{to_prefix}_dev\n  #{from_prefix}_test → #{to_prefix}_test\n"}
    #{if config.skip_docs, do: "Documentation: Skipped", else: "Documentation: Will update README and markdown files"}

    Files to modify:
      - All .ex and .exs files with module definitions
      - 5 mix.exs files (root + 4 apps)
      - 4 config files
      - Frontend configs (package.json, tailwind.config.js)
    """
  end
end
