return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      transparent = true,
      lualine_bold = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
