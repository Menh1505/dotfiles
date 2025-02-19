local wezterm = require("wezterm")
local os = require("os")
local math = require("math")

local wallpaper_dir = "C:\\Users\\ADMIN\\Pictures\\wallpaper"
local last_update_time = os.time() -- Latest time save variable
local current_wallpaper = nil -- current_wallpaper variable

-- Lưu danh sách hình nền vào vector chỉ một lần
local wallpaper_vector = {}

-- Duyệt thư mục một lần và lưu tên tệp
local function get_wallpapers_once()
	if #wallpaper_vector == 0 then
		local p = io.popen(
			"powershell -Command \"Get-ChildItem -Path '"
				.. wallpaper_dir
				.. "' -File | ForEach-Object { $_.FullName }\""
		)
		if p then
			for file in p:lines() do
				table.insert(wallpaper_vector, file)
			end
			p:close()
		end
	end
end

-- Lấy hình nền ngẫu nhiên từ vector
local function get_random_wallpaper()
	get_wallpapers_once() -- Đảm bảo danh sách hình nền đã được lấy
	if #wallpaper_vector > 0 then
		math.randomseed(os.time()) -- Init random number
		local new_wallpaper = wallpaper_vector[math.random(#wallpaper_vector)]
		return new_wallpaper
	end
	return nil
end

-- Auto replace wallpaper after time
wezterm.on("update-right-status", function(window, pane)
	local now = os.time()
	-- Kiểm tra thời gian 900 giây (15 phút)
	if now - last_update_time >= 900 then
		local new_wallpaper = get_random_wallpaper()
		if new_wallpaper and new_wallpaper ~= current_wallpaper then
			current_wallpaper = new_wallpaper
			window:set_config_overrides({
				window_background_image = current_wallpaper,
			})
			last_update_time = now -- Cập nhật thời gian thay đổi hình nền
		end
	end
end)

-- Function to manually change wallpaper
local function change_wallpaper(window, pane)
	local new_wallpaper = get_random_wallpaper()
	if new_wallpaper and new_wallpaper ~= current_wallpaper then
		current_wallpaper = new_wallpaper
		window:set_config_overrides({
			window_background_image = current_wallpaper,
		})
	end
end

-- Cấu hình WezTerm
local config = wezterm.config_builder()

config.enable_tab_bar = true
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
current_wallpaper = get_random_wallpaper()
config.window_background_opacity = 1
config.text_background_opacity = 0.5
config.window_background_image_hsb = {
	hue = 1,
	saturation = 0.7,
	brightness = 0.05,
}
config.window_background_image = current_wallpaper

-- Add keybinding to change wallpaper manually
config.keys = {
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(change_wallpaper),
	},
}

-- Auto start PowerShell when run wezterm
config.default_prog = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" }

-- Return the final configuration
return config
