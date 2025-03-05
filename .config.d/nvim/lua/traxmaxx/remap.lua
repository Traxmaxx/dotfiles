local wk = require("which-key")

vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

wk.add({
    {
        mode = {"x"}, -- X mode
        {"<leader>p", [["_dP]], desc = "Paste"},
    },
    {
        mode = {"i"}, -- INSER mode
        {"<leader>p", [["_dP]], desc = "Cryptic"},
        {"<C-c>", "<ESC>", desc = '<ESC>'},
    },
    {
        mode = {"v"}, -- VISUAL mode
        {"J", ":m '>+1<CR>gv=gv", desc = ":m '>+1<CR>gv=gv"},
        {"K", "<-2<CR>gv=gv", desc = "<-2<CR>gv=gv"},
        {"<leader>w", "<cmd>w<cr>", desc = "Write"},
    },
    {
        mode = {"n"}, -- NORMAL mode
        {"<leader>Y", [["+Y]], desc = "Yank"},
        {"Q", "<nop>", desc = "<nop>"},
        {"<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", desc = "New silent tmux session"},
        {"<leader><leader>",
            function()
                vim.cmd("so")
            end,
            desc = "'so' command",
        },
        {"<leader>vwm",
            function()
                require("vim-with-me").StartVimWithMe()
            end,
            desc = "Start Vim With Me"
        },
        {"<leader>svwm",
            function()
                require("vim-with-me").StopVimWithMe()
            end,
            desc = "Stop Vim With Me"
        },
        {"J", "mzJ`z", desc = "mzJ`z"},
        {"<C-d>", "<C-d>zz", desc = "<C-d>zz"},
        {"<C-u>", "<C-u>zz", desc = "<C-u>zz"},
        {"n", "nzzzv", desc = "nzzzv"},
        {"N", "Nzzzv", desc = "Nzzzv"}
    },
    {
        mode = {"n", "v"}, -- VISUAL and NORMAL mode
        {"<leader>d", [["_d]], desc = "Delete"},
        {"<leader>f", [["_f]], desc = "Format file"},
        {[["_u]], desc = "Undo"},
        {"<leader>u", desc = "Undotree"},
        {"<leader>y", [["+y]], desc = "Yank"},
        {"<leader>p", [["_dP]], desc = "Paste"},
        {"<leader>f", vim.lsp.buf.format, desc = "LSP Format"},
        {"<C-k>", "<cmd>cnext<CR>zz", desc = "<cmd>cnext<CR>zz"},
        {"<C-j>", "<cmd>cprev<CR>zz", desc = "<cmd>cprev<CR>zz"},
        {"<leader>k", "<cmd>lnext<CR>zz", desc = "<cmd>lnext<CR>zz"},
        {"<leader>j", "<cmd>lprev<CR>zz", desc = "<cmd>lprev<CR>zz"},

        -- {"<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc="LSP"},
        -- {"<leader>x", "<cmd>!chmod +x %<CR>", {silent = true}, desc="LSP"},

        {"<leader><leader>", 
            function()
                vim.cmd("so")
            end, 
            desc = "SO"
        },

    }})

    -- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
