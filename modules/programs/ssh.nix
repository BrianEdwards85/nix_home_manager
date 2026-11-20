{ ... }:
{
  flake.modules.homeManager.ssh = {
    home.file.".ssh/rc" = {
      text = ''
        #!/bin/bash
        if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
          ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
        fi
      '';
      executable = true;
    };
    home.file.".ssh/nix.config".source = ../../conf/ssh.conf;
  };
}
