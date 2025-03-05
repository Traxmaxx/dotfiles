#!/usr/bin/env fish
# fishux.fish - A Fish shell-based terminal session manager

# Create necessary directories
mkdir -p ~/.config/fish/fishux/sessions

# Detect if running in Ghostty
function __is_ghostty
    test -n "$GHOSTTY_RESOURCES_DIR"
end

# Save current session state
function fishux_save
    set -l session_name $argv[1]
    if test -z "$session_name"
        read -P "Session name: " session_name
    end
    
    set -l session_file ~/.config/fish/fishux/sessions/$session_name
    
    # Save current directory
    echo "cd "(pwd) > $session_file
    
    # Save environment variables
    for var in (set -n)
        if string match -q "fishux_*" $var
            echo "set -gx $var \"$var\"" >> $session_file
        end
    end
    
    # Save any custom state
    if functions -q fishux_custom_save
        fishux_custom_save $session_file
    end
    
    echo "Session $session_name saved"
end

# Load a saved session
function fishux_load
    set -l session_name $argv[1]
    
    if test -z "$session_name"
        # Interactive selection if fzf is available
        if type -q fzf
            set available_sessions (ls ~/.config/fish/fishux/sessions 2>/dev/null)
            if test (count $available_sessions) -gt 0
                set session_name (printf '%s\n' $available_sessions | fzf --height 40% --reverse --prompt="Select session: ")
            else
                echo "No saved sessions found"
                return 1
            end
        else
            # Basic selection menu
            set available_sessions (ls ~/.config/fish/fishux/sessions 2>/dev/null)
            if test (count $available_sessions) -gt 0
                echo "Available sessions:"
                set -l i 1
                for session in $available_sessions
                    echo "$i) $session"
                    set i (math $i + 1)
                end
                
                read -P "Select session (1-"(math $i - 1)"): " selection
                if test -n "$selection" -a "$selection" -ge 1 -a "$selection" -lt $i
                    set session_name $available_sessions[(math $selection)]
                else
                    echo "Invalid selection"
                    return 1
                end
            else
                echo "No saved sessions found"
                return 1
            end
        end
    end
    
    set -l session_file ~/.config/fish/fishux/sessions/$session_name
    
    if test -f $session_file
        source $session_file
        echo "Session $session_name loaded"
    else
        echo "Session $session_name not found"
    end
end

# List saved sessions
function fishux_list
    echo "Saved sessions:"
    set -l sessions (ls ~/.config/fish/fishux/sessions 2>/dev/null)
    
    if test (count $sessions) -eq 0
        echo "  No saved sessions"
    else
        for session in $sessions
            echo "  $session"
        end
    end
end

# Create a new terminal window/tab with the current directory
function fishux_new
    set -l type $argv[1]  # "window" or "tab"
    
    # Detect terminal and use appropriate command
    if __is_ghostty
        # Ghostty terminal
        if test "$type" = "tab"
            # Create a new tab in Ghostty
            ghostty +new-tab --working-directory=(pwd)
        else
            # Create a new window in Ghostty
            ghostty +new-window --working-directory=(pwd)
        end
    else if set -q ITERM_SESSION_ID
        # iTerm2
        if test "$type" = "tab"
            echo -ne '\e]1337;CreateNewTab\a'
        else
            echo -ne '\e]1337;CreateNewWindow\a'
        end
    else if set -q KITTY_WINDOW_ID
        # Kitty terminal
        if test "$type" = "tab"
            kitty @ launch --type=tab --cwd=current
        else
            kitty @ launch --type=window --cwd=current
        end
    else if set -q GNOME_TERMINAL_SCREEN
        # Gnome Terminal
        gnome-terminal --working-directory=(pwd)
    else
        # Generic approach - may not work in all terminals
        set -l terminal (basename $SHELL)
        $terminal &
    end
end

# Split the terminal (if supported)
function fishux_split
    set -l direction $argv[1]  # "h" or "v"
    
    # Detect terminal and use appropriate command
    if __is_ghostty
        # Ghostty terminal
        if test "$direction" = "h"
            # Horizontal split in Ghostty
            ghostty +split-horizontal --working-directory=(pwd)
        else
            # Vertical split in Ghostty
            ghostty +split-vertical --working-directory=(pwd)
        end
    else if set -q ITERM_SESSION_ID
        # iTerm2
        if test "$direction" = "h"
            echo -ne '\e]1337;SplitHorizontal\a'
        else
            echo -ne '\e]1337;SplitVertical\a'
        end
    else if set -q KITTY_WINDOW_ID
        # Kitty terminal
        if test "$direction" = "h"
            kitty @ launch --location=hsplit --cwd=current
        else
            kitty @ launch --location=vsplit --cwd=current
        end
    else if set -q TERMINATOR_UUID
        # Terminator
        if test "$direction" = "h"
            terminator -e "cd (pwd); $SHELL" --new-tab
        else
            terminator -e "cd (pwd); $SHELL" --split-horiz
        end
    else
        echo "Terminal splitting not supported in this terminal emulator"
    end
