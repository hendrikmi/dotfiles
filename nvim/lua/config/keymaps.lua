-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open URL under cursor in browser
-- Not yet working...
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")
