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
    home.homeDirectory = "/home/bedwards";
  };

  flake.homeConfigurations.bedwards = config.flake.lib.mkHome {
    system = "x86_64-linux";
    modules = [ hm.bedwards ];
  };
}
