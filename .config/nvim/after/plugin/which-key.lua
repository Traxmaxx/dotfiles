local wk = require("which-key")

wk.setup({
  preset = "helix",
  expand = 2,
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
    presets = {
      g = true,
      motions = true,
      nav = true,
      operators = true,
      text_objects = true,
      windows = true,
      z = true,
    },
  },
})

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
    mode = "n",
    {
      "<leader>ff",
      function()
        require("oil").open(vim.fn.expand("%:p:h"))
      end,
      desc = "Open Oil (file dir)",
    },

    {
      "<leader>fv",
      function()
        require("oil").open()
      end,
      desc = "Open Oil",
    },
  },
  {
    mode = { "n" }, -- NORMAL mode
    -- { "<leader>pv", vim.cmd.Ex, desc = "Toggle file explorer" }, -- Open netrw file explorer
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
    { "g?", desc = "Oil Help" },
    { "<C-c>", desc = "Oil Close" },
    { "-", desc = "Oil Parent" },
    { "_", desc = "actions.open_cwd" },
    { "`", desc = "actions.cd" },
    { "~", desc = "actions.cd" },
    { "gs", desc = "actions.change_sort" },
    { "g.", desc = "actions.toggle_hidden" },
    { "g\\", desc = "actions.toggle_trash" },
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
  },
  {
    { "<CR>", desc = "Oil Select" },
    { "<C-s>", desc = "actions.select" },
    { "<C-h>", desc = "actions.select" },
    { "<C-t>", desc = "actions.select" },
    { "<C-p>", desc = "actions.preview" },
    { "<C-l>", desc = "actions.refresh" },
    { "gx", desc = "actions.open_external" },
    { "gD", desc = "Toggle file detail view" },
  },
})

-- Legacy mappings commented out for reference
-- {"<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc="LSP"},
-- {"<leader>x", "<cmd>!chmod +x %<CR>", {silent = true}, desc="LSP"},
