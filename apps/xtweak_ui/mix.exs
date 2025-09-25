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
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:phoenix_live_view, "~> 1.1"},
      {:phoenix_html, "~> 4.1"}
    ]
  end

  defp description do
    "A UI component library for Elixir applications"
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yourusername/xtweak_ui"}
    ]
  end
end
