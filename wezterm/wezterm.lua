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
  -- get dark or light mode if supported
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end

  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Gruvbox dark, hard (base16)'
  else
    return 'Gruvbox light, hard (base16)'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

---- Font settings
config.font = wezterm.font_with_fallback {
  {
    family = 'MonaspiceNe Nerd Font',
    harfbuzz_features = {'calt=1', 'liga=1', 'dlig=1'}
  },
  {
    family = 'D2CodingLigature Nerd Font',
    harfbuzz_features = {'calt=1', 'liga=1', 'dlig=1'}
  }
}
config.font_size = 13

---- Appearance settings
config.hide_tab_bar_if_only_one_tab = true

-- blur and transparent
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 16

-- solid
config.window_background_opacity = 1
config.macos_window_background_blur = 0


-- Windows Mica 
config.win32_system_backdrop = "Mica"

-- FPS
config.max_fps = 120

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
