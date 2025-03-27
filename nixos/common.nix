# Common configuration for all systems

{ config, pkgs, ... }:

{
  # Common packages for all systems
  environment.systemPackages = with pkgs; [
    # Shell and terminal utilities
    fish
    tmux
    neovim
    bat
    fd
    fzf
    jq
    curl
    wget
    git
    ripgrep
    
    # Development tools
    nodejs
    python3
    python3Packages.pynvim
    ruby
    
    # Neovim dependencies
    tree-sitter
    gcc  # For treesitter compilation
    gnumake
    unzip  # For plugin installation
  ];

  # Enable fish shell
  programs.fish.enable = true;

  # Set fish as default shell for the user
  users.defaultUserShell = pkgs.fish;
}