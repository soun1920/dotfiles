{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
        SetEnv TERM=xterm-256color

      Host intra
        Hostname intra.ns.kogakuin.ac.jp
        User ti596491
        PreferredAuthentications password
        PubkeyAuthentication no
    '';
  };
}
