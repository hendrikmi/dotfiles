local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function is_vim(pane)
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local super_vim_keys_map = {
	x = utf8.char(0xAB), -- Using 0xAB for CMD+X
	c = utf8.char(0xAC), -- Using 0xAC for CMD+C
}

local function bind_super_key_to_vim(key)
	return {
		key = key,
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			local char = super_vim_keys_map[key]
			if char and is_vim(pane) then
				win:perform_action({
					SendKey = { key = char, mods = nil },
				}, pane)
			else
				win:perform_action({
					SendKey = { key = key, mods = "CMD" },
				}, pane)
			end
		end),
	}
end

config = {
	default_cursor_style = "SteadyBar",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	hide_tab_bar_if_only_one_tab = true,
	-- Exit code behaviour
	exit_behavior = "Hold",
	exit_behavior_messaging = "Brief",
	adjust_window_size_when_changing_font_size = false,
	enable_tab_bar = true,
	use_fancy_tab_bar = true,
	window_decorations = "TITLE | RESIZE",
	check_for_updates = false,
	tab_bar_at_bottom = false,
	font_size = 12.5,
	font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
	window_padding = {
		left = 10,
		right = 10,
		top = 0,
		bottom = 0,
	},
	keys = {
		-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
		{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },

		-- Make Option-Right equivalent to Alt-f; forward-word
		{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

		-- Add Command + Backspace to delete the whole line
		{
			key = "Backspace",
			mods = "CMD",
			action = wezterm.action({ SendKey = { mods = "CTRL", key = "u" } }),
		},

		-- Add Option + Backspace to delete a word
		{
			key = "Backspace",
			mods = "OPT",
			action = wezterm.action({ SendKey = { mods = "CTRL", key = "w" } }),
		},
		-- Select next tab with cmd-opt-left/right arrow
		{
			key = "LeftArrow",
			mods = "CMD|OPT",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "RightArrow",
			mods = "CMD|OPT",
			action = wezterm.action.ActivateTabRelative(1),
		},
		-- Select next pane with cmd-left/right arrow
		{
			key = "LeftArrow",
			mods = "CMD",
			action = wezterm.action({ ActivatePaneDirection = "Prev" }),
		},
		{
			key = "RightArrow",
			mods = "CMD",
			action = wezterm.action({ ActivatePaneDirection = "Next" }),
		},
		-- on cmd-s, send esc, then ':w<enter>'. This makes cmd-s trigger a save action in neovim
		{
			key = "s",
			mods = "CMD",
			action = wezterm.action({ SendString = "\x1b:w\n" }),
		},
		-- Add copy and paste as normal
		bind_super_key_to_vim("x"),
		bind_super_key_to_vim("c"),
	},
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CMD|ALT",
			action = wezterm.action.SelectTextAtMouseCursor("Block"),
			alt_screen = "Any",
		},
		{
			event = { Down = { streak = 4, button = "Left" } },
			action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
			mods = "NONE",
		},
	},
	background = {
		{
			source = {
				File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/dark-desert.jpg",
			},
			hsb = {
				hue = 1.0,
				saturation = 1.02,
				brightness = 0.25,
			},
			-- attachment = { Parallax = 0.3 },
			-- width = "100%",
			-- height = "100%",
		},
		{
			source = {
				Color = "#282c35",
			},
			width = "100%",
			height = "100%",
			opacity = 0.55,
		},
	},
	-- from: https://akos.ma/blog/adopting-wezterm/
	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$1",
			highlight = 1,
		},
		-- Then handle URLs not wrapped in brackets
		{
			-- Before
			--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
			--format = '$0',
			-- After
			regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
			format = "$1",
			highlight = 1,
		},
		-- implicit mailto link
		{
			regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
			format = "mailto:$0",
		},
	},
}
return config
