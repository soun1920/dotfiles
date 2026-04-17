{ config, pkgs, ... }:

{
  # WSL モジュール
  wsl.enable = true;
  wsl.defaultUser = "aw5qm";

  # ネットワーク
  networking.hostName = "wsl";

  # タイムゾーン・ロケール
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
  };

  # ユーザー
  users.users.aw5qm = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$ri2PjuNqGIF06PqI$WssgBOSH7ibqXoVa3jhaRFCi9JCGNyZBI/7UHxBZbAFOZNSozAOqMph4xb0OorGc0M3inA9qAoaxrxg95f8TX0";
  };
  programs.fish.enable = true;

  # sudo
  security.sudo.wheelNeedsPassword = false;

  # フォント
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      hackgen-nf-font
      ibm-plex
      noto-fonts-cjk-sans
    ];
  };

  # Nix フレーク有効化
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Unfree パッケージ許可
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
