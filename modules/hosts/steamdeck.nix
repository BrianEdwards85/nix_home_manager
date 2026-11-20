{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.steamdeck = {
    imports = with hm; [
      common
      dev
      gui
      ham
    ];
    home.username = "deck";
  };

  flake.homeConfigurations.steamdeck = config.flake.lib.mkHome {
    name = "steamdeck";
    system = "x86_64-linux";
    modules = [ hm.steamdeck ];
  };
}
