-- [[ Formatting ]]

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages without a well
      -- standardised coding style.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can run multiple formatters sequentially:
      --   python = { 'isort', 'black' },
      -- or use 'stop_after_first' to run the first available one:
      --   javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
