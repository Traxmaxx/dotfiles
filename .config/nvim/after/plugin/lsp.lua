-- LSP setup

-- Use recommended preset
-- lsp.preset("recommended")

-- Auto-install language servers
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  automatic_enable = true,
  ensure_installed = {
    "docker_language_server",
    "docker_compose_language_server",
    "eslint",
    "fish_lsp",
    "gh_actions_ls",
    "lua_ls",
    "marksman",
    "ts_ls",
    "rust_analyzer",
    "html",
    "cssls",
    "ruff",
    "tailwindcss",
  },
  handlers = {
    -- Default handler for all servers
    function(server_name)
      vim.lsp.config[server_name] = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      }
    end,

    -- You can add server-specific configurations here if needed
    -- ["rust_analyzer"] = function()
    --   vim.lsp.config.rust_analyzer = {
    --     capabilities = require("blink.cmp").get_lsp_capabilities(),
    --     settings = {
    --       ["rust-analyzer"] = {
    --         -- rust-analyzer specific settings
    --       }
    --     }
    --   }
    -- end,
  },
})

local wk = require("which-key")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(e)
    local bufopts = { buffer = e.buf }
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

    -- Register buffer-local keybindings with which-key
    wk.add({
      {
        { buffer = bufopts, mode = "n" },
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
        { buffer = bufopts, mode = "i" },
        {
          "<C-h>",
          function()
            vim.lsp.buf.signature_help()
          end,
          desc = "Signature Help",
        },
      },
    })
  end,
})

-- Show diagnostic text inline
vim.diagnostic.config({
  virtual_text = true,
})

-- vim.lsp.enable({
--   "lua_ls",
--   "html",
--   "cssls",
--   "lua_ls",
--   "ts_ls",
--   "tsp_server",
--   "rust_analyzer",
--   "basedpyright",
-- })

-- mason_lspconfig.setup_handlers({...})

-- require("mason-lspconfig").setup({
--   -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
--   ---@type string[]
--   ensure_installed = {
--     "ts_ls",
--     "tsp_server",
--     "rust_analyzer",
--   },
--   -- Whether installed servers should automatically be enabled via `:h vim.lsp.enable()`.
--   --
--   -- To exclude certain servers from being automatically enabled:
--   -- ```lua
--   --   automatic_enable = {
--   --     exclude = { "rust_analyzer", "ts_ls" }
--   --   }
--   -- ```
--   --
--   -- To only enable certain servers to be automatically enabled:
--   -- ```lua
--   --   automatic_enable = {
--   --     "lua_ls",
--   --     "vimls"
--   --   }
--   -- ```
--   ---@type boolean | string[] | { exclude: string[] }
--   automatic_enable = true,
-- })

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
