-- Plugin Management with Packer
-- This file manages all Neovim plugins using Packer
-- It can be loaded by calling `lua require('packer')` from your init.vim

-- Automatically install Packer if not already installed
-- This function checks if Packer exists and installs it if missing
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

-- Run the Packer installation check
local packer_bootstrap = ensure_packer()

-- Load Packer (only required if packer is configured as `opt`)
vim.cmd.packadd('packer.nvim')

-- Initialize Packer and define plugins
return require('packer').startup(function(use)
  -- Core: Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope: Fuzzy finder for files, buffers, and more
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} } -- Plenary: Lua utility functions
  }

  -- Tokyo Night: Modern dark theme with clean design and good contrast
  use {
	  'folke/tokyonight.nvim',
	  as = 'tokyonight',
	  config = function()
		  vim.cmd('colorscheme tokyonight-night') -- Set colorscheme on load
	  end
  }

  -- Trouble: Diagnostics, references, and quickfix list in a pretty list
  use {
    'folke/trouble.nvim',
    config = function()
        require('trouble').setup {
            icons = false, -- Disable icons for minimal UI
            -- Default settings are used, can be customized below
            -- refer to the configuration section in Trouble documentation
        }
    end,
  }

  -- Which-Key: Displays keybindings in popup and enhances discoverability
  use {
    'folke/which-key.nvim'
  }


  -- Treesitter: Advanced syntax highlighting and code navigation
  use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
  }

  -- Icons and UI enhancements
  -- Both icon packages are for which-key and other UI elements
  use('nvim-tree/nvim-web-devicons')  -- Icons from popular icon fonts
  use('echasnovski/mini.icons')       -- Minimalistic icon set
  use('nvim-treesitter/playground')   -- Treesitter debugging and development
  
  -- ThePrimeagen's Productivity Tools
  use('theprimeagen/harpoon')          -- Quick file navigation and marking
  use('theprimeagen/refactoring.nvim') -- Refactoring utilities
  use('mbbill/undotree')               -- Visual undo history
  use('tpope/vim-fugitive')            -- Git integration
  use('nvim-treesitter/nvim-treesitter-context'); -- Show code context while scrolling

  -- LSP Zero: Full Language Server Protocol setup with minimal configuration
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},       -- Core LSP client configuration
		  {'williamboman/mason.nvim'},      -- Package manager for LSP servers
		  {'williamboman/mason-lspconfig.nvim'}, -- Bridge between Mason and lspconfig

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},         -- Completion engine
		  {'hrsh7th/cmp-buffer'},       -- Buffer completions
		  {'hrsh7th/cmp-path'},         -- Path completions
		  {'saadparwaiz1/cmp_luasnip'}, -- Snippet completions
		  {'hrsh7th/cmp-nvim-lsp'},     -- LSP completions
		  {'hrsh7th/cmp-nvim-lua'},     -- Lua completions for Neovim API

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},             -- Snippet engine
		  {'rafamadriz/friendly-snippets'}, -- Collection of snippets
	  }
  }

  -- Additional Utilities
  use("folke/zen-mode.nvim")           -- Distraction-free coding mode
  use("github/copilot.vim")            -- GitHub Copilot AI code suggestions
  use("eandrju/cellular-automaton.nvim") -- Fun visualizations based on cellular automata
  use("laytan/cloak.nvim")             -- Hide sensitive information in files

end)

