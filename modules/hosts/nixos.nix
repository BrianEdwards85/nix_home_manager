{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.nixos = {
    imports = with hm; [
      common
      dev
    ];
    home.username = "bedwards";
    home.homeDirectory = "/home/bedwards";
  };

  flake.homeConfigurations.nixos = config.flake.lib.mkHome {
    system = "aarch64-linux";
    modules = [ hm.nixos ];
  };
}
