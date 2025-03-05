
-- Zen mode configuration
local wk = require("which-key")

-- Register zen mode toggles with which-key
wk.register({
    -- Standard zen mode (<leader>zz)
    -- Maintains numbers and relative numbers
    ["<leader>zz"] = { 
        function()
            require("zen-mode").setup {
                window = {
                    width = 90,
                    options = { }
                },
            }
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = true
            ColorMyPencils()
        end,
        "Zen Mode (with numbers)"
    },
    
    -- Full zen mode (<leader>zZ)
    -- Disables line numbers and color column
    ["<leader>zZ"] = { 
        function()
            require("zen-mode").setup {
                window = {
                    width = 80,
                    options = { }
                },
            }
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
            ColorMyPencils()
        end,
        "Zen Mode (minimal)"
    }
}, { mode = "n" })
