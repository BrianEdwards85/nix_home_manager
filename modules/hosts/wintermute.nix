{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.wintermute = {
    imports = with hm; [
      common
      dev
      gpg
      indeed-fish # carried over from the old hostname == "bedwards" check
    ];
    home.username = "bedwards";
    home.homeDirectory = "/home/bedwards";
  };

  flake.homeConfigurations.wintermute = config.flake.lib.mkHome {
    system = "x86_64-linux";
    modules = [ hm.wintermute ];
  };
}
