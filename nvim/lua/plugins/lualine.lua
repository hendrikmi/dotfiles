-- Set lualine as statusline
return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- Adapted from: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/onedark.lua
    local colors = {
      blue = '#61afef',
      green = '#98c379',
      purple = '#c678dd',
      cyan = '#56b6c2',
      red1 = '#e06c75',
      red2 = '#be5046',
      yellow = '#e5c07b',
      fg = '#abb2bf',
      bg = '#282c34',
      gray1 = '#828997',
      gray2 = '#2c323c',
      gray3 = '#3e4452',
    }

    local onedark_theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.gray3 },
        c = { fg = colors.fg, bg = colors.gray2 },
      },
      command = { a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' } },
      insert = { a = { fg = colors.bg, bg = colors.blue, gui = 'bold' } },
      visual = { a = { fg = colors.bg, bg = colors.purple, gui = 'bold' } },
      terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' } },
      replace = { a = { fg = colors.bg, bg = colors.red1, gui = 'bold' } },
      inactive = {
        a = { fg = colors.gray1, bg = colors.bg, gui = 'bold' },
        b = { fg = colors.gray1, bg = colors.bg },
        c = { fg = colors.gray1, bg = colors.gray2 },
      },
    }

    -- Import color theme based on environment variable NVIM_THEME
    local env_var_nvim_theme = os.getenv 'NVIM_THEME' or 'nord'

    -- lualine ships its own Nord theme with the blue-tinted whites hardcoded,
    -- so it does not follow the palette override in themes/nord.lua
    local nord_theme = require 'lualine.themes.nord'
    local swap = { ['#E5E9F0'] = '#F0F0F0', ['#ECEFF4'] = '#F7F7F7' }
    for _, mode in pairs(nord_theme) do
      for _, section in pairs(mode) do
        section.fg = swap[section.fg] or section.fg
        section.bg = swap[section.bg] or section.bg
      end
    end

    -- lualine has no Nord Light at all, so build one from the light palette.
    local nord_light_theme = {
      normal = {
        a = { fg = '#E8E8E8', bg = '#537781', gui = 'bold' },
        b = { fg = '#474747', bg = '#D7D7D7' },
        c = { fg = '#6A6A6A', bg = '#DEDEDE' },
      },
      insert = { a = { fg = '#E8E8E8', bg = '#5C748C', gui = 'bold' } },
      visual = { a = { fg = '#E8E8E8', bg = '#667756', gui = 'bold' } },
      replace = { a = { fg = '#E8E8E8', bg = '#AC575F', gui = 'bold' } },
      inactive = {
        a = { fg = '#6A6A6A', bg = '#DEDEDE', gui = 'bold' },
        b = { fg = '#6A6A6A', bg = '#DEDEDE' },
        c = { fg = '#8A8A8A', bg = '#DEDEDE' },
      },
    }

    -- Define a table of themes
    local themes = {
      onedark = onedark_theme,
      nord = nord_theme,
      ['nord-light'] = nord_light_theme,
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local mode = {
      'mode',
      fmt = function(str)
        if hide_in_width() then
          return ' ' .. str
        else
          return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
        end
      end,
    }

    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
      cond = hide_in_width,
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        -- Nord follows vim.o.background so <leader>tt can flip it at runtime
        theme = (env_var_nvim_theme == 'nord' and vim.o.background == 'light')
            and themes['nord-light']
          or themes[env_var_nvim_theme],
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'neo-tree' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { filename },
        lualine_x = { diagnostics, diff, { 'encoding', cond = hide_in_width }, { 'filetype', cond = hide_in_width } },
        lualine_y = { 'location' },
        lualine_z = { 'progress' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end,
}
