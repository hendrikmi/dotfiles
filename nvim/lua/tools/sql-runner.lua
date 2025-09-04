local M = {}

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

-- Common function to run SQL queries
local function run_query(backend_name, cmd)
  local outfile = vim.fn.stdpath 'data' .. '/sql.out'
  local abs_out = vim.fn.fnamemodify(outfile, ':p')

  -- Status: running
  vim.api.nvim_echo({ { '[sql-runner] Running ' .. backend_name .. ' query…', 'ModeMsg' } }, false, {})
  local t0 = vim.loop.hrtime()

  -- Run the command
  vim.cmd(string.format("'<,'>write !%s", cmd .. ' > ' .. vim.fn.shellescape(outfile)))

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
  vim.api.nvim_echo({ { string.format('[sql-runner] %s query done in %d ms', backend_name, ms), 'ModeMsg' } }, false, {})
end

function M.run_postgres()
  -- Validate PostgreSQL environment
  local url = vim.fn.getenv 'POSTGRES_DB_URL'
  if not url or url == '' then
    vim.notify('[sql-runner] POSTGRES_DB_URL is not set', vim.log.levels.ERROR)
    return
  end

  run_query('PostgreSQL', 'psql "$POSTGRES_DB_URL"')
end

function M.run_athena()
  -- Check if athena-query.sh exists
  local athena_script = vim.fn.stdpath 'config' .. '/lua/tools/athena-query.sh'
  if vim.fn.filereadable(athena_script) == 0 then
    vim.notify('[sql-runner] athena-query.sh not found in config directory', vim.log.levels.ERROR)
    return
  end

  run_query('Athena', 'bash ' .. vim.fn.shellescape(athena_script))
end

-- register commands + keymaps
vim.api.nvim_create_user_command('RunSQLPostgres', M.run_postgres, { range = true })
vim.api.nvim_create_user_command('RunSQLAthena', M.run_athena, { range = true })

-- Keymaps
vim.keymap.set('v', '<leader>pp', ':RunSQLPostgres<CR>', { silent = true, desc = 'Run SQL with PostgreSQL' })
vim.keymap.set('v', '<leader>pa', ':RunSQLAthena<CR>', { silent = true, desc = 'Run SQL with Athena' })

return M
