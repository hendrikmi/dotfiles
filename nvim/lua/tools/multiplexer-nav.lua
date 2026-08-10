-- Seamless <C-h/j/k/l> navigation between (Neo)vim splits and the surrounding
-- multiplexer (herdr or tmux). Herdr side: ~/.config/herdr/nav.sh

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
    local tmux = { left = 'L', down = 'D', up = 'U', right = 'R' }
    vim.fn.system { 'tmux', 'select-pane', '-' .. tmux[dir] }
  end
end

-- stylua: ignore start
vim.keymap.set('n', '<c-h>', function() nav('h', 'left') end, { silent = true, desc = 'Navigate left (vim/herdr/tmux)' })
vim.keymap.set('n', '<c-j>', function() nav('j', 'down') end, { silent = true, desc = 'Navigate down (vim/herdr/tmux)' })
vim.keymap.set('n', '<c-k>', function() nav('k', 'up') end, { silent = true, desc = 'Navigate up (vim/herdr/tmux)' })
vim.keymap.set('n', '<c-l>', function() nav('l', 'right') end, { silent = true, desc = 'Navigate right (vim/herdr/tmux)' })
-- stylua: ignore end
