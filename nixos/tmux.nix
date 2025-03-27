# Tmux configuration for NixOS
# Alternative to symlinked configuration from .config.d/tmux

{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";  # Set prefix to Ctrl-a
    terminal = "screen-256color";
    clock24 = true;  # Use 24-hour clock
    
    # Nix-managed tmux configuration
    # Remove comments to use these instead of symlinked config
    
    # plugins = with pkgs.tmuxPlugins; [
    #   sensible    # Sensible defaults
    #   yank        # Copy to system clipboard
    #   resurrect   # Save and restore sessions
    #   continuum   # Auto-save sessions
    #   vim-tmux-navigator  # Navigate between vim and tmux panes
    # ];
    
    # extraConfig = ''
    #   # Status bar configuration
    #   set -g status-style bg=black,fg=white
    #   set -g window-status-current-style bg=white,fg=black,bold
    #   
    #   # Enable mouse support
    #   set -g mouse on
    #   
    #   # Start window numbering at 1
    #   set -g base-index 1
    #   set -g pane-base-index 1
    #   
    #   # Automatically renumber windows
    #   set -g renumber-windows on
    #   
    #   # Increase scrollback buffer size
    #   set -g history-limit 50000
    #   
    #   # Customize the status line
    #   set -g status-left "#[fg=green]#S #[fg=yellow]#I #[fg=cyan]#P"
    #   set -g status-right "#[fg=cyan]%d %b %R"
    # '';
  };
  
  # Additional packages needed for tmux
  home.packages = with pkgs; [
    xclip  # For clipboard support
  ];
}