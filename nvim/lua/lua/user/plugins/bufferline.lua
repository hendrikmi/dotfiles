local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

vim.opt.linespace = 8

bufferline.setup({
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		buffer_close_icon = "",
		path_components = 1, -- Show only the file name without the directory
		-- buffer_close_icon = '',
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 21,
		diagnostics = false, -- | "nvim_lsp" | "coc",
		diagnostics_update_in_insert = false,
		offsets = {
			{
				filetype = "NvimTree",
				-- display working dir
				text = function()
					local full_path = vim.fn.getcwd()
					local current_folder = vim.fn.fnamemodify(full_path, ":t")
					return current_folder
				end,
				highlight = "Directory",
				text_align = "left",
				-- padding = 1,
				separator = true,
			},
		},
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		separator_style = { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		show_tab_indicators = false,
		indicator = {
			-- icon = "▎", -- this should be omitted if indicator style is not 'icon'
			-- style = "icon", -- can be set to underline
			style = "none",
		},
		icon_pinned = "車",
		minimum_padding = 1,
		maximum_padding = 5,
		maximum_length = 15,
	},
	highlights = {
		-- indicator_selected = {
		-- 	fg = "#8EBB73",
		-- },
		-- separator = {
		-- 	fg = "#8EBB73",
		-- },
		-- separator_selected = {
		-- 	fg = "#8EBB73",
		-- 	bg = "#8EBB73",
		-- },
		-- tab_selected = {
		-- 	bg = "#8EBB73",
		-- },
		-- background = {
		-- 	fg = "#657b83",
		-- 	bg = "#002b36",
		-- },
		buffer_selected = {
			-- fg = "#8EBB73",
			-- bg = "#8EBB73",
			bold = true,
			italic = false,
		},
		-- fill = {
		-- 	bg = "#073642",
		-- },
	},
})

-- vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
-- vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
