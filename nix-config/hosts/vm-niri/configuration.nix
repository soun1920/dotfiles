{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./niri.nix
  ];

  # ブートローダー
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ネットワーク
  networking.hostName = "vm-niri";
  networking.networkmanager.enable = true;

  # タイムゾーン・ロケール
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
  };

  # 日本語入力
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # ユーザー
  users.users.aw5qm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.fish;
    hashedPassword = "$6$ri2PjuNqGIF06PqI$WssgBOSH7ibqXoVa3jhaRFCi9JCGNyZBI/7UHxBZbAFOZNSozAOqMph4xb0OorGc0M3inA9qAoaxrxg95f8TX0";
  };
  programs.fish.enable = true;

  # sudo
  security.sudo.wheelNeedsPassword = false;

  # サウンド (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH (ホストからアクセス用)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # フォント
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      hackgen-nf-font
      ibm-plex
      noto-fonts-cjk-sans
    ];
  };

  # OpenGL / GPU (niri に必須)
  hardware.graphics.enable = true;

  # QEMU ゲスト統合
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Unfree パッケージ許可
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
