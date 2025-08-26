-- LSP setup
local lsp = require("lsp-zero")
local wk = require("which-key")

-- Use recommended preset
lsp.preset("recommended")

-- Auto-install language servers
lsp.ensure_installed({
  "ts_ls",
  "tsp_server",
  "rust_analyzer",
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

-- Completion configuration
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

-- Disable tab for completion
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

-- Setup nvim-cmp
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
})

-- Configure LSP preferences
lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
})

-- LSP keybindings using which-key
lsp.on_attach(function(client, bufnr)
  -- Register buffer-local keybindings with which-key
  wk.add({
    {
      { buffer = bufnr, mode = "n" },
      {
        "gd",
        function()
          vim.lsp.buf.definition()
        end,
        desc = "Go to Definition",
      },
      {
        "K",
        function()
          vim.lsp.buf.hover()
        end,
        desc = "Show Hover",
      },
      {
        "<leader>vws",
        function()
          vim.lsp.buf.workspace_symbol()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>vd",
        function()
          vim.diagnostic.open_float()
        end,
        desc = "Show Diagnostics",
      },
      {
        "[d",
        function()
          vim.diagnostic.goto_next()
        end,
        desc = "Next Diagnostic",
      },
      {
        "]d",
        function()
          vim.diagnostic.goto_prev()
        end,
        desc = "Previous Diagnostic",
      },
      {
        "<leader>vca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "Code Action",
      },
      {
        "<leader>vrr",
        function()
          vim.lsp.buf.references()
        end,
        desc = "References",
      },
      {
        "<leader>vrn",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "Rename",
      },
    },
  })

  -- Insert mode keybindings
  wk.add({
    {
      { buffer = bufnr, mode = "i" },
      {
        "<C-h>",
        function()
          vim.lsp.buf.signature_help()
        end,
        desc = "Signature Help",
      },
    },
  })
end)

-- Initialize LSP
lsp.setup()

-- Show diagnostic text inline
vim.diagnostic.config({
  virtual_text = true,
})
