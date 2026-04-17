# Iceberg Theme for Fish Shell
# https://cocopon.github.io/iceberg.vim/
#
# Installation:
#   1. Copy this file to ~/.config/fish/conf.d/iceberg_theme.fish
#   2. Restart fish or run: source ~/.config/fish/conf.d/iceberg_theme.fish

# ============================================================================
# Iceberg Color Palette
# ============================================================================
# Background:     #161821
# Foreground:     #c6c8d1
# 
# Normal colors:
#   Black:        #161821    Bright Black:   #6b7089
#   Red:          #e27878    Bright Red:     #e98989
#   Green:        #b4be82    Bright Green:   #c0ca8e
#   Yellow:       #e2a478    Bright Yellow:  #e9b189
#   Blue:         #84a0c6    Bright Blue:    #91acd1
#   Magenta:      #a093c7    Bright Magenta: #ada0d3
#   Cyan:         #89b8c2    Bright Cyan:    #95c4ce
#   White:        #c6c8d1    Bright White:   #d2d4de
# ============================================================================

# ----------------------------------------------------------------------------
# Syntax Highlighting Colors
# ----------------------------------------------------------------------------

# Default text color
set -g fish_color_normal c6c8d1

# Commands (e.g., 'ls', 'cd')
set -g fish_color_command 84a0c6

# Keywords (e.g., 'if', 'for', 'function')
set -g fish_color_keyword a093c7

# Quoted strings
set -g fish_color_quote b4be82

# IO redirections (e.g., '>', '<', '|')
set -g fish_color_redirection 89b8c2 --bold

# Process separators (e.g., ';', '&')
set -g fish_color_end e2a478

# Potential errors
set -g fish_color_error e27878

# Command parameters/arguments
set -g fish_color_param c6c8d1

# Options (e.g., '-l', '--help')
set -g fish_color_option ada0d3

# Comments
set -g fish_color_comment 6b7089

# Selected text in vi visual mode
set -g fish_color_selection --background=3d425b

# Search matches
set -g fish_color_search_match --background=3d425b

# History search prefix
set -g fish_color_history_current --bold

# Operator characters (e.g., '*', '?')
set -g fish_color_operator 89b8c2

# Character escapes (e.g., '\n')
set -g fish_color_escape e9b189

# Autosuggestions
set -g fish_color_autosuggestion 6b7089

# The '^C' cancel indicator
set -g fish_color_cancel e27878

# Current working directory in prompt
set -g fish_color_cwd 84a0c6

# Current working directory for root user
set -g fish_color_cwd_root e27878

# Username in prompt
set -g fish_color_user b4be82

# Hostname in prompt
set -g fish_color_host 84a0c6

# Hostname for remote sessions
set -g fish_color_host_remote e2a478

# Valid file paths (underlined)
set -g fish_color_valid_path --underline

# ----------------------------------------------------------------------------
# Pager Colors (Tab Completion Menu)
# ----------------------------------------------------------------------------

# Normal completion text
set -g fish_pager_color_completion c6c8d1

# Completion description
set -g fish_pager_color_description 6b7089

# Prefix match highlight
set -g fish_pager_color_prefix 89b8c2 --bold

# Progress bar at bottom
set -g fish_pager_color_progress 161821 --background=84a0c6

# Selected completion item
set -g fish_pager_color_selected_background --background=3d425b

# Secondary completion (alternating)
set -g fish_pager_color_secondary_background

# Secondary description
set -g fish_pager_color_secondary_description 6b7089

# Secondary prefix
set -g fish_pager_color_secondary_prefix 89b8c2

# Secondary completion text
set -g fish_pager_color_secondary_completion c6c8d1

