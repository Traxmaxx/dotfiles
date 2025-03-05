-- Harpoon configuration
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

-- Legacy keybindings (commented out)
-- vim.keymap.set("n", "<leader>a", mark.add_file)
-- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
-- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- Which-key integration for harpoon
wk.register({
    -- Create harpoon group
    ["<leader>n"] = { name = "Harpoon" },
    
    -- Mark file
    ["<leader>a"] = { 
        function() mark.add_file() end, 
        "Mark file" 
    },
    
    -- Quick menu toggle
    ["<C-e>"] = { 
        function() ui.toggle_quick_menu() end, 
        "Toggle Quick Menu" 
    },
    
    -- Navigation
    ["<C-h>"] = { 
        function() ui.nav_file(1) end, 
        "Nav File 1" 
    },
    ["<C-t>"] = { 
        function() ui.nav_file(2) end, 
        "Nav File 2" 
    },
    ["<C-n>"] = { 
        function() ui.nav_file(3) end, 
        "Nav File 3" 
    },
    ["<C-s>"] = { 
        function() ui.nav_file(4) end, 
        "Nav File 4" 
    },
}, { mode = "n" })
