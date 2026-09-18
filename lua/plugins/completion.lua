-- [[ Completion ]] blink.cmp replaces nvim-cmp and its source plugins.

return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build step is needed for regex support in snippets.
        -- Not supported in many Windows environments.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- The 'default' preset maps, among others:
      --   <c-space> open menu / open docs      <c-e> hide
      --   <c-y>     accept                     <c-n>/<c-p> select next/prev
      --   <c-b>/<c-f> scroll docs
      -- See `:help blink-cmp-config-keymap` to define your own.
      preset = 'default',

      -- Your customisations, carried over from the previous nvim-cmp setup.
      ['<A-CR>'] = { 'accept', 'fallback' },
      ['<A-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },

      -- <c-l> moves to the right of each snippet expansion location,
      -- <c-h> moves backwards.
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },

      -- Freed up: <C-k> is bound to LSP code action (including insert mode)
      -- in lua/plugins/lsp.lua. Signature help shows automatically instead.
      ['<C-k>'] = {},
    },

    appearance = {
      -- 'mono' for 'Nerd Font Mono', 'normal' for 'Nerd Font'
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- blink ships an optional Rust fuzzy matcher that downloads a prebuilt
    -- binary. On NixOS that binary won't dynamically link, so use the Lua
    -- implementation. See `:help blink-cmp-config-fuzzy`.
    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  },
}
