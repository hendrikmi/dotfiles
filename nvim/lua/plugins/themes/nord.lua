return {
  'shaunsingh/nord.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Example config in lua
    vim.g.nord_contrast = true                   -- Make sidebars and popup menus like nvim-tree and telescope have a different background
    vim.g.nord_borders = false                   -- Enable the border between verticaly split windows visable
    vim.g.nord_disable_background = true         -- Disable the setting of background color so that NeoVim can use your terminal background
    vim.g.set_cursorline_transparent = false     -- Set the cursorline transparent/visible
    vim.g.nord_italic = false                    -- enables/disables italics
    vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
    vim.g.nord_uniform_diff_background = true    -- enables/disables colorful backgrounds when used in diff mode
    vim.g.nord_bold = false                      -- enables/disables bold

    -- Neutralize Nord's blue-tinted whites and raise them ~10%, since neutral
    -- colors read dimmer than tinted ones at equal luminance. nord.nvim has no
    -- color option, but nord.colors reads the palette from nord.named_colors
    -- on load, so mutating it before the first require('nord') propagates.
    -- In light mode nord.nvim maps these three onto the backgrounds instead,
    -- so the same values de-tint both directions.
    local function apply_palette()
      local palette = require 'nord.named_colors'
      palette.darkest_white = '#E7E7E7' -- nord4, was #D8DEE9
      palette.darker_white = '#F0F0F0'  -- nord5, was #E5E9F0
      palette.white = '#F7F7F7'         -- nord6, was #ECEFF4
    end

    -- nord/colors.lua reads vim.o.background once, at module load time, and
    -- caches the result. Switching therefore means dropping the modules from
    -- the Lua cache and loading them again.
    local function load_nord(background)
      vim.o.background = background
      for _, m in ipairs { 'nord', 'nord.util', 'nord.theme', 'nord.colors', 'nord.named_colors' } do
        package.loaded[m] = nil
      end
      apply_palette()
      require('nord').set()

      local ok, lualine = pcall(require, 'lualine')
      if ok then
        lualine.setup { options = { theme = background == 'light' and 'nord-light' or 'nord' } }
      end
    end

    -- scripts/theme.sh writes this, so a new Neovim comes up matching the
    -- terminal it was started in.
    local state = vim.fn.expand(vim.env.XDG_STATE_HOME or '~/.local/state') .. '/theme-mode'
    local saved = vim.fn.filereadable(state) == 1 and vim.fn.readfile(state)[1] or 'dark'

    load_nord(saved == 'light' and 'light' or 'dark')

    -- Neovim paints no background of its own (nord_disable_background), so
    -- flipping only Neovim leaves dark text on a dark terminal. Drive the
    -- shared script too, so one key switches everything.
    vim.keymap.set('n', '<leader>tt', function()
      local target = vim.o.background == 'dark' and 'light' or 'dark'
      local script = vim.fn.expand '~/git/dotfiles/scripts/theme.sh'
      if vim.fn.executable(script) == 1 then
        vim.fn.system { script, target }
      end
      load_nord(target)
      vim.notify('theme: ' .. target)
    end, { desc = '[T]oggle [T]heme light/dark' })

    -- Function to set menu borders to transparent
    -- local set_menu_border_transparency = function()
    --   vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE', fg = 'NONE' })
    --   vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = 'NONE' })
    -- end

    -- Execute the function once after loading the colorscheme
    -- set_menu_border_transparency()

    local bg_transparent = true

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      vim.g.nord_disable_background = bg_transparent
      vim.cmd [[colorscheme nord]]
      -- set_menu_border_transparency()
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
