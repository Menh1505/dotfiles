-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  bottom = 0,
  top = 0
}

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font("0xProto Nerd Font", {
  weight = "Medium",
})
config.window_background_image = '/DATA/pictures/wallpaper/forest-fall.jpg'
config.text_background_opacity = 0.5
config.window_background_image_hsb = {
  hue = 1,
  saturation = 0.7,
  brightness = 0.2
}

-- and finally, return the configuration to wezterm
return config
