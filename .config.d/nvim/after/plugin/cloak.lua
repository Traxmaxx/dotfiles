-- Cloak plugin for hiding sensitive information
require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  -- Highlight style for cloaked text
  highlight_group = "Comment",
  
  patterns = {
    {
      -- Files to apply cloaking to (environment and config files)
      file_pattern = {
          ".env*",
          "wrangler.toml",
          ".dev.vars",
      },
      -- Cloak everything after equals sign
      cloak_pattern = "=.+"
    },
  },
})

