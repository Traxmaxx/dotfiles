return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true, -- for hidden files
        ignored = false,
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
        }, -- for .gitignore files
      },
    },
  },
}
