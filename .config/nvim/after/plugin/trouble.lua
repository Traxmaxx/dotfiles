-- Trouble plugin configuration
local wk = require("which-key")

-- Register trouble quickfix toggle with which-key
wk.add({
    { mode = "n", silent = true, noremap = true },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Toggle Quickfix in Trouble" },
})
