# Home-manager configuration for user environment

{ config, pkgs, lib, ... }:

# To use the Nix-managed configurations instead of symlinked ones,
# uncomment the following imports and comment out the corresponding sections below
# imports = [
#   ./neovim.nix
#   ./tmux.nix
#   ./fish.nix
# ];

let
  PROJECT_ROOT = builtins.toString ./.;
  configDirSource = "${PROJECT_ROOT}/.config.d";
  
  # Function to recursively read a directory and create a set of file paths
  readDirRecursive = dir:
    let
      # Read the directory contents
      dirContents = builtins.readDir dir;
      # Handle files and directories differently
      handleEntry = name: type: 
        let 
          path = "${dir}/${name}";
        in
        if type == "directory" then 
          # Recursively process directories
          readDirRecursive path
        else 
          # Return file paths
          { "${path}" = path; };
      # Process each entry in the directory
      entries = lib.mapAttrs handleEntry dirContents;
      # Merge all entries into a single set
      merged = lib.foldl (a: b: a // b) {} (builtins.attrValues entries);
    in
      merged;

  # List of files/directories to exclude from symlinking
  excludeList = [
    "install.sh"
    "installv2.sh"
    "Brewfile"
    "README.md"
    ".gitignore"
    ".git"
    ".gitmodules"
    ".DS_Store"
    "nixos"
  ];
  
  # Function to check if a file should be excluded
  shouldExclude = path:
    let
      basename = builtins.baseNameOf path;
    in
      builtins.elem basename excludeList;
  
  # Get all files from the .config.d directory
  allFiles = readDirRecursive configDirSource;
  
  # Filter out excluded files
  filteredFiles = lib.filterAttrs (path: _: !(shouldExclude path)) allFiles;
  
  # Function to transform source paths to target paths
  # This replaces .config.d with .config in the path
  transformPath = path:
    let
      relativePath = lib.removePrefix configDirSource path;
    in
      "${config.home.homeDirectory}/.config${relativePath}";
  
  # Create a set of source to target mappings
  fileLinks = lib.mapAttrs' (path: _: {
    name = transformPath path;
    value = { source = path; };
  }) filteredFiles;
in
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install in user environment
  home.packages = with pkgs; [
    # Add user-specific packages here
  ];

  # Create symlinks for all files in .config.d
  # This includes:
  # - Neovim configuration in .config.d/nvim
  # - tmux configuration in .config.d/tmux
  # - fish configuration in .config.d/fish
  # We're using the symlinked configurations instead of Home Manager's module configurations
  home.file = fileLinks // {
    # Special case for tmux.conf which goes to ~/.tmux.conf
    ".tmux.conf".source = "${configDirSource}/tmux/tmux.conf";
  };
  
  # Create undo directory for Neovim
  home.file.".vim/undodir/.keep".text = "";

  # Fish shell configuration
  programs.fish = {
    enable = true;
    # Don't use Home Manager's configuration system for fish
    # Instead, we'll use the symlinked configuration from .config.d/fish
    # This is done by setting enable to true but not specifying any plugins or shellInit
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # Don't use Home Manager's configuration system for Neovim
    # Instead, we'll use the symlinked configuration from .config.d/nvim
    # This is done by setting defaultEditor to true but not specifying any plugins or config
    defaultEditor = true;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    # Don't use Home Manager's configuration system for tmux
    # Instead, we'll use the symlinked configuration from .config.d/tmux
    # This is done by setting enable to true but not specifying any plugins or extraConfig
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "23.11"; # Change this to match your nixos version
}