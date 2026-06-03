# ==============================================================================
# 環境変数
# ==============================================================================
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx WASMTIME_HOME "$HOME/.wasmtime"
set -gx EDITOR "/home/aw5qm/.local/bin/zed"

# 履歴設定（fishはデフォルトで ~/.local/share/fish/fish_history）
set -gx fish_history_max 100000

# PATH設定
fish_add_path "{$ASDF_DATA_DIR:-$HOME/.asdf}/shims"
fish_add_path "$WASMTIME_HOME/bin"
fish_add_path "$HOME/.local/bin"
# ==============================================================================
# Homebrew
# ==============================================================================
# eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# ==============================================================================
# ツール初期化
# ==============================================================================
mise activate fish | source
zoxide init fish | source
starship init fish | source
direnv hook fish | source
uv generate-shell-completion fish | source

# ==============================================================================
# カラー設定
# ==============================================================================
if test -x /usr/bin/dircolors
    if test -r ~/.dircolors
        eval (dircolors -c ~/.dircolors)
    else
        eval (dircolors -c)
    end
end

# ==============================================================================
# エイリアス（abbreviationsを推奨）
# ==============================================================================
# 基本コマンド
alias ll "ls -l"
alias ls "ls --color=auto"
alias grep "grep --color=auto"
alias nv "nvim ."
alias python "python3"
alias clip "win32yank.exe"
# alias ssh "ssh.exe"
# alias ssh-add "ssh-add.exe"

# ディレクトリ移動
alias cdp 'cd "/mnt/c/Users/aw5qm/OneDrive - Kogakuin University/個人用"'
alias cdc "cd /home/aw5qm/.config"
alias cda 'cd "/mnt/c/Users/aw5qm/OneDrive - Kogakuin University/個人用/atcoder/"'

# Python仮想環境
alias actv "source .venv/bin/activate.fish"
alias activate "source .venv/bin/activate.fish"

# C++コンパイル
alias gc "g++ -std=gnu++20 -O2 -Wall -Wextra"
alias cpp "g++ -std=gnu++20 -O2 -Wall -Wextra main.cpp"
alias ac "gc main.cpp && oj t"
alias ot "cpp_test"

# ==============================================================================
# 関数
# ==============================================================================
function copy_to_clipboard
    if command -v pbcopy >/dev/null 2>&1
        pbcopy
    else if command -v xclip >/dev/null 2>&1
        xclip -selection clipboard
    else if command -v xsel >/dev/null 2>&1
        xsel --clipboard --input
    else if command -v clip.exe >/dev/null 2>&1
        clip.exe
    else
        echo "Warning: クリップボードにコピーできませんでした"
        cat
        return 1
    end
end

function nd
    set -l current_dir (basename $PWD)
    set -l next_dir ""

    switch $current_dir
        case a
            set next_dir b
        case b
            set next_dir c
        case c
            set next_dir d
        case d
            set next_dir e
        case e
            set next_dir f
        case f
            set next_dir g
        case g
            set next_dir a
        case '*'
            echo "エラー: 対象ディレクトリは a b c d e f g のみ"
            return 1
    end

    cd "../$next_dir" && echo "$current_dir → $next_dir"
end

function cpp_test
    set -l cpp_file (test -n "$argv[1]" && echo $argv[1] || echo "main.cpp")

    g++ -std=gnu++20 -O2 -Wall -Wextra $cpp_file; or return 1

    set -l res (timeout 5s oj t 2>&1)
    set -l exit_code $status

    if test $exit_code -eq 124
        echo "timeout"
        return 1
    end

    echo $res

    if echo $res | grep -qE '\[SUCCESS\]|test success|All tests passed'
        cat $cpp_file | copy_to_clipboard
        echo "copied to clipboard"
    end

    return $exit_code
end
function cdg
  cd "$(ghq list -p | fzf)"
end
function gg -d "Search and clone GitHub repositories using ghq"
    # 自分がアクセスできる全リポジトリ（個人 + 所属Org）を取得してfzfへ
    set -l selected_repo (gh api user/repos --paginate --jq '.[] | "\(.full_name)\t\(.description)"' | fzf --prompt="Select Repo> " | awk '{print $1}')

    # 選択された場合のみ ghq get を実行
    if test -n "$selected_repo"
        echo "Cloning $selected_repo..."
        ghq get $selected_repo
    end
end
set -g fish_greeting

# pnpm
set -gx PNPM_HOME "/home/aw5qm/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
