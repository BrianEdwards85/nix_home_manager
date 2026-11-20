{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.term = {
    imports = with hm; [
      common
      dev
      ldev
    ];
    home.username = "bedwards";
  };

  flake.homeConfigurations.term = config.flake.lib.mkHome {
    name = "term";
    system = "x86_64-linux";
    modules = [ hm.term ];
  };
}
