--[[
=====================================================================
                    Brian's Neovim configuration
=====================================================================

Layout:
  init.lua               this file — leader keys, then bootstrap
  lua/config/options.lua vim options and diagnostics
  lua/config/keymaps.lua global keymaps
  lua/config/autocmds.lua autocommands
  lua/config/lazy.lua    plugin-manager bootstrap
  lua/plugins/*.lua      one file per concern, imported automatically

Run `:checkhealth` if anything looks wrong, and `:Lazy` to inspect plugins.
--]]

-- Set <space> as the leader key.
--  NOTE: must happen before plugins are loaded, or the wrong leader is used.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in your terminal.
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
