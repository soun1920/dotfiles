{ pkgs, ... }:

{
  # niri コンポジター (niri-flake の NixOS モジュール)
  programs.niri.enable = true;

  # greetd + tuigreet でログイン → niri-session 自動起動
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # niri 周辺ツール
  environment.systemPackages = with pkgs; [
    fuzzel            # Wayland アプリランチャー
    waybar            # ステータスバー
    mako              # 通知デーモン
    swaylock          # スクリーンロック
    swayidle          # アイドル管理
    grim              # スクリーンショット
    slurp             # 領域選択
    wl-clipboard      # クリップボード
    brightnessctl     # 輝度調整
    pamixer           # 音量調整
    xdg-utils
    xdg-desktop-portal-gnome
  ];

  # XDG Desktop Portal (niri は gnome portal を推奨)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # Electron/Chromium アプリを Wayland ネイティブで動かす
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
