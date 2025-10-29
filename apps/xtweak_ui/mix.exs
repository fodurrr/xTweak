defmodule XTweakUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :xtweak_ui,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8"},
      {:phoenix_live_view, "~> 1.1"},
      {:phoenix_html, "~> 4.1"},
      {:jason, "~> 1.2"},

      # Dev/Test
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["cmd --cd assets npm install"],
      "assets.build": ["cmd --cd assets npm run build"],
      "assets.watch": ["cmd --cd assets npm run watch"],
      "assets.deploy": ["cmd --cd assets npm run deploy"],
      test: ["assets.build", "test"]
    ]
  end

  defp description do
    "A UI component library for Elixir applications"
  end

  defp package do
    [
      maintainers: ["Peter Fodor"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fodurrr/xTweak"},
      files: ~w(lib assets/css priv .formatter.exs mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "XTweakUI",
      extras: ["README.md"],
      groups_for_modules: [
        Components: [~r/XTweakUI.Components/],
        Theming: [XTweakUI.Theme]
      ]
    ]
  end
end
