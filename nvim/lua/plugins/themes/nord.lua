return {
  'shaunsingh/nord.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Example config in lua
    vim.g.nord_contrast = true                   -- Make sidebars and popup menus like nvim-tree and telescope have a different background
    vim.g.nord_borders = false                   -- Enable the border between verticaly split windows visable
    vim.g.nord_disable_background = true         -- Disable the setting of background color so that NeoVim can use your terminal background (dark only, see load_nord)
    vim.g.set_cursorline_transparent = false     -- Set the cursorline transparent/visible
    vim.g.nord_italic = false                    -- enables/disables italics
    vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
    vim.g.nord_uniform_diff_background = true    -- enables/disables colorful backgrounds when used in diff mode
    vim.g.nord_bold = false                      -- enables/disables bold

    -- Neutralize Nord's blue-tinted whites and raise them ~10%, since neutral
    -- colors read dimmer than tinted ones at equal luminance. nord.nvim has no
    -- color option, but nord.colors reads the palette from nord.named_colors
    -- on load, so mutating it before the first require('nord') propagates.
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
      -- would eat the contrast the accents need. Sit them slightly below
      -- Nord's own instead, which also takes the glare off.
      palette.white = '#E8E8E8'         -- nord0, the canvas
      palette.darker_white = '#DEDEDE'  -- nord1
      palette.darkest_white = '#D3D3D3' -- nord2

      -- nord.nvim reuses the Frost and Aurora accents unchanged in light
      -- mode, and they are tuned for a dark background: yellow lands at APCA
      -- 21 against this canvas, green and both teals below 40. Restage the
      -- whole scale: body text 88, accents 68, comments 57. Accents have to
      -- stay clear of the body text, or the hues stop being tellable apart.
      palette.gray = '#222833'          -- body text, was #434C5E
      palette.teal = '#4B6464'          -- nord7
      palette.off_blue = '#45656D'      -- nord8
      palette.glacier = '#4D6276'       -- nord9
      palette.blue = '#466182'          -- nord10
      palette.red = '#92484F'           -- nord11
      palette.orange = '#835344'        -- nord12
      palette.yellow = '#6D5E3E'        -- nord13
      palette.green = '#556548'         -- nord14
      palette.purple = '#70586C'        -- nord15
      palette.light_gray_bright = '#6A7894' -- comments
    end

    -- nord/colors.lua reads vim.o.background once, at module load time, and
    -- caches the result, so switching means dropping the nord modules from
    -- the Lua cache and loading them again.
    --
    -- Dark stays transparent and lets the terminal show through, exactly as
    -- before. Light has to paint its own background, otherwise it would put
    -- dark text on the terminal's dark one.
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

    load_nord 'dark'

    vim.keymap.set('n', '<leader>tt', function()
      load_nord(vim.o.background == 'dark' and 'light' or 'dark')
      vim.notify('background: ' .. vim.o.background)
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
