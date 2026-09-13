-- =====================================================
-- UI : colorscheme + transparency for see-through bg
-- =====================================================

return {
  -- Active colorscheme with transparent background
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- Tokyonight: enable transparent bg so wallpaper shows through
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Lualine: match to transparent style
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "tokyonight",
      },
    },
  },
}
