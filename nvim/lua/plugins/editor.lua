-- =====================================================
-- Editor tuning: completion, diagnostics, formatting,
-- linting, treesitter — lightweight for 4GB RAM.
-- =====================================================

return {
  -- nvim-cmp (completion) - low latency, no heavy deps
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "lazydev.nvim",
    },
  },

  -- Formatting via conform.nvim (LazyVim default)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        toml = { "taplo" },
      },
    },
  },

  -- Treesitter : only install parsers for the languages we use
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "c",
        "cpp",
        "cmake",
        "python",
        "rust",
        "toml",
        "javascript",
        "typescript",
        "tsx",
        "bash",
        "lua",
        "vim",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
      })
    end,
  },

  -- Diagnostics : fast, non-blocking
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- Lualine : statusline with diagnostics/lsp info
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
    },
  },
}
