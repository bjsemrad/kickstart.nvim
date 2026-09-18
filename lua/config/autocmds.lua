-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local augroup = function(name)
  return vim.api.nvim_create_augroup('user-' .. name, { clear = true })
end

-- Highlight when yanking (copying) text.
--  Try it with `yap` in normal mode. See `:help vim.hl.on_yank()`.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'highlight-yank',
  callback = function()
    -- `vim.highlight` was deprecated in Neovim 0.11 in favour of `vim.hl`.
    local hl = vim.hl or vim.highlight
    hl.on_yank()
  end,
})

-- Return to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position',
  group = augroup 'last-loc',
  callback = function(event)
    local exclude = { 'gitcommit', 'gitrebase' }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close throwaway windows with `q`.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close scratch windows with q',
  group = augroup 'close-with-q',
  pattern = { 'help', 'qf', 'man', 'checkhealth', 'lspinfo', 'startuptime' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
  end,
})
