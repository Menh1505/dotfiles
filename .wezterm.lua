-- Pull in the wezterm API
local wezterm = require("wezterm")
local io = require("io")
local math = require("math")
local os = require("os")

local wallpaper_dir = "/DATA/pictures/wallpaper/"
local last_update_time = os.time() -- Latest time save variable

-- Get file in folder
local function get_wallpapers()
	local wallpapers = {}
	local p = io.popen('ls "' .. wallpaper_dir .. '"') -- Run ls command to get file list
	if p then
		for file in p:lines() do
			table.insert(wallpapers, wallpaper_dir .. file)
		end
		p:close()
	end
	return wallpapers
end

-- Get random from folder
local function get_random_wallpaper()
	local wallpapers = get_wallpapers()
	if #wallpapers > 0 then
		math.randomseed(os.time()) -- Init random number
		return wallpapers[math.random(#wallpapers)]
	end
	return nil
end

-- Auto replace wallpaper after time
wezterm.on("update-right-status", function(window, pane)
	local now = os.time()
	-- Kiểm tra nếu đã qua 600 giây (10 phút)
	if now - last_update_time >= 600 then
		local new_wallpaper = get_random_wallpaper()
		if new_wallpaper then
			window:set_config_overrides({
				window_background_image = new_wallpaper,
			})
			last_update_time = now -- Cập nhật lại thời gian đổi nền
		end
	end
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- General settings
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	bottom = 0,
	top = 0,
}
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("0xProto Nerd Font", {
	weight = "Medium",
})

-- Set the initial random wallpaper
config.window_background_opacity = 1
config.text_background_opacity = 0.5
config.window_background_image_hsb = {
	hue = 1,
	saturation = 0.7,
	brightness = 0.1,
}
config.window_background_image = get_random_wallpaper()

-- Return the final configuration
return config
