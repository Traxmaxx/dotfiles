-- Undotree configuration
local wk = require("which-key")

-- Register undotree toggle with which-key
wk.add({
    { mode = "n" },
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
})
