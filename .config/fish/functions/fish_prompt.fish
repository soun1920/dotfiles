# Iceberg Prompt for Fish Shell
#
# Installation:
#   1. Copy this file to ~/.config/fish/functions/fish_prompt.fish
#   2. Restart fish or run: source ~/.config/fish/functions/fish_prompt.fish
#
# Features:
#   - Git branch and status display
#   - SSH session indicator
#   - Exit status indicator
#   - Clean, minimal design matching Iceberg aesthetic

function fish_prompt
    set -l last_status $status

    # Iceberg colors
    set -l color_normal (set_color c6c8d1)
    set -l color_blue (set_color 84a0c6)
    set -l color_green (set_color b4be82)
    set -l color_yellow (set_color e2a478)
    set -l color_red (set_color e27878)
    set -l color_magenta (set_color a093c7)
    set -l color_cyan (set_color 89b8c2)
    set -l color_gray (set_color 6b7089)
    set -l color_reset (set_color normal)

    # SSH indicator
    if set -q SSH_TTY
        echo -n $color_yellow'[SSH] '$color_reset
    end

    # Username and hostname (only show for root or SSH)
    if test "$USER" = root; or set -q SSH_TTY
        echo -n $color_green$USER$color_gray'@'$color_blue(prompt_hostname)$color_gray':'$color_reset
    end

    # Current directory
    echo -n $color_blue(prompt_pwd)$color_reset

    # Git information
    if command -sq git
        set -l git_branch (git branch --show-current 2>/dev/null)
        if test -n "$git_branch"
            echo -n $color_gray' on '$color_magenta$git_branch$color_reset

            # Git status indicators
            set -l git_status (git status --porcelain 2>/dev/null)
            if test -n "$git_status"
                # Check for different states
                set -l staged (echo "$git_status" | grep -c '^[MADRC]')
                set -l unstaged (echo "$git_status" | grep -c '^.[MD]')
                set -l untracked (echo "$git_status" | grep -c '^??')

                echo -n ' '$color_gray'['$color_reset
                if test $staged -gt 0
                    echo -n $color_green'+'$color_reset
                end
                if test $unstaged -gt 0
                    echo -n $color_yellow'!'$color_reset
                end
                if test $untracked -gt 0
                    echo -n $color_red'?'$color_reset
                end
                echo -n $color_gray']'$color_reset
            end
        end
    end

    echo

    # Prompt character with status color
    if test $last_status -eq 0
        echo -n $color_cyan'❯ '$color_reset
    else
        echo -n $color_red'❯ '$color_reset
    end
end

function fish_right_prompt
    set -l last_status $status
    set -l color_gray (set_color 6b7089)
    set -l color_red (set_color e27878)
    set -l color_reset (set_color normal)

    # Show last command duration if > 1 second
    if test $CMD_DURATION
        if test $CMD_DURATION -gt 1000
            set -l duration (math -s1 $CMD_DURATION / 1000)
            echo -n $color_gray$duration's '$color_reset
        end
    end

    # Show exit code if non-zero
    if test $last_status -ne 0
        echo -n $color_red'['$last_status'] '$color_reset
    end

    # Time
    echo -n $color_gray(date '+%H:%M')$color_reset
end
