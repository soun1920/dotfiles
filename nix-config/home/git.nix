{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "soun1920";
        email = "soun29300@gmail.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJ2rnT+2FqwL0Kvlc+mzYOcaH5jT5m0uMRxtYwp5pJn";
      };
      commit.gpgsign = true;
      gpg.format = "ssh";
      push.autoSetupRemote = true;
      credential = {
        "https://github.com".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
      };
    };
  };
}
