local M = {}

-- Cache file for storing user-defined commands
local cache_dir = vim.fn.stdpath 'data' .. '/sql-runner'
local cache_file = cache_dir .. '/commands.json'

-- Currently selected command
M.selected_command = nil

-- Load commands from cache
local function load_commands()
  if vim.fn.filereadable(cache_file) == 0 then
    return {}
  end

  local file = io.open(cache_file, 'r')
  if not file then
    return {}
  end

  local content = file:read '*a'
  file:close()

  local ok, commands = pcall(vim.json.decode, content)
  if ok and commands then
    return commands
  end

  return {}
end

-- Save commands to cache
local function save_commands(commands)
  -- Ensure cache directory exists
  vim.fn.mkdir(cache_dir, 'p')

  local file = io.open(cache_file, 'w')
  if not file then
    vim.notify('[sql-runner] Failed to save commands', vim.log.levels.ERROR)
    return
  end

  file:write(vim.json.encode(commands))
  file:close()
end

-- Find an existing window showing the given absolute path
local function find_win_by_path(abs_path)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == abs_path then
      return win
    end
  end
  return nil
end

-- Common function to run queries with any backend
local function run_query(name, cmd)
  local outfile = vim.fn.stdpath 'data' .. '/sql-runner/sql.out'
  local abs_out = vim.fn.fnamemodify(outfile, ':p')

  -- Status: running
  vim.api.nvim_echo({ { '[sql-runner] Running ' .. name .. ' query…', 'ModeMsg' } }, false, {})
  local t0 = vim.loop.hrtime()

  -- Run the command
  local full_cmd = cmd .. ' > ' .. vim.fn.shellescape(outfile)
  local vim_cmd = string.format("'<,'>write !%s", full_cmd)

  -- Debug: show exact command being run
  -- vim.api.nvim_echo({ { '[sql-runner] Executing: ' .. vim_cmd, 'Comment' } }, false, {})

  vim.cmd(vim_cmd)

  -- Open or focus existing results split, then reload contents
  local win = find_win_by_path(abs_out)
  if win then
    vim.api.nvim_set_current_win(win)
    vim.cmd 'noautocmd edit' -- reload file without flicker
  else
    vim.cmd('split ' .. vim.fn.fnameescape(outfile))
  end

  -- Done message with timing
  local ms = math.floor((vim.loop.hrtime() - t0) / 1e6)
  vim.api.nvim_echo({ { string.format('[sql-runner] %s query done in %d ms', name, ms), 'ModeMsg' } }, false, {})
end

-- Add a new SQL command
function M.add_command()
  -- Get alias
  vim.ui.input({
    prompt = 'Enter command alias (e.g. postgres, mysql): ',
  }, function(alias)
    if not alias or alias == '' then
      return
    end

    -- Get command
    vim.ui.input({
      prompt = 'Enter command (selection will be piped to this): ',
    }, function(cmd)
      if not cmd or cmd == '' then
        return
      end

      -- Add to cached commands
      local commands = load_commands()
      commands[alias] = cmd
      save_commands(commands)

      vim.notify(string.format('[sql-runner] Added command "%s"', alias), vim.log.levels.INFO)
    end)
  end)
end

-- Remove commands
function M.remove_command()
  local commands = load_commands()

  if vim.tbl_isempty(commands) then
    vim.notify('[sql-runner] No commands to remove.', vim.log.levels.WARN)
    return
  end

  local items = {}
  for alias, cmd in pairs(commands) do
    table.insert(items, alias)
  end

  table.sort(items)

  -- Use vim.ui.select with multiple selection
  local function remove_multiple()
    vim.ui.select(items, {
      prompt = 'Select commands to remove (ESC when done):',
      format_item = function(item)
        return item
      end,
    }, function(choice)
      if choice then
        commands[choice] = nil

        -- Clear selected command if it was removed
        if M.selected_command and M.selected_command.alias == choice then
          M.selected_command = nil
        end

        -- Remove from items list
        for i, item in ipairs(items) do
          if item == choice then
            table.remove(items, i)
            break
          end
        end

        vim.notify(string.format('[sql-runner] Removed command "%s"', choice), vim.log.levels.INFO)

        -- Continue removing if there are more items
        if #items > 0 then
          vim.schedule(function()
            remove_multiple()
          end)
        else
          save_commands(commands)
          vim.notify('[sql-runner] All commands removed.', vim.log.levels.INFO)
        end
      else
        -- User pressed ESC, save and finish
        save_commands(commands)
        if vim.tbl_count(commands) == 0 then
          vim.notify('[sql-runner] All commands removed.', vim.log.levels.INFO)
        end
      end
    end)
  end

  remove_multiple()
end

-- Select a command to use
function M.select_command()
  local commands = load_commands()

  if vim.tbl_isempty(commands) then
    vim.notify('[sql-runner] No commands configured. Use :AddSqlCmd to add one.', vim.log.levels.WARN)
    return
  end

  local items = {}
  for alias, cmd in pairs(commands) do
    table.insert(items, {
      alias = alias,
      cmd = cmd,
    })
  end

  -- Sort items by alias for consistent ordering
  table.sort(items, function(a, b)
    return a.alias < b.alias
  end)

  -- Add currently selected marker
  local current_alias = M.selected_command and M.selected_command.alias or nil

  vim.ui.select(items, {
    prompt = 'Select SQL command:',
    format_item = function(item)
      local marker = (item.alias == current_alias) and ' [current]' or ''
      return item.alias .. marker
    end,
  }, function(choice)
    if choice then
      M.selected_command = choice
      vim.notify(string.format('[sql-runner] Selected "%s"', choice.alias), vim.log.levels.INFO)
    end
  end)
end

-- Run SQL with the selected command
function M.run_sql()
  if not M.selected_command then
    -- If no command selected, prompt to select one
    local commands = load_commands()

    if vim.tbl_isempty(commands) then
      vim.notify('[sql-runner] No commands configured. Use :AddSqlCmd to add one.', vim.log.levels.ERROR)
      return
    end

    local items = {}
    for alias, cmd in pairs(commands) do
      table.insert(items, {
        alias = alias,
        cmd = cmd,
      })
    end

    -- Sort items by alias for consistent ordering
    table.sort(items, function(a, b)
      return a.alias < b.alias
    end)

    vim.ui.select(items, {
      prompt = 'Select SQL command to run:',
      format_item = function(item)
        return item.alias
      end,
    }, function(choice)
      if choice then
        M.selected_command = choice
        run_query(choice.alias, choice.cmd)
      end
    end)
  else
    run_query(M.selected_command.alias, M.selected_command.cmd)
  end
end

-- Register commands
vim.api.nvim_create_user_command('AddSqlCmd', M.add_command, {})
vim.api.nvim_create_user_command('RemoveSqlCmd', M.remove_command, {})
vim.api.nvim_create_user_command('SelectSqlCmd', M.select_command, {})
vim.api.nvim_create_user_command('RunSQL', M.run_sql, { range = true })

-- Set up keymaps
vim.keymap.set('v', '<leader>pr', ':RunSQL<CR>', { silent = true, desc = 'Run SQL with selected backend' })
vim.keymap.set('n', '<leader>ps', ':SelectSqlCmd<CR>', { silent = true, desc = 'Select SQL backend' })
vim.keymap.set('n', '<leader>pa', ':AddSqlCmd<CR>', { silent = true, desc = 'Add SQL command' })
vim.keymap.set('n', '<leader>px', ':RemoveSqlCmd<CR>', { silent = true, desc = 'Remove SQL command' })

return M
