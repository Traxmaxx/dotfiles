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
# Set default editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER 'nvim +Man!'

# fzf setup.
set -gx  FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#0e1419,hl:#e11299,fg+:#f8f8f2,bg+:#44475a,hl+:#e11299,info:#f1fa8c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#a4ffff,header:#6272a4 \
--cycle --pointer=▎
--marker=▎ \
--bind=alt-s:toggle"

# Disable Apple's save/restore mechanism.
set -gx SHELL_SESSIONS_DISABLE 1

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
  fzf_configure_bindings \
    --directory=\e\[9\;F \
    --git_log=\e\[9\;L \
    --git_status=\e\[9\;S \
    --history=\e\[9\;R \
    --processes=\e\[9\;P \
    --variables=\e\[9\;V
else
  # COMMAND            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
  # Search Directory   |  Ctrl+Alt+F (F for file)      |  --directory
  # Search Git Log     |  Ctrl+Alt+L (L for log)       |  --git_log
  # Search Git Status  |  Ctrl+Alt+S (S for status)    |  --git_status
  # Search History     |  Ctrl+R     (R for reverse)   |  --history
  # Search Processes   |  Ctrl+Alt+P (P for process)   |  --processes
  # Search Variables   |  Ctrl+V     (V for variable)  |  --variables
  fzf_configure_bindings \
    --directory=\e\cf \
    --git_log=\e\cl \
    --git_status=\e\cs \
    --history=\cr \
    --processes=\e\cp \
    --variables=\e\cv
end

# fzf shell integration:
fzf --fish | source

if test -e /Users/traxmaxx/.lmstudio/bin/
# Added by LM Studio CLI (lms)
  set -gx PATH $PATH /Users/traxmaxx/.lmstudio/bin
end
