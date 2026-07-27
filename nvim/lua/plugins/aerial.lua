-- Code outline window
return {
  'stevearc/aerial.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'AerialToggle', 'AerialNavToggle', 'AerialPrev', 'AerialNext' },
  keys = {
    { '<leader>o', '<cmd>AerialToggle!<CR>', desc = 'Toggle code outline' },
    { '<leader>on', '<cmd>AerialNavToggle<CR>', desc = 'Toggle outline nav' },
  },
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buf = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buf = bufnr })
    end,
    layout = {
      min_width = 30,
    },
  },
}
