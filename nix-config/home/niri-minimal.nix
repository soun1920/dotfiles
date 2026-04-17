# USB/実機 niri 用の最小 home-manager 設定
# 重いパッケージ (discord, slack, spotify 等) を除外
{ pkgs, ... }:

{
  home.username = "aw5qm";
  home.homeDirectory = "/home/aw5qm";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # 基本ツール
    bat ripgrep fzf jq gh lazygit yazi
    eza wl-clipboard tmux
    gcc gnumake cmake
    # ブラウザ
    firefox
  ];

  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./neovim.nix
    ./fonts.nix
  ];
}
