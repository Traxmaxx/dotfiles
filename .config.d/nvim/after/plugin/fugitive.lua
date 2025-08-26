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
        local opts = { buffer = bufnr, remap = false }

        -- Using which-key for buffer-local mappings
        local wk = require("which-key")
        wk.add({
            {
                { buffer = bufnr },
                {
                    "<leader>gp",
                    function()
                        vim.cmd.Git("push")
                    end,
                    desc = "Git Push",
                },
                {
                    "<leader>gP",
                    function()
                        vim.cmd.Git({ "pull", "--rebase" })
                    end,
                    desc = "Git Pull (rebase)",
                },
                {
                    "<leader>gt",
                    ":Git push -u origin ",
                    desc = "Push with tracking",
                },
            },
        })
    end,
})
