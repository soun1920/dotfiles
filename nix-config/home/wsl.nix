# WSL 用 home-manager 設定
# GUI 関連 (gtk, niri, services, kanata) を除外
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./ghostty.nix
    ./zellij.nix
    ./lazygit.nix
    ./neovim.nix
    ./fonts.nix
  ];

  home.username = "aw5qm";
  home.homeDirectory = "/home/aw5qm";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # 言語・ランタイム
    go
    nodejs
    python3
    rustup
    pnpm
    uv

    # CLI ツール
    bat
    ripgrep
    fzf
    jq
    gh
    ghq
    lazygit
    yazi
    tmux
    zellij
    eza

    # ビルドツール
    gcc
    gnumake
    cmake

    # Claude Code
    claude-code
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    WASMTIME_HOME = "$HOME/.wasmtime";
    EDITOR = "nvim";
  };
}
