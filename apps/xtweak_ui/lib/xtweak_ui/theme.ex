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
      },
      badge: %{
        base:
          "inline-flex items-center justify-center font-medium rounded-full whitespace-nowrap",
        default: %{
          color: "gray",
          variant: "solid",
          size: "md"
        }
      },
      avatar: %{
        base:
          "inline-flex items-center justify-center shrink-0 select-none rounded-full align-middle bg-gray-100 dark:bg-gray-800",
        default: %{
          size: "md"
        }
      },
      card: %{
        base: "rounded-lg overflow-hidden",
        variant: %{
          solid: "bg-gray-900 text-white dark:bg-gray-100 dark:text-gray-900",
          outline:
            "bg-white dark:bg-gray-900 ring-1 ring-gray-200 dark:ring-gray-800 divide-y divide-gray-200 dark:divide-gray-800",
          soft: "bg-gray-50/50 dark:bg-gray-900/50 divide-y divide-gray-200 dark:divide-gray-800",
          subtle:
            "bg-gray-50/50 dark:bg-gray-900/50 ring-1 ring-gray-200 dark:ring-gray-800 divide-y divide-gray-200 dark:divide-gray-800"
        },
        padding: %{
          none: "",
          sm: "p-3 sm:px-4",
          md: "p-4 sm:px-6",
          lg: "p-6 sm:px-8"
        },
        default: %{
          variant: "outline",
          padding: "md"
        }
      },
      alert: %{
        base: "relative overflow-hidden w-full rounded-lg p-4 flex gap-2.5",
        orientation: %{
          vertical: "items-start",
          horizontal: "items-center"
        },
        color: %{
          info: %{
            icon: "hero-information-circle",
            aria_live: "polite",
            solid: "bg-blue-500 text-white",
            outline: "text-blue-600 dark:text-blue-400 ring ring-inset ring-blue-500/25",
            soft: "bg-blue-500/10 text-blue-600 dark:text-blue-400",
            subtle:
              "bg-blue-500/10 text-blue-600 dark:text-blue-400 ring ring-inset ring-blue-500/25"
          },
          success: %{
            icon: "hero-check-circle",
            aria_live: "polite",
            solid: "bg-green-500 text-white",
            outline: "text-green-600 dark:text-green-400 ring ring-inset ring-green-500/25",
            soft: "bg-green-500/10 text-green-600 dark:text-green-400",
            subtle:
              "bg-green-500/10 text-green-600 dark:text-green-400 ring ring-inset ring-green-500/25"
          },
          warning: %{
            icon: "hero-exclamation-triangle",
            aria_live: "assertive",
            solid: "bg-yellow-500 text-white",
            outline: "text-yellow-600 dark:text-yellow-400 ring ring-inset ring-yellow-500/25",
            soft: "bg-yellow-500/10 text-yellow-600 dark:text-yellow-400",
            subtle:
              "bg-yellow-500/10 text-yellow-600 dark:text-yellow-400 ring ring-inset ring-yellow-500/25"
          },
          error: %{
            icon: "hero-x-circle",
            aria_live: "assertive",
            solid: "bg-red-500 text-white",
            outline: "text-red-600 dark:text-red-400 ring ring-inset ring-red-500/25",
            soft: "bg-red-500/10 text-red-600 dark:text-red-400",
            subtle: "bg-red-500/10 text-red-600 dark:text-red-400 ring ring-inset ring-red-500/25"
          },
          primary: %{
            icon: "hero-bell",
            aria_live: "polite",
            solid: "bg-primary-500 text-white",
            outline: "text-primary-600 dark:text-primary-400 ring ring-inset ring-primary-500/25",
            soft: "bg-primary-500/10 text-primary-600 dark:text-primary-400",
            subtle:
              "bg-primary-500/10 text-primary-600 dark:text-primary-400 ring ring-inset ring-primary-500/25"
          },
          secondary: %{
            icon: "hero-bell",
            aria_live: "polite",
            solid: "bg-gray-500 text-white",
            outline: "text-gray-600 dark:text-gray-400 ring ring-inset ring-gray-500/25",
            soft: "bg-gray-500/10 text-gray-600 dark:text-gray-400",
            subtle:
              "bg-gray-500/10 text-gray-600 dark:text-gray-400 ring ring-inset ring-gray-500/25"
          },
          neutral: %{
            icon: "hero-bell",
            aria_live: "polite",
            solid: "bg-gray-900 text-white dark:bg-gray-100 dark:text-gray-900",
            outline:
              "text-gray-700 dark:text-gray-300 ring ring-inset ring-gray-200 dark:ring-gray-800",
            soft: "bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300",
            subtle:
              "bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300 ring ring-inset ring-gray-200 dark:ring-gray-800"
          }
        },
        slots: %{
          leading: "shrink-0",
          icon: "size-5",
          wrapper: "min-w-0 flex-1 flex flex-col",
          title: "text-sm font-medium",
          description: "text-sm opacity-90",
          actions: "flex flex-wrap gap-1.5 shrink-0",
          close:
            "p-0 inline-flex items-center justify-center text-current opacity-70 hover:opacity-100 transition-opacity"
        },
        default: %{
          color: "info",
          variant: "soft",
          orientation: "vertical",
          close: false
        }
      },
      divider: %{
        base: "flex items-center align-center text-center",
        orientation: %{
          horizontal: %{
            root: "w-full flex-row",
            border: "w-full",
            container: "mx-3 whitespace-nowrap"
          },
          vertical: %{
            root: "h-full flex-col",
            border: "h-full",
            container: "my-2"
          }
        },
        size: %{
          horizontal: %{
            xs: "border-t",
            sm: "border-t-[2px]",
            md: "border-t-[3px]",
            lg: "border-t-[4px]",
            xl: "border-t-[5px]"
          },
          vertical: %{
            xs: "border-s",
            sm: "border-s-[2px]",
            md: "border-s-[3px]",
            lg: "border-s-[4px]",
            xl: "border-s-[5px]"
          }
        },
        type: %{
          solid: "border-solid",
          dashed: "border-dashed",
          dotted: "border-dotted"
        },
        color: %{
          primary: "border-[var(--color-primary)]",
          secondary: "border-[var(--color-secondary)]",
          success: "border-[var(--color-success)]",
          info: "border-[var(--color-info)]",
          warning: "border-[var(--color-warning)]",
          error: "border-[var(--color-error)]",
          neutral: "border-gray-200 dark:border-gray-800"
        },
        slots: %{
          container: "font-medium text-gray-700 dark:text-gray-300 flex shrink-0",
          icon: "shrink-0 size-5",
          avatar: "shrink-0",
          avatar_size: "2xs",
          label: "text-sm whitespace-nowrap"
        },
        default: %{
          color: "neutral",
          size: "xs",
          type: "solid",
          orientation: "horizontal"
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
