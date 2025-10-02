-- Plugin Management with Packer
-- This file manages all Neovim plugins using Packer
-- It can be loaded by calling `lua require('packer')` from your init.vim

-- Automatically install Packer if not already installed
-- This function checks if Packer exists and installs it if missing
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

-- Run the Packer installation check
local packer_bootstrap = ensure_packer()

-- Load Packer (only required if packer is configured as `opt`)
vim.cmd.packadd("packer.nvim")

-- Initialize Packer and define plugins
return require("packer").startup(function(use)
	-- Core: Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	})

	-- Telescope: Fuzzy finder for files, buffers, and more
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim" } }, -- Plenary: Lua utility functions
	})

	-- Tab bar of open buffers
	use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })

	-- Tokyo Night: Modern dark theme with clean design and good contrast
	use({
		"folke/tokyonight.nvim",
		as = "tokyonight",
		config = function()
			vim.cmd("colorscheme tokyonight-night") -- Set colorscheme on load
		end,
	})

	-- Trouble: Diagnostics, references, and quickfix list in a pretty list
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = true, -- Disable icons for minimal UI
				-- Default settings are used, can be customized below
				-- refer to the configuration section in Trouble documentation
			})
		end,
	})

	-- Which-Key: Displays keybindings in popup and enhances discoverability
	use({ "folke/which-key.nvim" })

	use({ "nvim-treesitter/nvim-treesitter-context" }) -- Show code context while scrolling
	use({
		"nvim-treesitter/nvim-treesitter", -- Treesitter: Advanced syntax highlighting and code navigation
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter-context",
		},
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	-- Icons and UI enhancements
	-- Both icon packages are for which-key and other UI elements
	use("nvim-tree/nvim-web-devicons") -- Icons from popular icon fonts
	use("echasnovski/mini.icons") -- Minimalistic icon set

	-- ThePrimeagen's Productivity Tools
	use("nvim-lua/plenary.nvim") -- don't forget to add this one if you don't have it yet!
	use({
		"ThePrimeagen/harpoon", -- Quick file navigation and marking
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"ThePrimeagen/refactoring.nvim", -- Refactoring utilities
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})
	use("mbbill/undotree") -- Visual undo history
	use("tpope/vim-fugitive") -- Git integration
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	}) -- Left file tree

	-- LSP
	use({
		"williamboman/mason.nvim",
		requires = {
			{ "williamboman/mason-lspconfig.nvim" },
			-- Snippets
			{ "L3MON4D3/LuaSnip" }, -- Snippet engine
			{ "rafamadriz/friendly-snippets" }, -- Collection of snippets
		},
	})
	-- Autocompletion
	use({
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		requires = { "rafamadriz/friendly-snippets", "onsails/lspkind.nvim" },
		tag = "v1.*",
	})

	use({
		"onsails/lspkind.nvim",
	})

	-- Formatters
	use({
		"stevearc/conform.nvim",
	})

	-- linters
	use({
		"mfussenegger/nvim-lint",
	})

	-- Additional Utilities
	use("folke/zen-mode.nvim") -- Distraction-free coding mode
	-- use("github/copilot.vim") -- GitHub Copilot AI code suggestions
	use("eandrju/cellular-automaton.nvim") -- Fun visualizations based on cellular automata
	use("laytan/cloak.nvim") -- Hide sensitive information in files
	use("luckasRanarison/tailwind-tools.nvim") -- TailwindCSS autocompletion
end)
