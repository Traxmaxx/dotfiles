# Fish shell configuration for NixOS
# Alternative to symlinked configuration from .config.d/fish

{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    # Nix-managed fish configuration
    # Remove comments to use these instead of symlinked config
    
    # interactiveShellInit = ''
    #   # Set fish greeting
    #   set -U fish_greeting ""
    #   
    #   # Set environment variables
    #   set -gx EDITOR nvim
    #   set -gx VISUAL nvim
    #   set -gx PAGER less
    #   
    #   # Set color scheme
    #   set -g fish_color_command blue
    #   set -g fish_color_param cyan
    #   
    #   # Add custom paths
    #   fish_add_path $HOME/.local/bin
    # '';
    
    # loginShellInit = ''
    #   # Commands to run at login
    # '';
    
    # shellAliases = {
    #   # Navigation
    #   ".." = "cd ..";
    #   "..." = "cd ../..";
    #   
    #   # Git shortcuts
    #   g = "git";
    #   gs = "git status";
    #   ga = "git add";
    #   gc = "git commit";
    #   gp = "git push";
    #   gl = "git pull";
    #   gd = "git diff";
    #   gco = "git checkout";
    #   
    #   # Listing files
    #   ls = "ls --color=auto";
    #   ll = "ls -la";
    #   la = "ls -A";
    #   
    #   # Vim
    #   vi = "nvim";
    #   vim = "nvim";
    #   
    #   # System
    #   update = "sudo nixos-rebuild switch";
    # };
    
    # plugins = [
    #   # Plugin from pkgs
    #   {
    #     name = "z";
    #     src = pkgs.fishPlugins.z.src;
    #   }
    #   # Plugin from GitHub
    #   {
    #     name = "pure";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "pure-fish";
    #       repo = "pure";
    #       rev = "v4.4.1";
    #       sha256 = "sha256-value-here";
    #     };
    #   }
    # ];
    
    # functions = {
    #   # Custom fish prompt
    #   fish_prompt = ''
    #     echo -n (set_color blue)(prompt_pwd) 
    #     echo -n (set_color green)'❯ '
    #   '';
    #   
    #   # Utility function
    #   mkcd = ''
    #     mkdir -p $argv[1] && cd $argv[1]
    #   '';
    # };
    
    # completions = {
    #   # Custom completions
    # };
  };
  
  # Additional packages for fish
  home.packages = with pkgs; [
    fishPlugins.done    # Notification when long-running commands complete
    fishPlugins.fzf-fish  # Fuzzy finder integration
    fishPlugins.forgit  # Git integration
    fzf                 # Fuzzy finder
    bat                 # Better cat
    exa                 # Better ls
  ];
}