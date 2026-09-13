-- =====================================================
-- Language support (C/C++, CMake, Python, Rust, TS/JS, TOML)
-- Uses LazyVim extras tuned to the installed toolchains.
-- Lightweight: only the languages requested.
-- =====================================================

return {
  -- All LSP servers use the system-installed binaries directly
  -- (`mason = false` skips mason auto-download; `enabled = false`
  -- disables servers with no local binary so startup never hits the network).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        clangd = { mason = false },
        ruff = { mason = false },
        bashls = { mason = false },
        lua_ls = { mason = false },
        rust_analyzer = { mason = false },
        neocmake = { enabled = false },
        taplo = { enabled = false },
        vtsls = { enabled = false },
        eslint = { enabled = false },
      },
    },
  },

  -- Debugging (DAP) disabled: keeps startup fully off-network and lean on
  -- 4GB RAM. Enable later by enabling these plugins + installing a
  -- debugger manually via `:Mason` (e.g. codelldb / js-debug-adapter).
  { "mfussenegger/nvim-dap", enabled = false },
  { "nvim-neotest/nvim-dap-ui", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- LSP tools are system-installed (pacman/rustup):
  -- clangd, pyright, ruff, bash-language-server, lua-language-server,
  -- shellcheck, stylua, shfmt, rust-analyzer, tree-sitter.
  -- Mason is kept only as an optional manual manager (`:Mason`); no
  -- auto-install, so startup never blocks on network downloads.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local noauto = { "codelldb", "js-debug-adapter" }
      opts.ensure_installed = vim.tbl_filter(function(t)
        return not vim.tbl_contains(noauto, t)
      end, opts.ensure_installed or {})
      return opts
    end,
  },
}
