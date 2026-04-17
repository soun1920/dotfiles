# ==============================================================================
# 環境変数
# ==============================================================================
export XDG_CONFIG_HOME="${HOME}/.config"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=100000
export WASMTIME_HOME="${HOME}/.wasmtime"

# PATH設定
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="${WASMTIME_HOME}/bin:$PATH"

exec fish

# ==============================================================================
# シェルオプション
# ==============================================================================
setopt hist_ignore_dups
setopt EXTENDED_HISTORY
setopt auto_cd
setopt auto_remove_slash
setopt auto_name_dirs
setopt auto_menu

# ==============================================================================
# Homebrew (先に読み込む)
# ==============================================================================
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ==============================================================================
# Zinit
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zsh-autocomplete (最初に読み込む、compinit は呼ばない)
zinit light marlonrichert/zsh-autocomplete

autoload -Uz compinit && compinit
# autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ==============================================================================
# zsh-autocomplete 設定
# ==============================================================================
# Tab で補完メニューに入る
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# ==============================================================================
# ツール初期化
# ==============================================================================
eval "$(/home/aw5qm/.local/bin/mise activate zsh)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(uv generate-shell-completion zsh)"
# 入力2文字以上で補完開始
zstyle ':autocomplete:*' min-input 2

# 補完候補の表示行数を制限
zstyle ':autocomplete:*' list-lines 7

# 履歴検索を無効化 (最大のボトルネック 623ms)
zstyle ':autocomplete:history-search:*' list-lines 3

# 非同期補完の遅延を増やす
zstyle ':autocomplete:*' delay 0.1
# ==============================================================================
# カラー設定
# ==============================================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ==============================================================================
# エイリアス
# ==============================================================================
alias ll="ls -l"
alias nv='nvim .'
alias python="python3"
alias clip="win32yank.exe"
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

alias cdp='cd "/mnt/c/Users/aw5qm/OneDrive - Kogakuin University/個人用"'
alias cdc="cd /home/aw5qm/.config"
alias cda='cd "/mnt/c/Users/aw5qm/OneDrive - Kogakuin University/個人用/atcoder/"'

alias actv="source .venv/bin/activate"
alias activate="source .venv/bin/activate"

alias gc="g++ -std=gnu++20 -O2 -Wall -Wextra"
alias cpp='g++ -std=gnu++20 -O2 -Wall -Wextra main.cpp'
alias ac="gc main.cpp && oj t"
alias ot="cpp_test"

# ==============================================================================
# 関数
# ==============================================================================
copy_to_clipboard() {
    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --input
    elif command -v clip.exe >/dev/null 2>&1; then
        clip.exe
    else
        echo "Warning: クリップボードにコピーできませんでした"
        cat
        return 1
    fi
}

nd() {
    local current_dir=$(basename "$PWD")
    local next_dir=""

    case "$current_dir" in
        a) next_dir="b" ;;
        b) next_dir="c" ;;
        c) next_dir="d" ;;
        d) next_dir="e" ;;
        e) next_dir="f" ;;
        f) next_dir="g" ;;
        g) next_dir="a" ;;
        *)
            echo "エラー: 対象ディレクトリは a b c d e f g のみ"
            return 1
            ;;
    esac

    cd "../$next_dir" && echo "$current_dir → $next_dir"
}

cpp_test() {
    local cpp_file="${1:-main.cpp}"

    g++ -std=gnu++20 -O2 -Wall -Wextra "$cpp_file" || return 1

    local res=$(timeout 5s oj t 2>&1)
    local exit_code=$?

    if [[ $exit_code -eq 124 ]]; then
        echo "timeout"
        return 1
    fi

    echo "$res"

    if echo "$res" | grep -qE "\[SUCCESS\]|test success|All tests passed"; then
        cat "$cpp_file" | copy_to_clipboard
        echo "copied to clipboard"
    fi

    return $exit_code
}



# moonbit
export PATH="$HOME/.moon/bin:$PATH"

# moonbit
export PATH="$HOME/.moon/bin:$PATH"

# moonbit
export PATH="$HOME/.moon/bin:$PATH"
