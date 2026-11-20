{ inputs, ... }:
{
  # Build a standalone home-manager configuration for a host.
  flake.lib.mkHome =
    { system, modules }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit modules;
    };
}
