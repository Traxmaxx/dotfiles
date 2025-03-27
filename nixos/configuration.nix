# Main NixOS configuration file

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "UTC"; # Change to your timezone

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account
  users.users.youruser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable 'sudo' for the user
    shell = pkgs.fish;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible. Change this only after NixOS release notes say you should.
  system.stateVersion = "23.11"; # Change this to match your nixos version
}