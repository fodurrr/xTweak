defmodule XTweakUI.ThemeTest do
  use ExUnit.Case, async: true

  alias XTweakUI.Theme

  describe "get/0" do
    test "returns default theme" do
      theme = Theme.get()
      assert theme.primary == "blue"
      assert is_map(theme.colors)
      assert is_map(theme.components)
    end

    test "theme contains color scales" do
      theme = Theme.get()
      assert is_map(theme.colors.primary)
      assert theme.colors.primary["500"] =~ "oklch"
    end
  end

  describe "component_config/1" do
    test "returns button configuration" do
      config = Theme.component_config(:button)
      assert is_binary(config.base)
      assert is_map(config.variant)
      assert is_map(config.size)
    end

    test "button config contains all variants" do
      config = Theme.component_config(:button)
      assert Map.has_key?(config.variant, :solid)
      assert Map.has_key?(config.variant, :outline)
      assert Map.has_key?(config.variant, :soft)
      assert Map.has_key?(config.variant, :ghost)
      assert Map.has_key?(config.variant, :link)
    end

    test "button config contains all sizes" do
      config = Theme.component_config(:button)
      assert Map.has_key?(config.size, :xs)
      assert Map.has_key?(config.size, :sm)
      assert Map.has_key?(config.size, :md)
      assert Map.has_key?(config.size, :lg)
      assert Map.has_key?(config.size, :xl)
    end

    test "returns empty map for unknown component" do
      config = Theme.component_config(:unknown)
      assert config == %{}
    end
  end

  describe "component_defaults/1" do
    test "returns button defaults" do
      defaults = Theme.component_defaults(:button)
      assert defaults.color == "primary"
      assert defaults.variant == "solid"
      assert defaults.size == "md"
    end

    test "returns empty map for unknown component" do
      defaults = Theme.component_defaults(:unknown)
      assert defaults == %{}
    end
  end

  describe "colors/0" do
    test "returns color scale" do
      colors = Theme.colors()
      assert is_map(colors.primary)
      assert colors.primary["500"] =~ "oklch"
    end

    test "includes gray scale" do
      colors = Theme.colors()
      assert is_map(colors.gray)
      assert colors.gray["500"] =~ "oklch"
    end
  end
end
