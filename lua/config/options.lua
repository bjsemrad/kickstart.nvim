-- [[ Setting options ]]
--  See `:help vim.opt` and `:help option-list`

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Enable mouse mode, useful for resizing splits
opt.mouse = 'a'

-- Don't show the mode, it's already in the statusline
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Scheduled after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

opt.breakindent = true
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capitals in the term
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

-- How Neovim displays certain whitespace characters
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type
opt.inccommand = 'split'

opt.cursorline = true
opt.scrolloff = 10

-- Rounded borders for all floating windows (Neovim 0.11+)
opt.winborder = 'rounded'

-- [[ Diagnostics ]]
--  `virtual_lines` is a Neovim 0.11+ feature that replaces the old
--  `lsp_lines.nvim` plugin. Toggle it with `<leader>tD`.
vim.diagnostic.config {
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  -- Full multi-line diagnostics under the cursor; off by default since they
  -- displace code. `<leader>tD` toggles.
  virtual_lines = false,
}
