-- lualine ships a Nord theme but no light counterpart, so this fills the gap.
-- Resolved by name from the runtimepath when <leader>tt switches.
-- Mode backgrounds are darkened Nord accents; Nord's own are tuned for a dark
-- background and lose too much contrast against a light one.

local colors = {
  bg = '#ECEFF4', -- nord6
  surface = '#E5E9F0', -- nord5
  surface_dim = '#D8DEE9', -- nord4
  fg = '#3B4252', -- nord1
  fg_dim = '#4C566A', -- nord3
  frost = '#5E81AC', -- nord10
  blue = '#5C748C',
  green = '#667756',
  red = '#AC575F',
  yellow = '#826F4A',
}

return {
  normal = {
    a = { fg = colors.bg, bg = colors.frost, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.surface_dim },
    c = { fg = colors.fg_dim, bg = colors.surface },
  },
  command = { a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' } },
  insert = { a = { fg = colors.bg, bg = colors.blue, gui = 'bold' } },
  visual = { a = { fg = colors.bg, bg = colors.green, gui = 'bold' } },
  replace = { a = { fg = colors.bg, bg = colors.red, gui = 'bold' } },
  inactive = {
    a = { fg = colors.fg_dim, bg = colors.surface, gui = 'bold' },
    b = { fg = colors.fg_dim, bg = colors.surface },
    c = { fg = colors.fg_dim, bg = colors.surface },
  },
}
