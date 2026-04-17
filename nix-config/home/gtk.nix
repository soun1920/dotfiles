{ pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Tela-circle-nord-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Nordic-cursors";
      package = pkgs.nordic;
    };
    font = {
      name = "IBM Plex Sans JP";
      size = 10;
    };
  };

  home.pointerCursor = {
    name = "Nordic-cursors";
    package = pkgs.nordic;
    size = 24;
    gtk.enable = true;
  };
}
