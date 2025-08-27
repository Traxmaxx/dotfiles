-- LSP setup

-- Use recommended preset
-- lsp.preset("recommended")

-- Auto-install language servers
require("mason").setup()
require("mason-lspconfig").setup({
  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
  ---@type string[]
  ensure_installed = {
    "ts_ls",
    "tsp_server",
    "rust_analyzer",
  },
  -- Whether installed servers should automatically be enabled via `:h vim.lsp.enable()`.
  --
  -- To exclude certain servers from being automatically enabled:
  -- ```lua
  --   automatic_enable = {
  --     exclude = { "rust_analyzer", "ts_ls" }
  --   }
  -- ```
  --
  -- To only enable certain servers to be automatically enabled:
  -- ```lua
  --   automatic_enable = {
  --     "lua_ls",
  --     "vimls"
  --   }
  -- ```
  ---@type boolean | string[] | { exclude: string[] }
  automatic_enable = true,
})

-- local lspconfig = require("mason-lspconfig")
-- vim.lsp.config(
--   " *",
--   ---@type vim.lsp.Config
--   {
--     capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig.default_capabilities),
--     on_attach = lspconfig.on_attach,
--     root_markers = { "•git" },
--   }
-- )

-- Fix Undefined global 'vim'
-- lsp.nvim_workspace()

-- -- -- Completion configuration
-- -- local cmp = require("cmp")
-- -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- -- local cmp_mappings = lsp.defaults.cmp_mappings({
-- --   ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
-- --   ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
-- --   ["<C-y>"] = cmp.mapping.confirm({ select = true }),
-- --   ["<C-Space>"] = cmp.mapping.complete(),
-- -- })

-- -- -- Disable tab for completion
-- -- cmp_mappings["<Tab>"] = nil
-- -- cmp_mappings["<S-Tab>"] = nil

-- -- -- Setup nvim-cmp
-- -- lsp.setup_nvim_cmp({
-- --   mapping = cmp_mappings,
-- -- })

-- -- Configure LSP preferences
-- lsp.set_preferences({
--   suggest_lsp_servers = false,
--   manage_nvim_cmp = false,
--   sign_icons = {
--     error = "E",
--     warn = "W",
--     hint = "H",
--     info = "I",
--   }
-- })

-- -- LSP keybindings using which-key
-- lsp.on_attach(function(client, bufnr)
--   -- Register buffer-local keybindings with which-key
--   wk.add({
--     {
--       { buffer = bufnr, mode = "n" },
--       {
--         "gd",
--         function()
--           vim.lsp.buf.definition()
--         end,
--         desc = "Go to Definition",
--       },
--       {
--         "K",
--         function()
--           vim.lsp.buf.hover()
--         end,
--         desc = "Show Hover",
--       },
--       {
--         "<leader>vws",
--         function()
--           vim.lsp.buf.workspace_symbol()
--         end,
--         desc = "Workspace Symbols",
--       },
--       {
--         "<leader>vd",
--         function()
--           vim.diagnostic.open_float()
--         end,
--         desc = "Show Diagnostics",
--       },
--       {
--         "[d",
--         function()
--           vim.diagnostic.goto_next()
--         end,
--         desc = "Next Diagnostic",
--       },
--       {
--         "]d",
--         function()
--           vim.diagnostic.goto_prev()
--         end,
--         desc = "Previous Diagnostic",
--       },
--       {
--         "<leader>vca",
--         function()
--           vim.lsp.buf.code_action()
--         end,
--         desc = "Code Action",
--       },
--       {
--         "<leader>vrr",
--         function()
--           vim.lsp.buf.references()
--         end,
--         desc = "References",
--       },
--       {
--         "<leader>vrn",
--         function()
--           vim.lsp.buf.rename()
--         end,
--         desc = "Rename",
--       },
--     },
--   })

--   -- Insert mode keybindings
--   wk.add({
--     {
--       { buffer = bufnr, mode = "i" },
--       {
--         "<C-h>",
--         function()
--           vim.lsp.buf.signature_help()
--         end,
--         desc = "Signature Help",
--       },
--     },
--   })
-- end)

-- Initialize LSP
-- lsp.setup()

-- Show diagnostic text inline
vim.diagnostic.config({
  virtual_text = true,
})
