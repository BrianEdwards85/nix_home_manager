{ ... }:
{
  # gpg client with the public key. No local agent/scdaemon taking the socket;
  # a forwarded agent (wintermute) or the local one (mac) provides the card.
  flake.modules.homeManager.gpg = {
    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = ../../conf/gpg-pubkey.asc;
          trust = 5; # ultimate
        }
      ];
    };
  };

  # Laptop holding the YubiKey: local agent with SSH support.
  #
  # To forward the restricted agent socket to wintermute, add to the laptop's
  # programs.ssh (verify paths with `gpgconf --list-dirs agent-extra-socket`
  # locally and `ssh wintermute gpgconf --list-dirs agent-socket` remotely):
  #   enable = true; enableDefaultConfig = false;
  #   settings.wintermute = {
  #     ForwardAgent = "no";
  #     RemoteForward = "/run/user/1000/gnupg/S.gpg-agent <home>/.gnupg/S.gpg-agent.extra";
  #   };
  flake.modules.homeManager.gpg-agent-mac =
    { pkgs, ... }:
    {
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableFishIntegration = true;
        pinentry.package = pkgs.pinentry_mac;
      };
    };
}
