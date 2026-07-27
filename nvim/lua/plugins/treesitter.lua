-- Highlight, edit, and navigate code
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- main branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'bash',
        'cmake',
        'css',
        'dockerfile',
        'gitignore',
        'go',
        'graphql',
        'groovy',
        'html',
        'java',
        'javascript',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'sql',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      }

      local ts = require 'nvim-treesitter'
      ts.install(parsers)

      -- Highlighting and indentation are not enabled automatically on `main`.
      -- The `main` branch also dropped `auto_install`, so unknown languages are
      -- installed on demand here.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not lang then
            return
          end

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(event.buf, lang)
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            return
          end

          -- Parser missing: install it if upstream has one (replaces auto_install).
          if vim.tbl_contains(ts.get_available(), lang) and not vim.tbl_contains(ts.get_installed 'parsers', lang) then
            vim.notify('Installing treesitter parser: ' .. lang, vim.log.levels.INFO)
            ts.install(lang)
          end
        end,
      })

      -- Register additional file extensions
      vim.filetype.add { extension = { tf = 'terraform' } }
      vim.filetype.add { extension = { tfvars = 'terraform' } }
      vim.filetype.add { extension = { pipeline = 'groovy' } }
      vim.filetype.add { extension = { multibranch = 'groovy' } }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- stylua: ignore start
      vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, { desc = 'Select outer parameter' })
      vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, { desc = 'Select inner parameter' })
      vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'Select outer function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'Select inner function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'Select outer class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'Select inner class' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end, { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end, { desc = 'Next class end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Previous function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Previous class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, { desc = 'Previous function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end, { desc = 'Previous class end' })

      vim.keymap.set('n', '<leader>a', function() swap.swap_next '@parameter.inner' end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>A', function() swap.swap_previous '@parameter.inner' end, { desc = 'Swap previous parameter' })
      -- stylua: ignore end
    end,
  },
}
