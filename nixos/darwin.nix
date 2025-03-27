# macOS-specific configuration using nix-darwin

{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # macOS-specific packages
  environment.systemPackages = with pkgs; [
    # Add any macOS-specific packages here
  ];

  # Homebrew integration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    # Install homebrew packages and casks
    brews = [
      # Add your brew packages here
    ];
    casks = [
      # Add your cask applications here
    ];
  };

  # macOS system settings
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      # Add more macOS settings as needed
    };
    dock = {
      autohide = true;
      # Add more dock settings as needed
    };
    finder = {
      AppleShowAllExtensions = true;
      # Add more finder settings as needed
    };
  };
}