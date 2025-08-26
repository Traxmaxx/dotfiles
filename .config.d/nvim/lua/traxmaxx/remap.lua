-- Keymapping configuration
-- This file defines all custom key mappings using which-key integration
-- for better discoverability and documentation of available commands

local wk = require("which-key") -- Load which-key for organized keybinding management

-- Set the leader key to Space
-- The leader key is a prefix for many custom commands
vim.g.mapleader = " "

-- Add keybindings to which-key
-- This organizes all keybindings by mode and provides descriptions
wk.add({
    {
        mode = { "x" }, -- X mode (visual block)
        { "<leader>pp", [["_dP]], desc = "Paste without yanking deleted text" }, -- Preserves register content
    },
    {
        mode = { "v" }, -- VISUAL mode (character-wise visual mode)
        { "J", ":m '>+1<CR>gv=gv", desc = "Move selected lines down" }, -- Move selection down one line
        { "K", "<-2<CR>gv=gv", desc = "Move selected lines up" }, -- Move selection up one line
        { "<leader>w", "<cmd>w<cr>", desc = "Save file" }, -- Quick save from visual mode
    },
    {
        mode = { "n" }, -- NORMAL mode
        { "<leader>pv", vim.cmd.Ex, desc = "Toggle file explorer" }, -- Open netrw file explorer
        { "<leader>Y", [["+Y]], desc = "Yank line to system clipboard" }, -- Copy whole line to system clipboard
        { "Q", "<nop>", desc = "Disable Ex mode" }, -- Prevents accidental Ex mode activation
        { "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", desc = "Open tmux sessionizer" }, -- Project navigation
        {
            "<leader><leader>",
            function()
                vim.cmd("so") -- Source the current file
            end,
            desc = "Source current file",
        },
        {
            "<leader>vwm",
            function()
                require("vim-with-me").StartVimWithMe() -- Start collaborative editing
            end,
            desc = "Start Vim With Me",
        },
        {
            "<leader>svwm",
            function()
                require("vim-with-me").StopVimWithMe() -- Stop collaborative editing
            end,
            desc = "Stop Vim With Me",
        },
        { "J", "mzJ`z", desc = "Join lines keeping cursor position" }, -- Join lines without moving cursor
        { "<C-d>", "<C-d>zz", desc = "Scroll down and center" }, -- Scroll down with cursor centered
        { "<C-u>", "<C-u>zz", desc = "Scroll up and center" }, -- Scroll up with cursor centered
        { "n", "nzzzv", desc = "Next search result and center" }, -- Next search result with cursor centered
        { "N", "Nzzzv", desc = "Previous search result and center" }, -- Previous search result with cursor centered
    },
    {
        mode = { "n", "v" }, -- VISUAL and NORMAL mode shared mappings
        { "<leader>d", [["_d]], desc = "Delete without yanking" }, -- Delete without changing register contents
        -- { "<leader>f", [["_f]], desc = "Format file or selection" }, -- Format command
        { [["_u]], desc = "Standard undo command" }, -- Undo last change
        { "<leader>y", [["+y]], desc = "Yank to system clipboard" }, -- Copy to system clipboard
        { "<leader>f", vim.lsp.buf.format, desc = "Format with LSP" }, -- Format using LSP
        { "<C-k>", "<cmd>cnext<CR>zz", desc = "Next quickfix item" }, -- Next quickfix item, centered
        { "<C-j>", "<cmd>cprev<CR>zz", desc = "Previous quickfix item" }, -- Previous quickfix item, centered
        { "<leader>k", "<cmd>lnext<CR>zz", desc = "Next location list item" }, -- Next location list item
        { "<leader>j", "<cmd>lprev<CR>zz", desc = "Previous location list item" }, -- Previous location list item

        -- Legacy mappings commented out for reference
        -- {"<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc="LSP"},
        -- {"<leader>x", "<cmd>!chmod +x %<CR>", {silent = true}, desc="LSP"},
    },
})

-- Legacy mapping commented out, now using which-key
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
