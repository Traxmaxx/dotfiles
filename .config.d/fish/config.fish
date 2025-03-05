. $HOME/.config/fish/themes/tokyonight_night.theme
. $HOME/.config/fish/conf.d/prompt.fish
. $HOME/.config/fish/conf.d/secrets.fish


if test -e ~/.docker/bin
  if not contains ~/.docker/bin $PATH
    set -gx --prepend PATH ~/.docker/bin
  end
end

## Init ssh-agent on OSX
fish_ssh_agent

## Init Homebrew and source asdf on OSX
if test -e /opt/homebrew/bin/
  if not contains /opt/homebrew/bin $PATH
    eval (/opt/homebrew/bin/brew shellenv)
  end

  # ASDF configuration code
  # source (brew --prefix asdf)/share/fish/vendor_completions.d/asdf.fish
  if test -z $ASDF_DATA_DIR
      set _asdf_shims "$HOME/.asdf/shims"
  else
      set _asdf_shims "$ASDF_DATA_DIR/shims"
  end

  # Do not use fish_add_path (added in Fish 3.2) because it
  # potentially changes the order of items in PATH
  if not contains $_asdf_shims $PATH
      set -gx --prepend PATH $_asdf_shims
  end
  set --erase _asdf_shims
end

## Init Homebrew and source asdf on Deck
if test -e /home/linuxbrew/.linuxbrew/bin
  if not contains /home/linuxbrew/.linuxbrew/bin $PATH
    set -gx --prepend PATH /home/linuxbrew/.linuxbrew/bin
    source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
  end
end

## Source asdf on Linux
if test -e /opt/asdf-vm/asdf.fish
  source /opt/asdf-vm/asdf.fish
end

set -gx HOMEBREW_NO_ANALYTICS 1

if test -e "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  set -gx --prepend PATH "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
end

# Tmux Shell scripts loaded as functions for better arguments handling
# function tmk
#     $HOME/.config/fish/functions/tmk.sh $argv
# end

# function tm
#     $HOME/.config/fish/functions/tm.sh $argv
# end

# Aliases
alias chrome "chromium"

alias gco "git checkout"
alias gcl "git clone"
alias gsta "git stash"
alias gst "git status"
alias gdi "git diff"
alias gcm "git commit"
alias gca "git commit -am"

# Create function aliases to allow direct use of fmux as fm and fmk commands
alias fm='fmux_fm'
alias fmk='fmux_fmk'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/traxmaxx/.lmstudio/bin
