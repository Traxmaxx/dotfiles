-- Fugitive git integration
local wk = require("which-key")

-- Register Git command in which-key
wk.add({
    mode = { "n" },
    { "<leader>gs", vim.cmd.Git, desc = "Git Fugitive" },
})

-- Fugitive-specific keybindings
local Traxmaxx_Fugitive = vim.api.nvim_create_augroup("Traxmaxx_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = Traxmaxx_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}
        
        -- Using which-key for buffer-local mappings
        local wk = require("which-key")
        wk.register({
            ["<leader>gp"] = { 
                function() vim.cmd.Git('push') end, 
                "Git Push" 
            },
            ["<leader>gP"] = { 
                function() vim.cmd.Git({'pull', '--rebase'}) end,
                "Git Pull (rebase)"
            },
            ["<leader>gt"] = { 
                ":Git push -u origin ", 
                "Push with tracking" 
            }
        }, { buffer = bufnr })
    end,
})
