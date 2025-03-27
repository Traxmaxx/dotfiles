#!/usr/bin/env bash
# Make this script executable with: chmod +x installv2.sh

set -e

HOME_CONFIG_DIR="$HOME/.config"
# Source directory (.config.d) in the repository
SOURCE_CONFIG_DIR=".config.d"
# NixOS configuration directory
NIXOS_DIR="nixos"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Setting up NixOS configuration for $OS..."

# Update the dotfiles repository path in home.nix
update_dotfiles_path() {
    echo "Updating dotfiles repository path in home.nix..."
    REPO_PATH="$PWD"
    sed -i.bak "s|dotfilesRepo = \"\${config.home.homeDirectory}/path/to/dotfiles\"|dotfilesRepo = \"$REPO_PATH\"|g" "$NIXOS_DIR/home.nix"
    rm -f "$NIXOS_DIR/home.nix.bak"
}

# Function to install Nix package manager
install_nix() {
    echo "Installing Nix package manager..."
    
    if command -v nix >/dev/null 2>&1; then
        echo "Nix is already installed."
    else
        echo "Installing Nix..."
        curl -L https://nixos.org/nix/install | sh
        
        # Source nix
        if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
            . "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi
    fi
}

# Function to install and configure Home Manager
setup_home_manager() {
    echo "Setting up Home Manager..."
    
    # Check if home-manager is installed
    if ! command -v home-manager >/dev/null 2>&1; then
        echo "Installing Home Manager..."
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell '<home-manager>' -A install
    fi
    
    # Create Home Manager configuration directory
    mkdir -p "$HOME/.config/nixpkgs"
    
    # Copy home.nix to the appropriate location
    cp "$PWD/$NIXOS_DIR/home.nix" "$HOME/.config/nixpkgs/home.nix"
    
    echo "Running Home Manager switch..."
    home-manager switch
}

# Function to setup NixOS on Linux
setup_nixos_linux() {
    echo "Setting up NixOS on Linux..."
    
    # Check if running NixOS
    if [ -f "/etc/nixos/configuration.nix" ]; then
        echo "NixOS detected. Setting up system configuration..."
        
        # Backup existing configuration
        sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
        
        # Copy NixOS configuration files
        sudo mkdir -p /etc/nixos/nixos
        sudo cp "$PWD/$NIXOS_DIR/"*.nix /etc/nixos/
        
        echo "NixOS configuration files copied to /etc/nixos/"
        echo "Please review the configuration and run 'sudo nixos-rebuild switch' to apply changes."
    else
        echo "This Linux system is not running NixOS."
        echo "Setting up Home Manager for non-NixOS Linux..."
        setup_home_manager
    fi
}

# Function to setup nix-darwin on macOS
setup_nix_darwin() {
    echo "Setting up nix-darwin on macOS..."
    
    # Check if nix-darwin is installed
    if ! command -v darwin-rebuild >/dev/null 2>&1; then
        echo "Installing nix-darwin..."
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        ./result/bin/darwin-installer
    fi
    
    # Create nix-darwin configuration directory
    mkdir -p "$HOME/.nixpkgs"
    
    # Copy darwin configuration files
    cp "$PWD/$NIXOS_DIR/darwin.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
    cp "$PWD/$NIXOS_DIR/common.nix" "$HOME/.nixpkgs/common.nix"
    
    echo "Running darwin-rebuild switch..."
    darwin-rebuild switch
}

# Function to setup flakes if needed
setup_flakes() {
    echo "Setting up Nix Flakes..."
    
    # Enable flakes in nix configuration
    mkdir -p "$HOME/.config/nix"
    echo "experimental-features = nix-command flakes" > "$HOME/.config/nix/nix.conf"
    
    # Copy flake.nix to home directory
    cp "$PWD/$NIXOS_DIR/flake.nix" "$HOME/flake.nix"
    
    echo "Nix Flakes configuration complete."
    echo "You can now use 'nix flake update' and 'nix flake check' in your home directory."
}

# Main installation process
main() {
    # Update the dotfiles repository path in home.nix
    update_dotfiles_path
    
    # Install Nix package manager
    install_nix
    
    # Setup OS-specific configurations
    if [ "$OS" = "macos" ]; then
        setup_nix_darwin
    elif [ "$OS" = "linux" ]; then
        setup_nixos_linux
    fi
    
    # Setup flakes (optional, uncomment if you want to use flakes)
    # setup_flakes
    
    echo "Installation complete! You may need to restart your terminal or system."
    echo "Your dotfiles from .config.d will be automatically symlinked by Home Manager."
    echo "Note: Your configurations from .config.d will be used as-is:"
    echo "      - Neovim configuration from .config.d/nvim"
    echo "      - tmux configuration from .config.d/tmux"
    echo "      - fish configuration from .config.d/fish"
    echo "      If you want to manage these through Nix in the future,"
    echo "      check the nixos/neovim.nix, nixos/tmux.nix, and nixos/fish.nix files for example configurations."
    echo "      You can enable them by uncommenting the imports in nixos/home.nix."
}

main