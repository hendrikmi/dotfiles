return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown' },
  opts = {
    sign = { enabled = false },
    -- heading = { width = 'block' },
    completions = { lsp = { enabled = true } },
  },
}
