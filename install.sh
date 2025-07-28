#!/usr/bin/env bash

set -e

HOME_CONFIG_DIR="$HOME/.config"
# Source directory (.config.d) in the repository
SOURCE_CONFIG_DIR=".config.d"

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

# List of files/directories to exclude from symlinking
EXCLUDE_LIST=(
    "install.sh"
    "Brewfile"
    "README.md"
    ".gitignore"
    ".git"
    ".gitmodules"
    ".DS_Store"
)

# Function to check if a file/directory should be excluded
should_exclude() {
    local item="$1"
    local basename=$(basename "$item")
    
    for exclude in "${EXCLUDE_LIST[@]}"; do
        if [[ "$basename" == "$exclude" ]]; then
            return 0  # true, should exclude
        fi
    done
    
    return 1  # false, should not exclude
}

# Function to recursively create symlinks for files only
create_symlinks_recursive() {
    local source_dir="$1"
    local target_dir="$2"
    
    # Create the target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Symlink files and process subdirectories
    for item in "$source_dir"/*; do
        # Skip if item doesn't exist (handles empty glob)
        [ ! -e "$item" ] && continue
        
        local item_name=$(basename "$item")
        local target_item="$target_dir/$item_name"
        
        # Skip excluded items
        if should_exclude "$item_name"; then
            echo "Skipping excluded item: $item_name"
            continue
        fi
        
        if [ -f "$item" ]; then
            # Create symlink for file
            ln -sf "$PWD/$item" "$target_item"
            echo "Symlinked file: $item to $target_item"
        elif [ -d "$item" ]; then
            # For directories, recursively process and symlink files only
            create_symlinks_recursive "$item" "$target_item"
        fi
    done
}

# Function to create symbolic links
create_symlinks() {
    echo "Creating symbolic links..."
    
    # Check if the source directory exists
    if [ ! -d "$SOURCE_CONFIG_DIR" ]; then
        echo "Error: Source directory $SOURCE_CONFIG_DIR not found."
        return 1
    fi
    
    # Process all files and directories in .config.d
    create_symlinks_recursive "$SOURCE_CONFIG_DIR" "$HOME_CONFIG_DIR"

    # Create a manual symlink for tmux config to ~/.tmux.conf
    # Used by the tmux-sensible plugin
    ln -sf "$PWD/$SOURCE_CONFIG_DIR/tmux/.tmux-cht-command" "$HOME/.tmux-cht-command" 
    # And also cheatsheet configs
    ln -sf "$PWD/$SOURCE_CONFIG_DIR/tmux/.tmux-cht-languages" "$HOME/.tmux-cht-languages" 
    
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
    
    # Only create these directories if they weren't already created by create_symlinks
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

    create_symlinks
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