return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
  config = function()
    vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window (0-100)
    vim.g.lazygit_floating_window_scaling_factor = 1.0 -- scaling factor for floating window
    vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- customize lazygit popup window border characters
    vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
    vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
    vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
    vim.g.lazygit_config_file_path = {} -- table of custom config file paths

    -- Transparent background for lazygit float and border
    vim.api.nvim_set_hl(0, 'LazyGitFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'LazyGitBorder', { bg = 'NONE' })
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = '*lazygit*',
      callback = function()
        vim.schedule(function()
          vim.wo.winhighlight = 'NormalFloat:LazyGitFloat,FloatBorder:LazyGitBorder'
        end)
      end,
    })
  end,
}
