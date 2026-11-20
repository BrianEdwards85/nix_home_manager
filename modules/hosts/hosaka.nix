{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.hosaka = {
    imports = with hm; [
      common
      dev
    ];
    home.username = "bedwards";
    home.homeDirectory = "/home/bedwards";
  };

  flake.homeConfigurations.hosaka = config.flake.lib.mkHome {
    system = "x86_64-linux";
    modules = [ hm.hosaka ];
  };
}