end

# Focus a specific pane (if supported)
function fishux_focus
    set -l direction $argv[1]  # "left", "right", "up", "down"
    
    if __is_ghostty
        # Ghostty terminal
        switch $direction
            case "left"
                ghostty +focus-left
            case "right"
                ghostty +focus-right
            case "up"
                ghostty +focus-up
            case "down"
                ghostty +focus-down
            case "*"
                echo "Unknown direction: $direction"
                echo "Use: left, right, up, or down"
        end
    else if set -q KITTY_WINDOW_ID
        # Kitty terminal
        switch $direction
            case "left"
                kitty @ focus-window --match neighbor:left
            case "right"
                kitty @ focus-window --match neighbor:right
            case "up"
                kitty @ focus-window --match neighbor:top
            case "down"
                kitty @ focus-window --match neighbor:bottom
            case "*"
                echo "Unknown direction: $direction"
        end
    else
        echo "Focus navigation not supported in this terminal emulator"
    end
end

# Resize the current pane (if supported)
function fishux_resize
    set -l direction $argv[1]  # "left", "right", "up", "down"
    set -l amount $argv[2]     # Amount to resize by
    
    if test -z "$amount"
        set amount 5  # Default resize amount
    end
    
    if __is_ghostty
        # Ghostty terminal
        switch $direction
            case "left"
                ghostty +resize-left $amount
            case "right"
                ghostty +resize-right $amount
            case "up"
                ghostty +resize-up $amount
            case "down"
                ghostty +resize-down $amount
            case "*"
                echo "Unknown direction: $direction"
                echo "Use: left, right, up, or down"
        end
    else if set -q KITTY_WINDOW_ID
        # Kitty terminal
        switch $direction
            case "left"
                kitty @ resize-window --axis=horizontal --increment=-$amount
            case "right"
                kitty @ resize-window --axis=horizontal --increment=$amount
            case "up"
                kitty @ resize-window --axis=vertical --increment=-$amount
            case "down"
                kitty @ resize-window --axis=vertical --increment=$amount
            case "*"
                echo "Unknown direction: $direction"
        end
    else
        echo "Resize not supported in this terminal emulator"
    end
end

# Main fishux command
function fishux
    set -l cmd $argv[1]
    set -e argv[1]
    
    switch $cmd
        case "save"
            fishux_save $argv
        case "load"
            fishux_load $argv
        case "list"
            fishux_list
        case "new"
            fishux_new $argv
        case "split"
            fishux_split $argv
        case "focus"
            fishux_focus $argv
        case "resize"
            fishux_resize $argv
        case "help"
            echo "fishux - Fish shell terminal session manager"
            echo ""
            echo "Commands:"
            echo "  save [name]    - Save current session"
            echo "  load [name]    - Load saved session"
            echo "  list           - List saved sessions"
            echo "  new [tab|window] - Create new terminal tab/window"
            echo "  split [h|v]    - Split terminal (if supported)"
            echo "  focus [left|right|up|down] - Focus pane in direction"
            echo "  resize [left|right|up|down] [amount] - Resize current pane"
            echo "  help           - Show this help"
            
            # Show terminal-specific information
            if __is_ghostty
                echo ""
                echo "Detected terminal: Ghostty"
                echo "All commands are supported in this terminal"
                echo "Using Ghostty CLI syntax with '+action' format"
            else if set -q KITTY_WINDOW_ID
                echo ""
                echo "Detected terminal: Kitty"
                echo "All commands are supported in this terminal"
            else if set -q ITERM_SESSION_ID
                echo ""
                echo "Detected terminal: iTerm2"
                echo "Some advanced commands may not be supported"
            else
                echo ""
                echo "Terminal not specifically supported"
                echo "Some commands may not work as expected"
            end
        case "*"
            echo "Unknown command: $cmd"
            echo "Run 'fishux help' for usage information"
    end
end

# Detect and show terminal on load
if status is-interactive
    if __is_ghostty
        set -g FISHUX_TERMINAL "Ghostty"
    else if set -q KITTY_WINDOW_ID
        set -g FISHUX_TERMINAL "Kitty"
    else if set -q ITERM_SESSION_ID
        set -g FISHUX_TERMINAL "iTerm2"
    else
        set -g FISHUX_TERMINAL "Unknown"
    end
end
