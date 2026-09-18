-- [[ Treesitter ]] the `main` branch is the 2025 rewrite: it drops the old
--  module system (`nvim-treesitter.configs`, `ensure_installed`, `highlight`)
--  in favour of `vim.treesitter.start()` plus an explicit install list.

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}

    ts.install {
      'bash',
      'c',
      'cpp',
      'diff',
      'go',
      'html',
      'java',
      'kotlin',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'nix',
      'qmljs',
      'query',
      'rego',
      'sql',
      'vim',
      'vimdoc',
    }

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Start treesitter highlighting and indentation',
      group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if not lang then
          return
        end

        local function start()
          if not vim.api.nvim_buf_is_valid(event.buf) then
            return
          end
          vim.treesitter.start(event.buf, lang)
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if vim.tbl_contains(ts.get_installed(), lang) then
          start()
        elseif vim.tbl_contains(require('nvim-treesitter.config').get_available(), lang) then
          -- Equivalent of the old `auto_install`.
          ts.install(lang):await(start)
        end
      end,
    })
  end,
}
