-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  -- Languages to install parsers for
  ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "go", "json" },

  -- Control installation behavior
  sync_install = false,
  auto_install = true,

  -- Syntax highlighting configuration
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

