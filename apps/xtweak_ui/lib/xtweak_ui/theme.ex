defmodule XTweakUI.Theme do
  @moduledoc """
  Theme configuration for xTweak UI components.

  Inspired by Nuxt UI's app.config.ts, this module provides centralized
  theme configuration for colors, component defaults, and styling patterns.

  ## Configuration

  Theme can be configured in config/config.exs:

      config :xtweak_ui, :theme,
        primary: "blue",
        gray: "slate",
        components: %{
          button: %{
            default: %{variant: "solid", size: "md"}
          }
        }

  ## Usage

      # Get theme configuration
      XTweakUI.Theme.get()

      # Get component-specific config
      XTweakUI.Theme.component_config(:button)
  """

  @default_theme %{
    # Color scheme (matches Nuxt UI's primary color system)
    primary: "blue",
    gray: "slate",

    # Semantic colors (Nuxt UI approach)
    colors: %{
      primary: %{
        "50" => "oklch(97% 0.01 240)",
        "100" => "oklch(94% 0.05 240)",
        "200" => "oklch(88% 0.08 240)",
        "300" => "oklch(78% 0.12 240)",
        "400" => "oklch(68% 0.16 240)",
        "500" => "oklch(60% 0.20 240)",
        "600" => "oklch(52% 0.18 240)",
        "700" => "oklch(44% 0.16 240)",
        "800" => "oklch(36% 0.12 240)",
        "900" => "oklch(28% 0.08 240)"
      },
      gray: %{
        "50" => "oklch(98% 0 0)",
        "500" => "oklch(60% 0 0)",
        "900" => "oklch(20% 0 0)"
      }
    },

    # Component defaults (like Nuxt UI's component config)
    components: %{
      button: %{
        base:
          "inline-flex items-center justify-center font-medium rounded-lg transition-colors duration-150 disabled:opacity-50 disabled:cursor-not-allowed focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
        variant: %{
          solid:
            "bg-primary-500 text-white hover:bg-primary-600 active:bg-primary-700 focus-visible:outline-primary-500",
          outline:
            "border-2 border-primary-500 text-primary-500 hover:bg-primary-50 active:bg-primary-100",
          soft: "bg-primary-100 text-primary-700 hover:bg-primary-200 active:bg-primary-300",
          ghost: "text-primary-500 hover:bg-primary-50 active:bg-primary-100",
          link: "text-primary-500 hover:underline"
        },
        size: %{
          xs: "px-2 py-1 text-xs",
          sm: "px-3 py-1.5 text-sm",
          md: "px-4 py-2 text-base",
          lg: "px-5 py-2.5 text-lg",
          xl: "px-6 py-3 text-xl"
        },
        color: %{
          primary: %{solid: "bg-primary-500 hover:bg-primary-600"},
          secondary: %{solid: "bg-gray-500 hover:bg-gray-600"},
          success: %{solid: "bg-green-500 hover:bg-green-600"},
          warning: %{solid: "bg-yellow-500 hover:bg-yellow-600"},
          error: %{solid: "bg-red-500 hover:bg-red-600"}
        },
        default: %{
          color: "primary",
          variant: "solid",
          size: "md"
        }
      }
    }
  }

  @doc """
  Gets the complete theme configuration.

  Returns the theme from application config or the default theme.
  """
  def get do
    Application.get_env(:xtweak_ui, :theme, @default_theme)
  end

  @doc """
  Gets configuration for a specific component.

  ## Examples

      iex> XTweakUI.Theme.component_config(:button)
      %{base: "...", variant: %{...}, size: %{...}}
  """
  def component_config(component) when is_atom(component) do
    get()
    |> Map.get(:components, %{})
    |> Map.get(component, %{})
  end

  @doc """
  Gets the default configuration for a component.

  ## Examples

      iex> XTweakUI.Theme.component_defaults(:button)
      %{color: "primary", variant: "solid", size: "md"}
  """
  def component_defaults(component) when is_atom(component) do
    component_config(component)
    |> Map.get(:default, %{})
  end

  @doc """
  Gets color configuration.
  """
  def colors do
    Map.get(get(), :colors, %{})
  end
end
