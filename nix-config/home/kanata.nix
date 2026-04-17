{ pkgs, ... }:

{
  xdg.configFile."kanata/kanata.kbd".source = ../configs/kanata/kanata.kbd;

  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      After = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata -c %h/.config/kanata/kanata.kbd";
      Restart = "no";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
