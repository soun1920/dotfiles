# ==============================================================================
# 環境変数
# ==============================================================================
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=100000
export WASMTIME_HOME="${HOME}/.wasmtime"

# PATH設定
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="${WASMTIME_HOME}/bin:$PATH"
export PATH="$HOME/.moon/bin:$PATH"

# exec fish

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
# Zinit
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ==============================================================================
# 補完初期化 (キャッシュあり: 24時間ごとのみ再生成)
# compdef を使うものより前に実行する必要がある (ROS2 setup.zsh 等)
# ==============================================================================
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ==============================================================================
# ROS2
# ==============================================================================
if [ -f /opt/ros/jazzy/setup.zsh ]; then
    source /opt/ros/jazzy/setup.zsh
fi

if [ -f /opt/ros/humble/setup.zsh ]; then
    source /opt/ros/humble/setup.zsh
fi

# ==============================================================================
# プラグイン
# ==============================================================================
zinit light zsh-users/zsh-autosuggestions

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# fzf-tab (compinit の後に読み込む)
zinit light Aloxaf/fzf-tab

# ==============================================================================
# fzf-tab 設定
# ==============================================================================
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath 2>/dev/null'
zstyle ':fzf-tab:*' switch-group ',' '.'

# ==============================================================================
# ツール初期化 (eval 結果をキャッシュ)
# ==============================================================================
_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$_zsh_cache_dir"

_cached_eval() {
    local name="$1" binary="$2"; shift 2
    local cache="${_zsh_cache_dir}/${name}.zsh"
    if [[ ! -f "$cache" || "$binary" -nt "$cache" ]]; then
        "$binary" "$@" > "$cache"
    fi
    source "$cache"
}

_cached_eval mise    /home/aw5qm/.local/bin/mise activate zsh

# ROS2 補完 (mise activate で ~/.local/bin が PATH に入った後に登録)
if [ -f /opt/ros/humble/setup.zsh ] && command -v register-python-argcomplete >/dev/null 2>&1; then
    eval "$(register-python-argcomplete --shell zsh ros2)"
fi

_cached_eval starship "$(command -v starship)"  init zsh
_cached_eval direnv  "$(command -v direnv)"  hook zsh
_cached_eval uv      "$(command -v uv)"      generate-shell-completion zsh

unset _zsh_cache_dir

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
alias rs2="source ../"

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

function setros() {
    local current_dir="$PWD"
    local found=""

    for dir in "$current_dir" "$current_dir/.." "$current_dir/../.."; do
        local target="$(realpath "$dir")/install/setup.zsh"
        if [[ -f "$target" ]]; then
            found="$target"
            break
        fi
    done

    if [[ -z "$found" ]]; then
        echo "setup.zsh が見つかりませんでした (探索範囲: 2階層上まで)" >&2
        return 1
    fi

    echo "実行: $found"
    source "$found"
}

# ==============================================================================
# zoxide
# ==============================================================================
eval "$(zoxide init zsh)"
