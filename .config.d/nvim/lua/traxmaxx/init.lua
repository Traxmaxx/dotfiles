-- Load all configuration modules
-- Core config modules are loaded in a specific order:
-- 1. Plugin manager (packer.lua)
-- 2. Neovim settings (set.lua)
-- 3. Key mappings (remap.lua)
require("traxmaxx.packer")
require("traxmaxx.set")
require("traxmaxx.remap")

-- Development-only paths - DO NOT INCLUDE IN PRODUCTION
-- These lines are commented out to prevent loading development tools
-- in normal usage environments
-- DO NOT INCLUDE THIS
-- vim.opt.rtp:append("~/personal/streamer-tools")
-- DO NOT INCLUDE THIS

-- Create autocommand groups
-- Autocommand groups allow organizing related autocommands together
local augroup = vim.api.nvim_create_augroup
local TraxmaxxGroup = augroup('Traxmaxx', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- which-key configuration
-- Timeout settings for key sequence recognition
-- timeoutlen: Time in milliseconds to wait for a mapped sequence to complete
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Disable mouse interactions for keyboard-focused workflow
vim.o.mouse = ''

-- Utility function to reload a module during development
-- Usage: R("module.name") will reload the specified module
-- Useful for testing changes without restarting Neovim
function R(name)
    require("plenary.reload").reload_module(name)
end

-- Highlight yanked text temporarily for visual feedback
-- This creates a brief highlight effect when text is yanked (copied)
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch', -- Highlight group to use
            timeout = 40,          -- Duration of highlight in milliseconds
        })
    end,
})

-- Remove trailing whitespace on file save
-- This automatically trims trailing whitespace when saving any file
autocmd({"BufWritePre"}, {
    group = TraxmaxxGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]], -- Vim command to strip trailing whitespace
})

-- Netrw (built-in file explorer) configuration
vim.g.netrw_browse_split = 0  -- Open files in the same window
vim.g.netrw_banner = 0        -- Hide the banner at the top of netrw
vim.g.netrw_winsize = 25      -- Set the width of the netrw window to 25% of screen
