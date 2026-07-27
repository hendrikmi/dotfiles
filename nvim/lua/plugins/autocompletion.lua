-- blink links every BlinkCmpKind<Kind> to one group, so the menu renders in a
-- single colour. Themes style nvim-cmp's CmpItem* groups instead, so map the
-- kinds onto Treesitter groups, which every theme defines.
local kind_hl = {
  Text = '@string',
  Method = '@function.method',
  Function = '@function',
  Constructor = '@constructor',
  Field = '@property',
  Property = '@property',
  Variable = '@variable',
  Reference = '@variable',
  Class = '@type',
  Interface = '@type',
  Struct = '@type',
  TypeParameter = '@type.parameter',
  Module = '@module',
  Unit = '@number',
  Value = '@number',
  Enum = '@constant',
  EnumMember = '@constant',
  Constant = '@constant',
  Keyword = '@keyword',
  Operator = '@operator',
  Event = '@constant.macro',
  Snippet = '@character.special',
  Color = '@constant',
  File = 'Directory',
  Folder = 'Directory',
}

local function apply_highlights()
  for kind, group in pairs(kind_hl) do
    vim.api.nvim_set_hl(0, 'BlinkCmpKind' .. kind, { link = group, default = false })
  end
  -- Matched characters stand out, source column stays subdued.
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { link = '@function', default = false })
  vim.api.nvim_set_hl(0, 'BlinkCmpSource', { link = 'Comment', default = false })
end

return { -- Autocompletion
  'saghen/blink.cmp',
  dependencies = {
    'saghen/blink.lib',
    'rafamadriz/friendly-snippets',
  },
  build = function()
    require('blink.cmp').build():pwait()
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'none',
      ['<C-c>'] = { 'show', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    appearance = {
      -- 'mono' for Nerd Font Mono, 'normal' for Nerd Font
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',
        Field = '󰜢',
        Variable = '󰆦',
        Property = '󰖷',
        Class = '󱡠',
        Interface = '󱡠',
        Struct = '󱡠',
        Module = '󰅩',
        Unit = '󰪚',
        Value = '󰦨',
        Enum = '󰦨',
        EnumMember = '󰦨',
        Keyword = '󰻾',
        Constant = '󰏿',
        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈔',
        Reference = '󰬲',
        Folder = '󰉋',
        Event = '󱐋',
        Operator = '󰪚',
        TypeParameter = '󰬛',
      },
    },
    completion = {
      -- Equivalent of the old `completeopt=noinsert` + `confirm { select = true }`:
      -- <CR> takes the first entry without selecting it first.
      list = { selection = { preselect = true, auto_insert = false } },
      menu = {
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
        },
      },
      documentation = { auto_show = false },
    },
    sources = {
      default = { 'lsp', 'snippets', 'buffer', 'path' },
    },
    fuzzy = { implementation = 'rust' },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    apply_highlights()
    -- Themes reset highlights when they load, so re-apply after a switch.
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('blink-cmp-kind-colors', { clear = true }),
      callback = apply_highlights,
    })
  end,
}
