defmodule XTweak.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      elixir: "~> 1.18.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer(),
      listeners: [Phoenix.CodeReloader],
      releases: [
        xtweak: [
          version: "0.1.0",
          applications: [
            xtweak_core: :permanent,
            xtweak_web: :permanent,
            xtweak_docs: :permanent,
            xtweak_ui: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:ash_phoenix, "~> 2.3"},
      {:ash_authentication, "~> 4.9"},
      {:ash_postgres, "~> 2.6"},
      {:ash, "~> 3.5.39"},
      {:igniter, "~> 0.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:file_system, "~> 1.1", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      # Database (Ash-first approach)
      setup: ["ash.setup"],
      reset: ["ash.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.deploy": ["phx.digest"],

      # Development workflow
      "db.setup": ["ash.setup"],
      "db.reset": ["ash.setup"],

      # Ash-specific commands
      "ash.generate": ["ash_postgres.generate_migrations"],
      "ash.gen": ["ash_postgres.generate_migrations"],

      # Quality & CI checks
      quality: ["format", "credo --strict", "compile"],
      "quality.full": ["format", "credo --strict", "compile", "test", "deps.audit"],
      "ci.local": ["format --check-formatted", "credo --strict", "compile --warnings-as-errors"],
      "ci.prepare": ["deps.get", "format", "credo --strict", "compile"],

      # Deprecated aliases (for migration period)
      "ecto.setup": ["ash.setup"],
      "ecto.reset": ["ash.setup"],
      "ecto.migrate": ["ash.setup"]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit, :mix],
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      ignore_warnings: ".dialyzer_ignore.exs"
    ]
  end
end
