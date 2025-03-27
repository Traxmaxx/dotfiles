{
  description = "NixOS and Darwin system configurations";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home manager for user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Darwin support
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: {
    # NixOS configuration
    nixosConfigurations = {
      # Replace 'hostname' with your actual hostname
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Change to your system architecture if needed
        modules = [
          ./configuration.nix
          ./linux.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youruser = import ./home.nix; # Replace 'youruser' with your username
          }
        ];
      };
    };

    # Darwin configuration
    darwinConfigurations = {
      # Replace 'macbook' with your actual hostname
      macbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Change to your system architecture if needed
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youruser = import ./home.nix; # Replace 'youruser' with your username
          }
        ];
      };
    };
  };
}