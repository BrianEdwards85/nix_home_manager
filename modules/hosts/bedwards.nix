{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.bedwards = {
    imports = with hm; [
      common
      dev
      indeed
    ];
    home.username = "bedwards";
  };

  flake.homeConfigurations.bedwards = config.flake.lib.mkHome {
    name = "bedwards";
    system = "x86_64-linux";
    modules = [ hm.bedwards ];
  };
}
