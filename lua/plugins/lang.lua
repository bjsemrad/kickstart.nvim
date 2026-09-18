-- [[ Language-specific tooling ]]

return {
  -- Java. nvim-java patches the jdtls configuration, so it must run before the
  -- jdtls client starts. Loading on the `java` filetype keeps it off the
  -- startup path (it previously cost ~8.5ms eagerly, and pulled in
  -- spring-boot.nvim with it).
  --
  -- `vim.lsp.enable()` re-fires the FileType autocmd for already-open buffers,
  -- so enabling jdtls from here still attaches to the buffer that triggered it.
  {
    'nvim-java/nvim-java',
    ft = 'java',
    config = function()
      require('java').setup {
        jdk = {
          auto_install = false,
        },
      }
      vim.lsp.enable 'jdtls'
    end,
  },

  -- Rust. rustaceanvim configures rust-analyzer itself, so it must NOT be
  -- listed in the `servers` table in lua/plugins/lsp.lua.
  {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false, -- this plugin is already lazy
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        desc = 'rustaceanvim buffer-local keymaps',
        pattern = 'rust',
        group = vim.api.nvim_create_augroup('user-rustaceanvim', { clear = true }),
        callback = function(event)
          -- NOTE: previously this was bound once at startup against
          -- `nvim_get_current_buf()`, which meant it attached to whatever
          -- scratch buffer happened to exist then — never to a Rust file.
          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { buffer = event.buf, silent = true, desc = 'Rust hover actions' })

          vim.keymap.set('n', '<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, { buffer = event.buf, silent = true, desc = 'Rust [C]ode [A]ction' })

          -- Background `cargo watch -x build`, one job per working directory.
          --
          -- NOTE: this previously ran on every `BufEnter *.rs`, spawning a new
          -- `cargo watch` process each time you entered a Rust buffer — ten
          -- buffer switches meant ten concurrent watchers, each rebuilding and
          -- printing every line of output. The guard below keeps it to one.
          if vim.g.cargo_watch_disable or vim.fn.executable 'cargo-watch' == 0 then
            return
          end

          local cwd = vim.fn.getcwd()
          _G._cargo_watch_jobs = _G._cargo_watch_jobs or {}
          if _G._cargo_watch_jobs[cwd] then
            return
          end

          _G._cargo_watch_jobs[cwd] = vim.fn.jobstart({ 'cargo', 'watch', '-x', 'build' }, {
            cwd = cwd,
            on_exit = function()
              _G._cargo_watch_jobs[cwd] = nil
            end,
          })
        end,
      })

      -- Stop every watcher on exit so they don't outlive Neovim.
      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup('user-cargo-watch-cleanup', { clear = true }),
        callback = function()
          for _, job in pairs(_G._cargo_watch_jobs or {}) do
            pcall(vim.fn.jobstop, job)
          end
        end,
      })

      vim.api.nvim_create_user_command('CargoWatchStop', function()
        for cwd, job in pairs(_G._cargo_watch_jobs or {}) do
          pcall(vim.fn.jobstop, job)
          _G._cargo_watch_jobs[cwd] = nil
        end
        vim.g.cargo_watch_disable = true
        vim.notify('cargo watch stopped', vim.log.levels.INFO)
      end, { desc = 'Stop background cargo watch jobs' })
    end,
  },
}
