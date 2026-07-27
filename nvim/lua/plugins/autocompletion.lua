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
      kind_icons = {
        Text = '󰉿',
        Method = 'm',
        Function = '󰊕',
        Constructor = '',
        Field = '',
        Variable = '󰆧',
        Class = '󰌗',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰇽',
        Struct = '',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰊄',
      },
    },
    completion = {
      -- Mirrors the old nvim-cmp behaviour exactly:
      -- `completeopt = 'menu,menuone,noinsert'` plus `confirm { select = true }`
      -- means: first entry is highlighted but nothing is inserted until you
      -- accept, and <CR> takes the first entry without pressing <C-j> first.
      -- preselect = false would break that: <CR> would insert a newline.
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
}
