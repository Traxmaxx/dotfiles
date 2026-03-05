return {
  dir = "~/Sites/private/openclaude.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            openclaude_send = function(...)
              return require("openclaude").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "openclaude_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type openclaude.Opts
    vim.g.openclaude_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("openclaude").ask("@this: ", { submit = true })
    end, { desc = "Ask Claude…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("openclaude").select()
    end, { desc = "Execute Claude action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("openclaude").toggle()
    end, { desc = "Toggle Claude" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("openclaude").operator("@this ")
    end, { desc = "Add range to Claude", expr = true })
    vim.keymap.set("n", "goo", function()
      return require("openclaude").operator("@this ") .. "_"
    end, { desc = "Add line to Claude", expr = true })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
