local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- add list of plugins to install
return packer.startup(function(use)
	-- Have packer manage itself
	use({ "wbthomason/packer.nvim", commit = "1d0cf98" })

	-- Useful lua functions used by lots of plugins
	use({ "nvim-lua/plenary.nvim", commit = "9ac3e95" })

	-- colorscheme
	use({ "navarasu/onedark.nvim", commit = "dd640f6" })
	-- use({ "lunarvim/colorschemes" })
	-- use({
	-- 	"svrana/neosolarized.nvim",
	-- 	requires = { "tjdevries/colorbuddy.nvim" },
	-- })

	use({ "christoomey/vim-tmux-navigator", commit = "cdd66d6" }) -- tmux & split window navigation

	use({ "szw/vim-maximizer", commit = "2e54952" }) -- maximizes and restores current window

	-- essential plugins
	use({ "tpope/vim-surround", commit = "3d188ed" }) -- add, delete, change surroundings (it's awesome)
	use({ "inkarkat/vim-ReplaceWithRegister", commit = "aad1e8f" }) -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	use({ "numToStr/Comment.nvim", commit = "a89339f" })

	-- file explorer
	use({ "nvim-tree/nvim-tree.lua", commit = "6ad5c26f4d44791699c5538d9773cb141ba033e7" })

	-- use({
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	branch = "v2.x",
	-- 	requires = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- })
	-- vs-code like icons
	use({ "nvim-tree/nvim-web-devicons", commit = "4ec26d6" })

	-- statusline
	use({ "nvim-lualine/lualine.nvim", commit = "84ffb80" })

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", commit = "580b6c4", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", commit = "6258d50" })

	-- autocompletion
	use({ "hrsh7th/nvim-cmp", commit = "777450f" }) -- completion plugin
	use({ "hrsh7th/cmp-buffer", commit = "3022dbc" }) -- source for text in buffer
	use({ "hrsh7th/cmp-path", commit = "91ff86c" }) -- source for file system paths
	use({ "hrsh7th/cmp-cmdline", commit = "af88e70" }) -- cmdline completions
	use({ "saadparwaiz1/cmp_luasnip", commit = "1809552" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lua", commit = "f12408b" })

	-- Snippets (required by autocompletion
	use({ "L3MON4D3/LuaSnip", commit = "8d6c0a9" }) --snippet engine
	use({ "rafamadriz/friendly-snippets", commit = "b1b78a6" }) -- a bunch of snippets to use

	-- managing and installing lsp servers
	use({ "williamboman/mason.nvim", commit = "b20a4bd3" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim", commit = "7034065" })

	-- configuring lsp servers
	use({ "neovim/nvim-lspconfig", commit = "eddaef9" }) -- enable LSP
	use({ "hrsh7th/cmp-nvim-lsp", commit = "0e6b2ed" }) -- makes lsp servers appear in autocompletion
	use({ "onsails/lspkind.nvim", commit = "c68b3a0" }) -- vs-code like icons for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		commit = "c483c9b",
	}) -- enhanced lsp uis
	use({ "jose-elias-alvarez/typescript.nvim", commit = "f66d447" }) -- additional functionality for typescript server (e.g. rename file & update imports)

	-- formatting and linting
	use({ "jose-elias-alvarez/null-ls.nvim", commit = "f8ffcd7" }) -- for formatters and linters
	use({ "jayp0521/mason-null-ls.nvim", commit = "834bb5d" }) -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({ "nvim-treesitter/nvim-treesitter", commit = "eedc5198" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "0bf8fbc" })

	-- bufferline
	use({ "akinsho/bufferline.nvim", commit = "243893b", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })
	use({ "moll/vim-bbye", commit = "25ef93a" })

	-- color highlighting
	use({ "norcalli/nvim-colorizer.lua", commit = "36c610a" })

	-- auto closing
	use({ "windwp/nvim-autopairs", commit = "58985de" }) -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", commit = "cac97f3", after = "nvim-treesitter" }) -- autoclose tags

	-- lightening fast navigation
	use({ "phaazon/hop.nvim", commit = "90db1b2" })

	-- Speed up loading Lua modules in Neovim to improve startup time
	use({ "lewis6991/impatient.nvim", commit = "c90e273" })

	-- guide lines
	use({ "lukas-reineke/indent-blankline.nvim", commit = "018bd04" })

	-- git integration
	use({ "lewis6991/gitsigns.nvim", commit = "372d5cb" })

	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
