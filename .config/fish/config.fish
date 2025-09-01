if test -e $HOME/.config/fish/themes/tokyonight_night.theme
. $HOME/.config/fish/themes/tokyonight_night.theme
end
if test -e $HOME/.config/fish/conf.d/prompt.fish
. $HOME/.config/fish/conf.d/prompt.fish
end
if test -e $HOME/.config/fish/conf.d/secrets.fish
. $HOME/.config/fish/conf.d/secrets.fish
end

set -gx HOMEBREW_NO_ANALYTICS 1

## Detect where we're running
switch (uname)
  case Darwin
    set -g is_macos true
  case Linux
    if test -e /home/linuxbrew/.linuxbrew/bin
      set -g is_deck true
    else
      set -g is_linux true
    end
end

## Add docker to PATH
if test -e ~/.docker/bin
  if not contains ~/.docker/bin $PATH
    set -gx --prepend PATH ~/.docker/bin
  end
end
 
## Init Homebrew and source asdf on OSX
if test $is_macos
  # remove initial /opt/homebrew/bin
  # I currently don't know where this is coming from initially
  set PATH (string match -v /opt/homebrew/bin $PATH)
  set PATH (string match -v /opt/homebrew/sbin $PATH)
  set PATH (string match -v /usr/bin $PATH)
  # also remove /usr/bin due to this error:
  # /usr/bin occurs before /opt/homebrew/bin in your PATH

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

  if not contains /opt/homebrew/bin $PATH
    set -gx --append PATH /opt/homebrew/bin
  end

  if not contains /opt/homebrew/bin $PATH
    set -gx --append PATH /opt/homebrew/sbin
  end

  if not contains /usr/bin $PATH
    set -gx --append PATH /usr/bin
  end
end

## Init Homebrew and source asdf on Deck
if test $is_deck
  if not contains /home/linuxbrew/.linuxbrew/bin $PATH
    set -gx --prepend PATH /home/linuxbrew/.linuxbrew/bin
    source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
  end
end

## Source asdf on Linux
if test $is_linux
  source /opt/asdf-vm/asdf.fish
end

if test -e "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  set -gx --prepend PATH "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
end

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

# Override fzf.fish keybindings to CMD+F on macOS
if test $is_macos
  # COMMAND            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
  # Search Directory   |  CMD+F (F for file)      |  --directory
  # Search Git Log     |  CMD+L (L for log)       |  --git_log
  # Search Git Status  |  CMD+S (S for status)    |  --git_status
  # Search History     |  CMD+R     (R for reverse)   |  --history
  # Search Processes   |  CMD+P (P for process)   |  --processes
  # Search Variables   |  CMD+Alt+V     (V for variable)  |  --variables
  fzf_configure_bindings --directory=\e\cf --variables=\e\cv --git_log=\e\cl --git_status=\e\cs --history=\cr --processes=\e\cp
else
  # COMMAND            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
  # Search Directory   |  Ctrl+Alt+F (F for file)      |  --directory
  # Search Git Log     |  Ctrl+Alt+L (L for log)       |  --git_log
  # Search Git Status  |  Ctrl+Alt+S (S for status)    |  --git_status
  # Search History     |  Ctrl+R     (R for reverse)   |  --history
  # Search Processes   |  Ctrl+Alt+P (P for process)   |  --processes
  # Search Variables   |  Ctrl+V     (V for variable)  |  --variables
  fzf_configure_bindings --directory=\e\cf --variables=\e\cv --git_log=\e\cl --git_status=\e\cs --history=\cr --processes=\e\cp
end

if test -e /Users/traxmaxx/.lmstudio/bin/
# Added by LM Studio CLI (lms)
  set -gx PATH $PATH /Users/traxmaxx/.lmstudio/bin
end
