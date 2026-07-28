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

    -- nord.nvim has no color option, but nord.colors copies the palette out of
    -- nord.named_colors at load time, so mutating that table first propagates.
    local function apply_palette(background)
      local palette = require 'nord.named_colors'

      if background == 'dark' then
        -- Foregrounds here: de-tinted and lifted ~10%, since neutral colors
        -- read dimmer than tinted ones at matching luminance.
        palette.darkest_white = '#E7E7E7' -- nord4, was #D8DEE9
        palette.darker_white = '#F0F0F0'  -- nord5, was #E5E9F0
        palette.white = '#F7F7F7'         -- nord6, was #ECEFF4
        return
      end

      -- Light mode maps the same three onto the backgrounds, so lifting them
      -- would eat the contrast the accents need, and it glares.
      palette.white = '#E8E8E8'         -- nord0, the canvas
      palette.darker_white = '#DEDEDE'  -- nord1
      palette.darkest_white = '#D3D3D3' -- nord2

      -- The Frost and Aurora accents are reused unchanged in light mode and
      -- are tuned for a dark background: yellow lands at APCA 21 against this
      -- canvas, green and both teals below 40. Restage the scale instead:
      -- body text 88, accents 68, comments 57. Accents stay clear of the body
      -- text, or the hues stop being tellable apart.
      palette.gray = '#222833'              -- body text, was #434C5E
      palette.teal = '#4B6464'              -- nord7
      palette.off_blue = '#45656D'          -- nord8
      palette.glacier = '#4D6276'           -- nord9
      palette.blue = '#466182'              -- nord10
      palette.red = '#92484F'               -- nord11
      palette.orange = '#835344'            -- nord12
      palette.yellow = '#6D5E3E'            -- nord13
      palette.green = '#556548'             -- nord14
      palette.purple = '#70586C'            -- nord15
      palette.light_gray_bright = '#6A7894' -- comments
    end

    -- nord/colors.lua reads vim.o.background once, at module load time, so
    -- switching means dropping the nord modules from the Lua cache first.
    --
    -- Dark stays transparent over the terminal, as before. Light must paint
    -- its own background; the terminal is light too by then, but Neovim is
    -- reloaded from a signal and may briefly run ahead of it.
    local function load_nord(background)
      vim.o.background = background
      vim.g.nord_disable_background = background == 'dark'
      for _, m in ipairs { 'nord', 'nord.util', 'nord.theme', 'nord.colors', 'nord.named_colors' } do
        package.loaded[m] = nil
      end
      apply_palette(background)
      require('nord').set()

      local ok, lualine = pcall(require, 'lualine')
      if ok then
        local cfg = require('lualine.config').get_config()
        cfg.options.theme = background == 'light' and 'nord-light' or 'nord'
        lualine.setup(cfg)
      end
    end

    -- scripts/theme.sh owns the mode and signals us after writing it.
    local state = (vim.env.XDG_STATE_HOME or vim.fn.expand '~/.local/state') .. '/theme-mode'
    local function mode_from_state()
      if vim.fn.filereadable(state) ~= 1 then return 'dark' end
      return vim.fn.readfile(state)[1] == 'light' and 'light' or 'dark'
    end

    load_nord(mode_from_state())

    vim.api.nvim_create_autocmd('Signal', {
      pattern = 'SIGUSR1',
      callback = function()
        local m = mode_from_state()
        if m ~= vim.o.background then load_nord(m) end
      end,
      desc = 'follow scripts/theme.sh',
    })

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
