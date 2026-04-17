{ pkgs, zen-browser, ... }:

{
  home.packages = with pkgs; [
    # 言語・ランタイム
    go
    nodejs
    python3
    rustup
    pnpm
    uv

    # CLIツール
    bat
    ripgrep
    fzf
    jq
    gh
    ghq
    lazygit
    yazi
    yt-dlp
    tmux
    zellij
    kanata
    wl-clipboard
    eza

    # ビルドツール
    gcc
    gnumake
    cmake

    # GUIアプリ (Flatpakから移行)
    _1password-gui
    discord
    slack
    spotify
    obsidian
    anki-bin

    # ブラウザ・エディタ (dnfカスタムrepoから移行)
    vscode
    google-chrome
    ghostty
    firefox-devedition-bin

    # Zen Browser (コミュニティflake)
    zen-browser.packages.${pkgs.system}.default
  ];
}
