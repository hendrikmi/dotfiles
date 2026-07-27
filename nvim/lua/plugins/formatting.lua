-- Format on save
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      -- ruff_fix runs `ruff check --fix`, ruff_format runs `ruff format`.
      -- This mirrors the previous none-ls setup, which used the same two steps.
      python = { 'ruff_fix', 'ruff_format' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      hcl = { 'terraform_fmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    formatters = {
      shfmt = {
        append_args = { '-i', '4' },
      },
      -- `--extend-select I` adds import sorting on top of whatever the project
      -- already selects, instead of replacing the selection. This is what the
      -- old none-ls source did; conform's `ruff_organize_imports` uses
      -- `--select=I001`, which would sort imports but stop fixing anything else
      -- (unused imports would no longer be removed).
      ruff_fix = {
        append_args = { '--extend-select', 'I' },
      },
    },
  },
}
