# Dotfiles

A collection of configuration files for setting up my development environment.

["screenshot of a tmux session and my cmd line shell fish"](screenshots/tmux_shell.png)

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### How It Works

My dotfiles setup uses a file-by-file symlinking approach with these principles:

- Creates directories in `~/.config/` only if they don't already exist
- Symlinks individual files from the repository to your config directories
- Preserves any files not tracked in the repository
- Only overwrites files that are explicitly managed by the dotfiles

### Full Installation

To perform a full installation, which will:
- Install required packages 
- Create necessary directories and symlink all configuration files
- Set up fish as your default shell

Simply run:

```bash
./install.sh
```

### Updating Existing Configuration

To update configuration files:

```bash
./install.sh update
```

This will update the symlinks for all tracked files without removing any untracked files in your config directories.

## Structure

The repository follows this structure:

```
dotfiles/
├── .config/           # Configuration files that will be symlinked to ~/.config/
│   ├── fish/          # Fish shell configuration
│   ├── nvim/          # Neovim configuration
│   └── ...            # Other config directories
├── .gitignore_global  # Global gitignore file
├── .githelpers        # Git helper functions
├── .asdfrc            # ASDF configuration
├── .tool-versions     # ASDF tool versions
└── install.sh         # Installation script
```

## Customization

Feel free to modify any of the configuration files to suit your preferences. After making changes to the repository:

1. Run `./install.sh update` to update the symlinks to your configuration
2. Files you create outside of the repository will remain untouched

## Requirements

- macOS or Linux
- Bash shell (for running the installation script) 