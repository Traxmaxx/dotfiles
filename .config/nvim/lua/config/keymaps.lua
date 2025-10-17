-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local function has_words_before()
--   local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
--
-- -- keymap = {
--   preset = "enter",
--   ["<C-y>"] = { "select_and_accept" },
--   ["<Tab>"] = {
--     "select_next",
--     "snippet_forward",
--     function(cmp)
--       if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
--         return cmp.show()
--       end
--     end,
--     "fallback",
--   },
--   ["<S-Tab>"] = {
--     "select_prev",
--     "snippet_backward",
--     function(cmp)
--       if vim.api.nvim_get_mode().mode == "c" then
--         return cmp.show()
--       end
--     end,
--     "fallback",
--   },
--   completion = {
--     list = {
--       selection = { preselect = false, auto_insert = true },
--     },
--   },
-- }

vim.keymap.set("n", "<C-h>", ":KittyNavigateLeft<CR>", { noremap = true, desc = "Kitty Navigate Left" })
vim.keymap.set("n", "<C-j>", ":KittyNavigateDown<CR>", { noremap = true, desc = "Kitty Navigate Down" })
vim.keymap.set("n", "<C-k>", ":KittyNavigateUp<CR>", { noremap = true, desc = "Kitty Navigate Up" })
vim.keymap.set("n", "<C-l>", ":KittyNavigateRight<CR>", { noremap = true, desc = "Kitty Navigate Right" })
vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true, desc = "Paste replace and keep" })
