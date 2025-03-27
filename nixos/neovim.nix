# Neovim configuration for NixOS
# This file is not used by default, but can be imported if you want to manage
# Neovim plugins through Nix instead of using your symlinked configuration

{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    
    # If you want to manage plugins through Nix instead of your symlinked config
    # you can uncomment and configure the following:
    
    # plugins = with pkgs.vimPlugins; [
    #   # LSP
    #   nvim-lspconfig
    #   
    #   # Completion
    #   nvim-cmp
    #   cmp-nvim-lsp
    #   cmp-buffer
    #   cmp-path
    #   
    #   # Treesitter
    #   (nvim-treesitter.withPlugins (plugins: with plugins; [
    #     tree-sitter-lua
    #     tree-sitter-vim
    #     tree-sitter-bash
    #     tree-sitter-python
    #     tree-sitter-rust
    #     tree-sitter-javascript
    #     tree-sitter-typescript
    #   ]))
    #   
    #   # Telescope
    #   telescope-nvim
    #   plenary-nvim
    #   
    #   # Git
    #   vim-fugitive
    #   gitsigns-nvim
    #   
    #   # UI
    #   lualine-nvim
    #   nvim-web-devicons
    #   tokyonight-nvim
    # ];
    
    # extraConfig = ''
    #   lua << EOF
    #   -- Your Lua configuration here
    #   EOF
    # '';
  };
  
  # Additional packages needed for Neovim
  home.packages = with pkgs; [
    # LSP servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.pyright
    rust-analyzer
    
    # Formatters and linters
    nodePackages.prettier
    black # Python formatter
    rustfmt
    
    # Debug adapters
    lldb # For C/C++/Rust debugging
  ];
}