-- Linters that are not language servers
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufWritePost' },
  config = function()
    require('lint').linters_by_ft = {
      make = { 'checkmake' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
