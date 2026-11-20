{ inputs, config, ... }:
let
  hm = config.flake.modules.homeManager;
  nx = config.flake.modules.nixos;
in
{
  # Settings for this server only. Shared settings live in modules/nixos.
  flake.modules.nixos.nixos =
    { ... }:
    {
      imports = [ ../../hosts/nixos/hardware-configuration.nix ];

      # Set once at install. Do NOT change it afterwards.
      system.stateVersion = "26.05";
    };

  flake.nixosConfigurations.nixos = config.flake.lib.mkNixos {
    name = "nixos";
    modules = with nx; [
      nixos-common
      nixos
    ];
  };

  flake.modules.homeManager.nixos = {
    imports = with hm; [
      common
      dev
    ];
    home.username = "bedwards";
  };

  flake.homeConfigurations.nixos = config.flake.lib.mkHome {
    name = "nixos";
    system = "aarch64-linux";
    modules = [ hm.nixos ];
  };
}
