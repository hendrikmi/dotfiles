-- Seamless <C-h/j/k/l> navigation between (Neo)vim splits and the surrounding
-- multiplexer (herdr or tmux). Herdr side: ~/git/dotfiles/herdr/nav.sh

local function nav(wincmd, dir)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. wincmd)
  if vim.api.nvim_get_current_win() ~= prev then
    return -- moved within Neovim
  end
  -- At a split edge: cross into the surrounding multiplexer.
  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= '' then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == '' then
      herdr = 'herdr'
    end
    vim.fn.system { herdr, 'pane', 'focus', '--direction', dir, '--current' }
  elseif vim.env.TMUX and vim.env.TMUX ~= '' then
    local tmux = { left = 'Left', down = 'Down', up = 'Up', right = 'Right' }
    pcall(vim.cmd, 'TmuxNavigate' .. tmux[dir])
  end
end

return {
  'christoomey/vim-tmux-navigator',
  init = function()
    -- We own <C-h/j/k/l>; only the plugin's TmuxNavigate* commands are used.
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    -- stylua: ignore start
    { '<c-h>', function() nav('h', 'left') end, desc = 'Navigate left (vim/herdr/tmux)' },
    { '<c-j>', function() nav('j', 'down') end, desc = 'Navigate down (vim/herdr/tmux)' },
    { '<c-k>', function() nav('k', 'up') end, desc = 'Navigate up (vim/herdr/tmux)' },
    { '<c-l>', function() nav('l', 'right') end, desc = 'Navigate right (vim/herdr/tmux)' },
    -- stylua: ignore end
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'Navigate previous (tmux)' },
  },
}
