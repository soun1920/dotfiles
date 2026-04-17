{ config, pkgs, zen-browser, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./ghostty.nix
    ./zellij.nix
    ./kanata.nix
    ./lazygit.nix
    ./neovim.nix
    ./fonts.nix
    ./gtk.nix
    ./services.nix
  ];

  home.username = "aw5qm";
  home.homeDirectory = "/home/aw5qm";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  xdg.configFile."zed/settings.json".source = ../configs/zed/settings.json;
  xdg.configFile."zed/keymap.json".source = ../configs/zed/keymap.json;

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    WASMTIME_HOME = "$HOME/.wasmtime";
    EDITOR = "nvim";
  };
}
