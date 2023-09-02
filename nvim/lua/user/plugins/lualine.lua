-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
    return
end

-- get lualine theme
local lualine_theme = require("lualine.themes.onedark")

-- -- new colors for theme
-- local new_colors = {
-- 	blue = "#65D1FF",
-- 	green = "#3EFFDC",
-- 	violet = "#FF61EF",
-- 	yellow = "#FFDA7B",
-- 	black = "#000000",
-- }
--
-- -- change nightlfy theme colors
-- lualine_theme.normal.a.bg = new_colors.blue
-- lualine_theme.insert.a.bg = new_colors.green
-- lualine_theme.visual.a.bg = new_colors.violet
-- lualine_theme.command = {
-- 	a = {
-- 		gui = "bold",
-- 		bg = new_colors.yellow,
-- 		fg = new_colors.black,
-- 	},
-- }

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
}

-- configure lualine with modified thelocal status, lualine = pcall(require, "lualine")
lualine.setup({
    options = {
        icons_enabled = true,
        theme = lualine_theme, -- can be set to "auto"
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
            {
                "filename",
                file_status = true, -- displays file status (readonly status, modified status)
                path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
        },
        lualine_x = { diagnostics, "encoding", "filetype" },
        lualine_y = { "location" },
        lualine_z = { "progress" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "filename",
                file_status = true, -- displays file status (readonly status, modified status)
                path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
        },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { "fugitive" },
})
