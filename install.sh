#!/usr/bin/env bash

set -e

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
mkdir -p "$HOME/.config"

# Function to recursively create symlinks for files in a directory
create_symlinks_recursive() {
    local source_dir="$1"
    local target_dir="$2"
    local rel_path="$3"
    
    # Create the target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Symlink files and process subdirectories
    for item in "$source_dir"/*; do
        local item_name=$(basename "$item")
        local target_item="$target_dir/$item_name"
        local current_rel_path
        
        if [ -n "$rel_path" ]; then
            current_rel_path="$rel_path/$item_name"
        else
            current_rel_path="$item_name"
        fi
        
        if [ -f "$item" ]; then
            # Create symlink for file
            ln -sf "$PWD/$source_dir/$item_name" "$target_item"
            echo "Symlinked: $current_rel_path"
        elif [ -d "$item" ]; then
            # Recursively process subdirectory
            create_symlinks_recursive "$source_dir/$item_name" "$target_item" "$current_rel_path"
        fi
    done
}

# Function to create symbolic links
create_symlinks() {
    echo "Creating symbolic links..."
    
    # Config files in root
    ln -sf "$PWD/.gitignore_global" "$HOME/.gitignore_global"
    ln -sf "$PWD/.githelpers" "$HOME/.githelpers"
    ln -sf "$PWD/.asdfrc" "$HOME/.asdfrc"
    ln -sf "$PWD/.tool-versions" "$HOME/.tool-versions"

    # Process each directory in .config
    for dir in .config/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            target_dir="$HOME/.config/$dirname"
            create_symlinks_recursive ".config/$dirname" "$target_dir" "$dirname"
        fi
    done
    
    echo "Symlinking complete."
}

# Function to update dotfiles without completely replacing configs
update_dotfiles() {
    echo "Updating dotfiles..."
    
    # Just run the same symlink function since it doesn't delete untracked files
    create_symlinks
}

# macOS specific setup
setup_macos() {
    echo "Setting up macOS environment..."
    
    # Install Homebrew if not installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    echo "Installing packages from Brewfile..."
    brew bundle install
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
            curl
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
            curl
    else
        echo "Unsupported Linux distribution. Please install packages manually."
    fi
}

# Setup fish shell and plugins
setup_fish() {
    echo "Setting up fish shell..."
    
    # Update and install plugins
    fish -c "fisher update"
}

# Main installation process
main() {
    if [ "$OS" = "macos" ]; then
        setup_macos
    elif [ "$OS" = "linux" ]; then
        setup_linux
    fi

    create_symlinks
    setup_fish

    echo "Setting fish as default shell..."
    if ! grep -q "$(command -v fish)" /etc/shells; then
        command -v fish | sudo tee -a /etc/shells
    fi
    chsh -s "$(command -v fish)"

    echo "Installation complete! Please restart your terminal."
}

main 