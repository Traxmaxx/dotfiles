-- Telescope configuration
local builtin = require('telescope.builtin')
local wk = require("which-key")

-- Register telescope keybindings with which-key
wk.register({
    -- File search keybindings
    ["<leader>pf"] = { builtin.find_files, "Find files" },
    ["<C-p>"] = { builtin.git_files, "Git files" },
    
    -- Text search with grep
    ["<leader>ps"] = { 
        function() 
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end,
        "Grep search"
    },
    
    -- Help tags search
    ["<leader>vh"] = { builtin.help_tags, "Help tags" },
}, { mode = "n" })
