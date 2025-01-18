-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open URL under cursor in browser
-- Not yet working...
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")
-- Stop deleting from sending to the clipboard
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "x", '"_x')
vim.keymap.set({ "n", "v" }, "X", '"_X')
vim.keymap.set({ "n", "v" }, "dd", '"_dd')
vim.keymap.set({ "n", "v" }, "cc", '"_cc')
vim.keymap.set({ "n", "v" }, "C", '"_C')
vim.keymap.set({ "n", "v" }, "c", '"_c')
-- Copy and paste to system clipboard with command key
local cmd_x = "<Char-0xAB>"
local cmd_v = "<Char-0xAC>"
vim.keymap.set({ "v" }, cmd_x, '"+x', { desc = "Cut text to system clipboard" })
vim.keymap.set("n", cmd_x, "yydd", { desc = "Paste text from system clipboard" })
vim.keymap.set({ "n", "v" }, cmd_v, '"+y', { desc = "Yank text to system clipboard" })
vim.keymap.set({ "v" }, cmd_x, '"+x', { desc = "Cut text to system clipboard" })
