-- options
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

----------------------
-- General Keybinds
----------------------

-- clear highlights
keymap("n", "<Esc>", ":noh<CR>", opts)

-- save file
keymap("n", "<C-s>", "<cmd> w <CR>", opts)

-- quit file
keymap("n", "<C-q>", "<cmd> q <CR>", opts)

-- copy all
keymap("n", "<C-c>", "<cmd> %y+ <CR>", opts)

-- delete single character without copying into register
keymap("n", "x", '"_x', opts)

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>", opts)
keymap("n", "<Down>", ":resize +2<CR>", opts)
keymap("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", opts) -- increment
keymap("n", "<leader>-", "<C-x>", opts) -- decrement

-- window management
keymap("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
keymap("n", "<leader>sx", ":close<CR>", opts) -- close current split window

keymap("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
keymap("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
keymap("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
keymap("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

keymap("n", "<leader>x", ":Bdelete!<CR>", opts) -- close buffer
keymap("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Allow moving the cursor through wrapped lines with j, k
keymap("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
keymap("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- toggle line wrapping
keymap("n", "<leader>w", "<cmd>set wrap!<CR>", opts)

-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- use jk to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- keep last yanked when pasting
keymap("v", "p", '"_dP', opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

----------------------
-- Plugin Keybinds
----------------------

-- onedark theme
keymap("n", "<leader>tb", "<cmd>lua _G.toggle_onedark_transparency()<CR>", opts)

-- vim-maximizer
keymap("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- toggle split window maximization

-- nvim-tree
keymap("n", "<leader>n", ":NvimTreeToggle<CR>", opts) -- toggle file explorer
keymap("n", "<leader>e", ":NvimTreeFocus<CR>", opts) -- focus file explorer

-- telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts) -- find files within current working directory, respects .gitignore
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", opts) -- find string in current working directory as you type
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts) -- find string under cursor in current working directory
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- list open buffers in current neovim instance
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- list available help tags

-- telescope git commands
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", opts) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts) -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts) -- list current changes per file with diff preview ["gs" for git status]

-- comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- hop (easymotion and sneak like navigation)
keymap("n", "<leader><leader>b", "<cmd>HopWordBC<CR>", opts)
keymap("n", "<leader><leader>w", "<cmd>HopWordAC<CR>", opts)
keymap("n", "<leader><leader>j", "<cmd>HopLineAC<CR>", opts)
keymap("n", "<leader><leader>k", "<cmd>HopLineBC<CR>", opts)
keymap("n", "s", "<cmd>HopChar2CurrentLine<CR>", opts)

-- bufferline
keymap("n", "<leader>1", "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", opts)
keymap("n", "<leader>2", "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", opts)
keymap("n", "<leader>3", "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", opts)
keymap("n", "<leader>4", "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", opts)
keymap("n", "<leader>5", "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", opts)
keymap("n", "<leader>6", "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", opts)
keymap("n", "<leader>7", "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", opts)
keymap("n", "<leader>8", "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", opts)
keymap("n", "<leader>9", "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", opts)

-- restart lsp server
keymap("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
