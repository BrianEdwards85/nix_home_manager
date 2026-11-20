# Work laptop (macOS, holds the YubiKey).
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.IT-USA-VF3086 =
    { config, ... }:
    {
      imports = with hm; [
        common
        dev
        gui
        ham
        indeed
        gpg
        gpg-agent-mac
      ];
      home.username = "bedwards";
      home.homeDirectory = "/Users/bedwards";

      # Also search ~/indeed when cd-ing.
      my.fish.extraCdPath = [ "${config.home.homeDirectory}/indeed" ];
    };

  flake.homeConfigurations.IT-USA-VF3086 = config.flake.lib.mkHome {
    system = "aarch64-darwin";
    modules = [ hm.IT-USA-VF3086 ];
  };
}
