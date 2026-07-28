-- Set lualine as statusline
return {
  'nvim-lualine/lualine.nvim',
  config = function()
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
        theme = nord_theme,
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
