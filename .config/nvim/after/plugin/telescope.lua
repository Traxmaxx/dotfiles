-- Telescope configuration

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            hidden = true,
            -- the default case_mode is "smart_case"
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = false,
            follow = true,
            find_command = { "fd", "--type", "f", "--color", "never" },
        },
    },
    defaults = {
        file_ignore_patterns = {
            ".git",
            "node_modules",
            "build",
            "dist",
            "yarn.lock",
            "package-lock.json",
        },
    },
})
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
local wk = require("which-key")

-- Register telescope keybindings with which-key
wk.add({
    { mode = "n" },
    -- File search keybindings
    { "<leader>pf", builtin.find_files, desc = "Find files" },
    { "<C-p>", builtin.git_files, desc = "Git files" },

    -- Text search with grep
    {
        "<leader>ps",
        function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Grep search",
    },

    -- Help tags search
    { "<leader>vh", builtin.help_tags, desc = "Help tags" },
})
