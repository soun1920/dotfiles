{ ... }:

{
  systemd.user.services.tailscale-systray = {
    Unit = {
      Description = "Tailscale System Tray";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      # tailscale はシステムレベル (dnf) なので絶対パスで参照
      ExecStart = "/usr/bin/tailscale systray";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
