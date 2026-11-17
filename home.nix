{
  config,
  pkgs,
  lib,
  homeDir,
  hostname,
  username,
  features,
  ...
}:

let
  hasFeature = feature: builtins.elem feature features;
in
{
  imports = [
    ./programs
    ./packages
  ];
  nixpkgs.config.allowUnfree = true; 
  home.username = username;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;


  services.gpg-agent = lib.mkIf (hostname == "IT-USA-VF3086") {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  # Laptop (holds the YubiKey): forward the restricted agent socket to wintermute.
  # Verify local path with `gpgconf --list-dirs agent-extra-socket` and the remote
  # path with `ssh wintermute gpgconf --list-dirs agent-socket`.
#  programs.ssh = lib.mkIf (hostname == "IT-USA-VF3086") {
#    enable = true;
#    enableDefaultConfig = false;
#    settings.wintermute = {
#      ForwardAgent = "no";
#      RemoteForward = "/run/user/1000/gnupg/S.gpg-agent ${homeDir}/.gnupg/S.gpg-agent.extra";
#    };
#  };

  # wintermute (and laptop): gpg client. No local agent/scdaemon taking the socket;
  # the forwarded agent provides the card. Needs the public key to know the key.
  programs.gpg = lib.mkIf (hostname == "IT-USA-VF3086" || hasFeature "gpgremote") {
    enable = true;
    publicKeys = lib.optional (builtins.pathExists ./conf/gpg-pubkey.asc) {
      source = ./conf/gpg-pubkey.asc;
      trust = 5; # ultimate
    };
  };

home.file = {
  ".config/nvim" = {
    source = conf/nvim;
    recursive = true;
  };
  ".config/eza/theme.yml".source = conf/eza_tokyonight_storm.yml;
  ".config/git/delta".source = conf/git_delta.conf;
  ".config/fish/conf.d/tokyonight_storm.fish".source = conf/fish/tokyonight_storm.fish;
  ".ssh/rc" = {
    text = ''
      #!/bin/bash
      if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
        ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
      fi
    '';
    executable = true;
  };
  ".ssh/nix.config".source = conf/ssh.conf;
#  ".config/bat/themes/tokyonight_storm.tmTheme" = {
#      source = conf/bat_tokyonight_storm.tmTheme;
#      onChange = "bat cache --build";
#    };
# } // lib.optionalAttrs (hostname == "bedwards") {
#  ".zprofile".source = conf/zprofile;
};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shell.enableFishIntegration = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
