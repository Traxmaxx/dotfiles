-- Trouble plugin configuration
local wk = require("which-key")

-- Register trouble quickfix toggle with which-key
wk.register({
    ["<leader>xq"] = { 
        "<cmd>TroubleToggle quickfix<cr>", 
        "Toggle Quickfix in Trouble" 
    }
}, { mode = "n", silent = true, noremap = true })
