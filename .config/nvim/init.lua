-- Main Neovim initialization file
-- This loads the personal configuration module 'traxmaxx' that contains all customizations

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("traxmaxx")
