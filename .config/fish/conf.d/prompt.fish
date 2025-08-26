# Remove greeting message
set fish_greeting

# Not sure anymore why I did this and I am too lazy to investigate today
#function null_or_system
# test -z $argv[1]; and return 0
#  echo $argv[1] | grep 'system$'; and return 0n
#  return 1
#end


# # Load aws completions plugin
# # Installed via fisher from https://github.com/terlar/plugin-aws
set -e aws_profile

if not set -q aws_completer_path
  set -g aws_completer_path "/opt/homebrew/bin/aws_completer"
    or echo "aws: unable to find aws_completer, completions unavaliable"
end

# Override the path tide displays in the prompt
# The default contains all directories and it gets too long
# Since tide has no configuration for this, I need to override the function
set_color -o $tide_pwd_color_anchors | read -l color_anchors
set_color $tide_pwd_color_truncated_dirs | read -l color_truncated
set -l reset_to_color_dirs (set_color normal -b $tide_pwd_bg_color; set_color $tide_pwd_color_dirs)

set -l unwritable_icon $tide_pwd_icon_unwritable' '
set -l home_icon $tide_pwd_icon_home' '
set -l pwd_icon $tide_pwd_icon' '

eval "function _tide_pwd
    if set -l split_pwd (string replace -r '^$HOME' '' -- \$PWD | string split /)
        test -w . && set -f split_output \"$pwd_icon\$split_pwd[1]\" ||
            set -f split_output \"$unwritable_icon\$split_pwd[1]\"
        set split_output[-1] \"$color_anchors\$split_output[-1]$reset_to_color_dirs\"
    else
        set -f split_output \"$home_icon$color_anchors\"
    end
    string join -- / \"$reset_to_color_dirs\$split_output[1]\$(basename (prompt_pwd))\"
end"
