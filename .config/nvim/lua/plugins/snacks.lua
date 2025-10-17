return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false }, --  disable snacks scroll when animate is enabled
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
