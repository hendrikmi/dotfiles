-- Heavily inspired by daliusd's Reddit post:
-- https://www.reddit.com/r/neovim/comments/1e1txpz/some_fun_with_oilnvim_and_wezterm_for_image/

local timer
local preview_enabled = true
local preview_pane_id
local have_imgcat = vim.fn.executable 'wezterm' == 1

local function close_preview_pane()
  -- If we created a dedicated preview pane, kill it when toggling off
  if preview_pane_id then
    vim.system({ 'wezterm', 'cli', 'kill-pane', '--pane-id', tostring(preview_pane_id) }):wait()
  end
  preview_pane_id = nil
end

local function disable_preview()
  preview_enabled = false
  close_preview_pane()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function get_panes()
  local listResult = vim.system({ 'wezterm', 'cli', 'list', '--format=json' }, { text = true }):wait()
  if listResult.code ~= 0 or not listResult.stdout then
    return {}
  end
  return vim.json.decode(listResult.stdout)
end

local function get_focused_pane_id()
  local listClientsResult = vim.system({ 'wezterm', 'cli', 'list-clients', '--format=json' }, { text = true }):wait()
  if listClientsResult.code ~= 0 or not listClientsResult.stdout then
    return nil
  end
  local decoded = vim.json.decode(listClientsResult.stdout)
  if not decoded or not decoded[1] then
    return nil
  end
  return decoded[1].focused_pane_id
end

local function ensure_preview_pane()
  local focused_pane_id = get_focused_pane_id()
  if not focused_pane_id then
    return nil
  end

  local panes = get_panes()
  local current_pane
  for _, v in ipairs(panes) do
    if v.pane_id == focused_pane_id then
      current_pane = v
      break
    end
  end
  if not current_pane then
    return nil
  end

  if preview_pane_id then
    for _, v in ipairs(panes) do
      if v.pane_id == preview_pane_id then
        return preview_pane_id
      end
    end
    preview_pane_id = nil
  end

  for _, v in ipairs(panes) do
    if v.tab_id == current_pane.tab_id and v.pane_id ~= focused_pane_id then
      preview_pane_id = v.pane_id
      return preview_pane_id
    end
  end

  local splitPaneResult = vim.system({ 'wezterm', 'cli', 'split-pane', '--right' }, { text = true }):wait()
  if splitPaneResult.code ~= 0 then
    return nil
  end
  preview_pane_id = tonumber(vim.trim(splitPaneResult.stdout)) or vim.trim(splitPaneResult.stdout)

  -- Return focus to the original pane so browsing stays where it was
  os.execute('wezterm cli activate-pane --pane-id ' .. focused_pane_id)

  return preview_pane_id
end

local function toggle_preview()
  preview_enabled = not preview_enabled
  if not preview_enabled then
    disable_preview()
  end
end

local function send_to_pane(pane_id, text)
  vim.system({ 'wezterm', 'cli', 'send-text', '--no-paste', '--pane-id', tostring(pane_id), text }):wait()
end

local function update_preview()
  local oil = require 'oil'
  if vim.wo.previewwindow then
    return
  end

  local entry = oil.get_cursor_entry()
  if not preview_enabled or not entry or entry.type ~= 'file' then
    return
  end

  -- Don't update in visual mode. Visual mode implies editing not browsing,
  -- and updating the preview can cause flicker and stutter.
  local mode = vim.api.nvim_get_mode().mode
  local is_visual_mode = mode:match '^[vV]' ~= nil
  if is_visual_mode then
    return
  end

  local full_path = oil.get_current_dir() .. entry.name
  local escaped_path = vim.fn.shellescape(full_path)

  local preview_pane = ensure_preview_pane()
  if not preview_pane then
    return
  end

  local lower_full_path = full_path:lower()
  local command

  if lower_full_path:match '%.png$' or lower_full_path:match '%.jpe?g$' then
    if have_imgcat then
      command = string.format('clear; wezterm imgcat %s\n', escaped_path)
    else
      command = string.format('clear; viu %s\n', escaped_path)
    end
  elseif lower_full_path:match '%.svg$' then
    if have_imgcat then
      command = string.format('clear; gm convert %s PNG:- | wezterm imgcat -\n', escaped_path)
    else
      command = string.format('clear; gm convert %s PNG:- | viu -\n', escaped_path)
    end
  end

  if command then
    send_to_pane(preview_pane, command)
  end
end

vim.api.nvim_create_user_command('WeztermImgPreviewToggle', toggle_preview, { desc = 'Toggle image preview pane' })
vim.keymap.set('n', '<leader>wip', toggle_preview, { desc = 'Toggle wezterm image preview' })

vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufUnload' }, {
  desc = 'Close wezterm preview when leaving oil',
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'oil' then
      return
    end
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'oil' then
          return
        end
      end
      disable_preview()
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  desc = 'Preview in wezterm',
  callback = function()
    if vim.wo.previewwindow then
      return
    end

    if not preview_enabled then
      return
    end

    -- Debounce to avoid spamming the pane while moving the cursor quickly
    if timer then
      timer:again()
      return
    end
    timer = vim.loop.new_timer()
    if not timer then
      return
    end
    timer:start(10, 100, function()
      timer:stop()
      timer:close()
      timer = nil
      vim.schedule(function()
        update_preview()
      end)
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  desc = 'Refresh wezterm preview when entering oil',
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'oil' then
      return
    end
    if not preview_enabled then
      return
    end
    vim.defer_fn(update_preview, 10)
  end,
})
