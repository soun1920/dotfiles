{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hackgen-nf-font  # HackGen Nerd Font (日本語対応プログラミングフォント)
    ibm-plex         # IBM Plex Sans JP (UI フォント)
  ];

  # nixpkgsにないフォント (PlemolJP NF, Moralerspace HWJPDOC) は
  # 現在 ~/.local/share/fonts/ にインストール済みのものをそのまま利用する。

  fonts.fontconfig.enable = true;
}
