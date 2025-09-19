#!/usr/bin/env bash

set -e

HOME_CONFIG_DIR="$HOME/.config"
# Source directory (.config.d) in the repository
SOURCE_CONFIG_DIR=".config"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Setting up dotfiles for $OS..."

# Create necessary directories
mkdir -p "$HOME_CONFIG_DIR"
mkdir -p "$HOME/.vim/undodir"  # Create undo directory for Neovim

# macOS specific setup
setup_macos() {
    echo "Setting up macOS environment..."

    # Install Homebrew if not installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    if [ -f "Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle install
    else
        echo "Brewfile not found. Skipping package installation."
    fi

    # Setup tmux plugin treemux python packages for neotree
    /usr/bin/python3 -m pip install --user pynvim
}

# Linux specific setup
setup_linux() {
    echo "Setting up Linux environment..."

    # Install required packages
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y \
            fish \
            neovim \
            bat \
            fd-find \
            fzf \
            jq \
            nodejs \
            npm \
            ruby \
            curl \
            zellij
        # Setup tmux plugin treemux python packages for neotree
        /usr/bin/python3 -m pip install --user pynvim
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y \
            fish \
            neovim \
            bat \
            fd-find \
            fzf \
            jq \
            nodejs \
            ruby \
            curl \
            zellij
        # Setup tmux plugin treemux python packages for neotree
        /usr/bin/python3 -m pip install --user pynvim
    else
        echo "Unsupported Linux distribution. Please install packages manually."
    fi
}

# Setup fish shell and plugins
setup_fish() {
    echo "Setting up fish shell..."

    # Only create these directories if they weren't already created
    # This is a fallback in case the dotfiles repo doesn't contain fish configs
    if [ ! -d "$HOME_CONFIG_DIR/fish/functions" ]; then
        mkdir -p "$HOME_CONFIG_DIR/fish/functions"
    fi
    if [ ! -d "$HOME_CONFIG_DIR/fish/completions" ]; then
        mkdir -p "$HOME_CONFIG_DIR/fish/completions"
    fi
    if [ ! -d "$HOME_CONFIG_DIR/fish/conf.d" ]; then
        mkdir -p "$HOME_CONFIG_DIR/fish/conf.d"
    fi

    # Install Fisher if not already installed
    if [ ! -f "$HOME_CONFIG_DIR/fish/functions/fisher.fish" ]; then
        echo "Installing Fisher plugin manager..."
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    fi

    # Update and install plugins if fish is available
    if command -v fish >/dev/null 2>&1; then
        fish -c "fisher update" || echo "Fisher update failed, continuing..."
    else
        echo "Fish shell not found. Please install it manually."
    fi
}

# Main installation process
main() {
    if [ "$OS" = "macos" ]; then
        setup_macos
    elif [ "$OS" = "linux" ]; then
        setup_linux
    fi

    setup_fish

    echo "Setting fish as default shell..."
    if command -v fish >/dev/null 2>&1; then
        if ! grep -q "$(command -v fish)" /etc/shells; then
            command -v fish | sudo tee -a /etc/shells
        fi
        chsh -s "$(command -v fish)"
    else
        echo "Fish shell not installed. Please install it manually."
    fi

    echo "Installation complete! Please restart your terminal."
}

main
