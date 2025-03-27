# Linux-specific configuration

{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Linux-specific packages
  environment.systemPackages = with pkgs; [
    # Add any Linux-specific packages here
  ];

  # Linux-specific settings
  services.xserver = {
    enable = true;
    # Add your desktop environment configuration here if needed
  };
}