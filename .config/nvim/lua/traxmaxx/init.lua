-- Load all configuration modules
-- Core config modules are loaded in a specific order:
-- 1. Plugin manager (packer.lua)
-- 2. Neovim settings (set.lua)
-- 3. Key mappings (remap.lua)
require("traxmaxx.packer")
require("traxmaxx.set")
require("traxmaxx.remap")

-- Create autocommand groups
-- Autocommand groups allow organizing related autocommands together
local augroup = vim.api.nvim_create_augroup
local TraxmaxxGroup = augroup("Traxmaxx", {})
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

local function open_nvim_tree(data)
  local is_dir  = vim.fn.isdirectory(data.file) == 1
  local is_file = vim.fn.filereadable(data.file) == 1
  local bt      = vim.bo[data.buf].buftype
  local ft      = vim.bo[data.buf].filetype

  -- skip special buffers (commit, help, etc.), EXCEPT oil
  if bt ~= "" and ft ~= "oil" then
    return
  end

  if is_dir then
    vim.cmd.cd(data.file)
    require("nvim-tree.api").tree.open()
    return
  end

  if is_file then
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
    return
  end

  -- explicit oil case (for `nvim .`)
  if ft == "oil" then
    require("nvim-tree.api").tree.open()
    vim.cmd.wincmd("p") -- go back to oil window
  end
end

-- Define a function to close the buffer but stay in window
local function close_buffer()
  local prev = vim.fn.bufnr("#")
  vim.cmd("bd")
  if prev > 0 and vim.fn.buflisted(prev) == 1 then
    vim.cmd("b " .. prev)
  end
end

vim.keymap.set("n", "<leader>q", close_buffer, { noremap = true, silent = true, desc = "Close buffer and go to previous" })
-- which-key configuration
-- Timeout settings for key sequence recognition
-- timeoutlen: Time in milliseconds to wait for a mapped sequence to complete

-- automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Utility function to reload a module during development
-- Usage: R("module.name") will reload the specified module
-- Useful for testing changes without restarting Neovim
function R(name)
    require("plenary.reload").reload_module(name)
end

-- Highlight yanked text temporarily for visual feedback
-- This creates a brief highlight effect when text is yanked (copied)
autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch", -- Highlight group to use
            timeout = 40, -- Duration of highlight in milliseconds
        })
    end,
})

-- Remove trailing whitespace on file save
-- This automatically trims trailing whitespace when saving any file
autocmd({ "BufWritePre" }, {
    group = TraxmaxxGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]], -- Vim command to strip trailing whitespace
})

-- The VimEnter event should be used for the startup functionality:
-- nvim-tree setup will have been called and other plugins will have started. It's the best time for you to define the behaviour you desire.
autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Netrw (built-in file explorer) configuration
vim.g.netrw_browse_split = 0 -- Open files in the same window
vim.g.netrw_banner = 0 -- Hide the banner at the top of netrw
vim.g.netrw_winsize = 25 -- Set the width of the netrw window to 25% of screen
