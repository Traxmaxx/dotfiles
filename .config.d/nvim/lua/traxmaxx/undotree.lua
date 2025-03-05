-- Undotree configuration
local wk = require("which-key")

-- Register undotree toggle with which-key
wk.register({
    ["<leader>u"] = { vim.cmd.UndotreeToggle, "Toggle Undotree" }
}, { mode = "n" })
