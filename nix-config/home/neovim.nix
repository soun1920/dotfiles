{ pkgs, ... }:

{
  xdg.configFile."nvim" = {
    source = ../configs/nvim;
    recursive = true;
  };
}
