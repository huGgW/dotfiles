-- Pull in the wezterm API
local wezterm = require 'wezterm'

------ This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


------ This is where you actually apply your config choices

---- color scheme settings

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  -- Use dark mode on linux (since hyprland cannot detect dark mode on linux)
  wezterm.log_warn("target_triple: " .. wezterm.target_triple)
  if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
    return 'Dark'
  end

  -- get dark or light mode if supported
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end

  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

---- Font settings
config.font = wezterm.font_with_fallback {
  {
    family = 'Monaspace Neon',
    harfbuzz_features = {'calt=1', 'liga=1', 'dlig=1'}
  },
  {
    family = 'D2CodingLigature Nerd Font',
    harfbuzz_features = {'calt=1', 'liga=1', 'dlig=1'}
  }
}
config.font_size = 16

---- Appearance settings
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.825

-- Macos blur
config.macos_window_background_blur = 64

-- Windows Mica 
config.win32_system_backdrop = "Mica"

-- FPS
config.max_fps = 120


-- and finally, return the configuration to wezterm
return config
