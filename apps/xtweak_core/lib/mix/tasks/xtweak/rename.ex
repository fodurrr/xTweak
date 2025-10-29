defmodule Mix.Tasks.Xtweak.Rename do
  use Igniter.Mix.Task

  alias Mix.Tasks.Helpers.ProjectRenamer

  @shortdoc "Renames the xTweak project to a new name (for template usage)"

  @moduledoc """
  Renames the entire xTweak umbrella project to a new name.

  This task is designed for when xTweak is used as a template project.
  It safely renames modules, apps, configs, directories, and documentation.

  ## Usage

  Interactive mode (recommended):

      mix xtweak.rename

  Non-interactive mode:

      mix xtweak.rename --to MyProject
      mix xtweak.rename --to MyProject --yes

  ## Options

    * `--from` - Source project name (default: auto-detected as XTweak)
    * `--to` - Target project name (required if not interactive)
    * `--app-prefix` - New app atom prefix (default: snake_case of --to)
    * `--skip-docs` - Don't update documentation files
    * `--skip-db` - Don't rename database names
    * `--dry-run` - Show planned changes without applying them
    * `--yes` - Skip confirmation prompts

  ## Examples

      # Interactive mode with prompts
      mix xtweak.rename

      # Rename to MyProject (interactive confirmation)
      mix xtweak.rename --to MyProject

      # Rename with custom app prefix
      mix xtweak.rename --to MyApp --app-prefix my_custom_app

      # Preview changes without applying
      mix xtweak.rename --to MyProject --dry-run

      # Fully automated (CI/scripts)
      mix xtweak.rename --to MyProject --yes

  ## What Gets Renamed

  1. **Module names**: `XTweak.*` → `YourProject.*`
  2. **App atoms**: `:xtweak_core` → `:yourproject_core`
  3. **Directories**: `apps/xtweak_*` → `apps/yourproject_*`
  4. **Database names**: `xtweak_dev` → `yourproject_dev`
  5. **Config files**: All app and database references
  6. **Documentation** (unless --skip-docs): README and guides

  ## Safety Features

  - Validates git working directory is clean
  - Dry-run mode to preview changes
  - Uses AST manipulation (not regex) for Elixir code
  - Validates module and app names
  - Can be run multiple times (idempotent)

  ## After Running

      mix deps.get
      mix compile
      mix test

  Create new databases:

      MIX_ENV=dev mix ash_postgres.create
      MIX_ENV=test mix ash_postgres.create
  """

  @impl Igniter.Mix.Task
  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      group: :xtweak,
      example: "mix xtweak.rename --to MyProject",
      positional: [],
      schema: [
        from: :string,
        to: :string,
        app_prefix: :string,
        skip_docs: :boolean,
        skip_db: :boolean,
        dry_run: :boolean,
        yes: :boolean
      ],
      aliases: [
        y: :yes,
        d: :dry_run
      ]
    }
  end

  @impl Igniter.Mix.Task
  def igniter(igniter) do
    options = igniter.args.options

    # Get or prompt for configuration
    case build_config(options) do
      {:ok, config} ->
        handle_valid_config(igniter, config, options)

      {:error, reason} ->
        Mix.shell().error("❌ #{reason}")
        igniter
    end
  end

  defp handle_valid_config(igniter, config, options) do
    case ProjectRenamer.validate_config(config) do
      {:ok, validated_config} ->
        process_validated_config(igniter, validated_config, options)

      {:error, reason} ->
        Mix.shell().error("❌ Configuration error: #{reason}")
        igniter
    end
  end

  defp process_validated_config(igniter, config, options) do
    if should_proceed?(config, options) do
      igniter
      |> apply_rename(config)
      |> maybe_rename_directories(config)
      |> print_next_steps(config)
    else
      Mix.shell().info("❌ Rename cancelled.")
      igniter
    end
  end

  defp build_config(options) do
    # Detect or use provided source project name
    from_module = detect_or_parse_module(options[:from] || "XTweak")
    from_prefix = options[:from_app_prefix] || Macro.underscore(inspect(from_module))

    # Get target project name
    to_name =
      options[:to] ||
        Mix.shell().prompt("📝 New project name (PascalCase, e.g., MyProject):") |> String.trim()

    if to_name == "" do
      {:error, "Project name cannot be empty"}
    else
      to_module = parse_module_name(to_name)
      to_prefix = options[:app_prefix] || Macro.underscore(to_name)

      config = %{
        from_module: from_module,
        to_module: to_module,
        from_app_prefix: from_prefix,
        to_app_prefix: to_prefix,
        skip_docs: options[:skip_docs] || false,
        skip_db: options[:skip_db] || false,
        dry_run: options[:dry_run] || false
      }

      {:ok, config}
    end
  end

  defp detect_or_parse_module(name) when is_binary(name) do
    parse_module_name(name)
  end

  defp parse_module_name(name) when is_binary(name) do
    # Convert string to module atom
    # "MyProject" -> MyProject
    # "My.Project" -> My.Project
    parts =
      name
      |> String.split(".")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    Module.concat(parts)
  end

  defp should_proceed?(config, options) do
    # Show summary
    summary = ProjectRenamer.generate_summary(config)
    Mix.shell().info(summary)

    if config.dry_run do
      Mix.shell().info("\n🔍 DRY RUN MODE - No changes will be applied")
      false
    else
      Mix.shell().info("\n⚠️  This will modify your files.")

      if options[:yes] do
        Mix.shell().info("✅ Proceeding (--yes flag provided)")
        true
      else
        Mix.shell().yes?("\nContinue with rename?")
      end
    end
  end

  defp apply_rename(igniter, config) do
    Mix.shell().info("\n🔄 Applying transformations...")

    igniter
    |> tap(fn _ -> Mix.shell().info("  → Renaming modules...") end)
    |> ProjectRenamer.rename_modules(config)
    |> tap(fn _ -> Mix.shell().info("  → Updating mix.exs files...") end)
    |> ProjectRenamer.rename_mix_files(config)
    |> tap(fn _ -> Mix.shell().info("  → Updating config files...") end)
    |> ProjectRenamer.rename_config_files(config)
    |> tap(fn _ ->
      unless config.skip_docs do
        Mix.shell().info("  → Updating documentation...")
      end
    end)
    |> ProjectRenamer.rename_documentation(config)
    |> update_frontend_configs(config)
  end

  defp update_frontend_configs(igniter, config) do
    %{from_app_prefix: from_prefix, to_app_prefix: to_prefix} = config

    Mix.shell().info("  → Updating frontend configs...")

    # Update package.json
    igniter =
      case Igniter.include_existing_file(igniter, "apps/#{from_prefix}_web/assets/package.json") do
        {:ok, igniter} ->
          Igniter.update_file(
            igniter,
            "apps/#{from_prefix}_web/assets/package.json",
            fn source ->
              String.replace(source, from_prefix, to_prefix)
            end
          )

        {:error, igniter} ->
          igniter
      end

    # Update tailwind.config.js
    case Igniter.include_existing_file(
           igniter,
           "apps/#{from_prefix}_web/assets/tailwind.config.js"
         ) do
      {:ok, igniter} ->
        Igniter.update_file(
          igniter,
          "apps/#{from_prefix}_web/assets/tailwind.config.js",
          fn source ->
            source
            # Update content paths
            |> String.replace(
              "../lib/#{from_prefix}_web_web.ex",
              "../lib/#{to_prefix}_web_web.ex"
            )
            |> String.replace(
              "../lib/#{from_prefix}_web_web/",
              "../lib/#{to_prefix}_web_web/"
            )
          end
        )

      {:error, igniter} ->
        igniter
    end
  end

  defp maybe_rename_directories(igniter, config) do
    %{from_app_prefix: from_prefix, to_app_prefix: to_prefix} = config

    if should_rename_directories?(from_prefix, to_prefix, config.dry_run) do
      Mix.shell().info("\n📁 Renaming directories...")
      apps = ["core", "web", "ui", "docs"]
      Enum.each(apps, &rename_app_directory(&1, from_prefix, to_prefix))
    end

    igniter
  end

  defp should_rename_directories?(from_prefix, to_prefix, dry_run) do
    from_prefix != to_prefix and not dry_run
  end

  defp rename_app_directory(app, from_prefix, to_prefix) do
    old_path = "apps/#{from_prefix}_#{app}"
    new_path = "apps/#{to_prefix}_#{app}"

    if File.exists?(old_path) do
      Mix.shell().info("  → #{old_path} → #{new_path}")
      File.rename!(old_path, new_path)
      rename_internal_directories(new_path, app, from_prefix, to_prefix)
    end
  end

  defp rename_internal_directories(new_path, app, from_prefix, to_prefix) do
    # Rename internal lib directory structure
    old_lib = "#{new_path}/lib/#{from_prefix}_#{app}"
    new_lib = "#{new_path}/lib/#{to_prefix}_#{app}"

    if File.exists?(old_lib) do
      File.rename!(old_lib, new_lib)
    end

    # Rename internal web directory if it exists (e.g., lib/xtweak_web_web)
    old_web_lib = "#{new_path}/lib/#{from_prefix}_#{app}_#{app}"
    new_web_lib = "#{new_path}/lib/#{to_prefix}_#{app}_#{app}"

    if File.exists?(old_web_lib) do
      File.rename!(old_web_lib, new_web_lib)
    end
  end

  defp print_next_steps(igniter, config) do
    Mix.shell().info("\n✅ Rename complete!")

    unless config.dry_run do
      Mix.shell().info("""

      📋 Next Steps:

      1. Update dependencies:
         mix deps.get

      2. Clean and recompile:
         mix clean
         mix compile

      3. Run tests:
         mix test

      4. Create new databases (if renamed):
         MIX_ENV=dev mix ash_postgres.create
         MIX_ENV=dev mix ash_postgres.migrate
         MIX_ENV=test mix ash_postgres.create
         MIX_ENV=test mix ash_postgres.migrate

      5. (Optional) Drop old databases:
         MIX_ENV=dev mix ash_postgres.drop -r XTweak.Repo

      6. Commit changes:
         git add -A
         git commit -m "Rename project from XTweak to #{inspect(config.to_module)}"

      Happy coding with your new project! 🎉
      """)
    end

    igniter
  end
end
